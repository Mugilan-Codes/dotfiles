#!/usr/bin/env python3
"""Local safety patch: publication manifests and exclusive, contained exports."""
import hashlib
import json
import mimetypes
import os
from pathlib import Path
import stat
import subprocess
import sys
import tempfile
from urllib.parse import quote

BLOCKED = {'.git', '.hg', '.svn', '.herenow', '.ssh', '.aws', '.azure',
           '.config', '.codex', '.claude', '.agents', '.gemini', '.npm',
           'node_modules', '__pycache__', '.cache', '.ds_store', '.npmrc',
           '.pypirc', '.netrc', 'credentials', 'credentials.json', 'auth.json',
           'secrets', '.secret', 'id_rsa', 'id_ed25519', 'id_ecdsa'}


def excluded(path):
    return any((p.startswith('.') and p not in ('.well-known', '.nojekyll')) or p.lower() in BLOCKED or p.lower().startswith(('.env', '.secret'))
               or p.lower().endswith(('.pem', '.key', '.p12', '.pfx', '.sqlite', '.sqlite3', '.db', '.log'))
               for p in Path(path).parts)


def manifest(target):
    target = Path(os.path.abspath(target))
    if target.is_symlink():
        raise ValueError('publication target must not be a symlink')
    files = []
    if target.is_file():
        if excluded(target.name):
            raise ValueError('refusing sensitive single-file publication')
        files = [target]
    elif target.is_dir():
        for root, dirs, names in os.walk(target, followlinks=False):
            dirs[:] = sorted(d for d in dirs if not excluded(d) and not (Path(root)/d).is_symlink())
            files.extend(Path(root)/n for n in sorted(names)
                         if not excluded(n) and not (Path(root)/n).is_symlink())
    else:
        raise ValueError('publication target must be a regular file or directory')
    result, mapping = [], {}
    for path in files:
        if not stat.S_ISREG(path.stat().st_mode):
            raise ValueError('non-regular publication file')
        rel = str(path.relative_to(target)) if target.is_dir() else path.name
        if any(ord(c) < 32 for c in rel):
            raise ValueError('control characters in publication filename')
        data = path.read_bytes()
        result.append(dict(path=rel, size=len(data), contentType=mimetypes.guess_type(rel)[0] or 'application/octet-stream', hash=hashlib.sha256(data).hexdigest()))
        mapping[rel] = str(path)
    return {'files': result, 'map': mapping}


def components(path):
    if not isinstance(path, str) or not path or path.startswith('/') or '\\' in path or any(ord(c) < 32 or ord(c) == 127 for c in path):
        raise ValueError('unsafe export path')
    parts = path.split('/')
    if any(p in ('', '.', '..') for p in parts):
        raise ValueError('unsafe export path component')
    return parts


def open_directory(parts, create):
    fd = os.open('/', os.O_RDONLY | os.O_DIRECTORY)
    try:
        for part in parts:
            if create:
                try:
                    os.mkdir(part, 0o700, dir_fd=fd)
                except FileExistsError:
                    pass
            nxt = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=fd)
            os.close(fd)
            fd = nxt
        return fd
    except BaseException:
        os.close(fd)
        raise


def export_page(page, prefix, target, base, dry, auth):
    prefix = prefix.rstrip('/')
    if prefix:
        components(prefix)
    # Normalize the user-selected root only; never resolve symlinks or normalize server paths.
    absolute = os.path.abspath(target)
    root = components(absolute[1:])
    paths = []
    for item in page['files']:
        path = item['path']
        components(path)
        if prefix and not path.startswith(prefix + '/'):
            raise ValueError('server returned path outside requested prefix')
        rel = path[len(prefix)+1:] if prefix else path
        paths.append((path, components(rel)))
    if len({tuple(parts) for _, parts in paths}) != len(paths):
        raise ValueError('duplicate export path')
    for path, parts in paths:
        if dry:
            # Existing ancestors must be safe; missing ancestors are acceptable.
            for count in range(1, len(root + parts)):
                try:
                    fd = open_directory((root + parts)[:count], False)
                except FileNotFoundError:
                    break
                else:
                    os.close(fd)
            leaf = Path('/').joinpath(*root, *parts)
            if os.path.lexists(leaf):
                raise FileExistsError('export destination already exists')
            print('would export ' + path)
            continue
        fd = open_directory(root + parts[:-1], True)
        try:
            try:
                os.stat(parts[-1], dir_fd=fd, follow_symlinks=False)
            except FileNotFoundError:
                pass
            else:
                raise FileExistsError('export destination already exists')
            # Curl writes only an anonymous temporary file; failures never expose partial output.
            with tempfile.TemporaryFile() as download:
                subprocess.run(['curl', '-fsS', base + '/' + quote(path, safe='/'), *auth], stdout=download, check=True)
                download.seek(0)
                # O_EXCL also refuses destination symlinks created during the download.
                out = os.open(parts[-1], os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600, dir_fd=fd)
                try:
                    with os.fdopen(out, 'wb') as dest:
                        while True:
                            chunk = download.read(1024 * 1024)
                            if not chunk:
                                break
                            dest.write(chunk)
                except BaseException:
                    os.unlink(parts[-1], dir_fd=fd)
                    raise
        finally:
            os.close(fd)
    return len(paths)


if __name__ == '__main__':
    try:
        if sys.argv[1] == 'manifest':
            print(json.dumps(manifest(sys.argv[2])))
        elif sys.argv[1] == 'export':
            print(export_page(json.load(sys.stdin), sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5] == '1', sys.argv[6:]))
        else:
            raise ValueError('unknown operation')
    except (ValueError, OSError, KeyError, subprocess.CalledProcessError) as error:
        # Do not echo subprocess arguments: they may contain authorization headers.
        print('safe-files: refused or failed operation (' + type(error).__name__ + ')', file=sys.stderr)
        sys.exit(1)
