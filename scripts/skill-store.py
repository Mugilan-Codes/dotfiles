#!/usr/bin/env python3
"""Explicit skill imports and provenance for scripts/agent-skills; never executes skills."""
import argparse
import hashlib
import io
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parent.parent
PACKAGE = ROOT / 'agents'
SKILLS = PACKAGE / '.agents/skills'
MANIFEST = PACKAGE / 'skills-manifest.json'
EXTERNAL = PACKAGE / 'external-skills.json'
PRIVATE_NAMES = {
    '.git', '.herenow', '__pycache__', 'node_modules', '.cache', 'sessions',
    'auth.json', 'credentials.json', '.ds_store', '.npmrc', '.netrc', '.pypirc',
    '.ssh', '.aws', '.codex', '.claude', '.secret', 'secrets', '.dotfiles-backups',
}
PRIVATE_SUFFIXES = ('.pyc', '.db', '.sqlite', '.sqlite3', '.log', '.pem', '.key')


def load():
    return json.loads(MANIFEST.read_text())


def digest(directory):
    # Match the existing skills-lock.json hash algorithm, including relative names.
    value = hashlib.sha256()
    for path in sorted(directory.rglob('*'), key=lambda p: str(p.relative_to(directory)).lower()):
        if path.is_file():
            value.update(str(path.relative_to(directory)).encode())
            value.update(path.read_bytes())
    return value.hexdigest()


def validate_package(directory, name):
    if not re.fullmatch(r'[a-z0-9]+(?:-[a-z0-9]+)*', name) or name.startswith('framer-project-'):
        raise ValueError('unsafe or reserved skill name')
    if directory.is_symlink() or not directory.is_dir():
        raise ValueError('source must be a real directory')
    for path in directory.rglob('*'):
        if path.is_symlink():
            raise ValueError('imports require self-contained regular files; symlinks are not imported')
        if not (path.is_file() or path.is_dir()):
            raise ValueError('special file in skill package')
        relative = path.relative_to(directory)
        if any(p in PRIVATE_NAMES or p.startswith(('.env', 'framer-project-')) or p.endswith(PRIVATE_SUFFIXES)
               for p in map(str.casefold, relative.parts)):
            raise ValueError('runtime/private content in skill package: ' + str(relative))
        if any(ord(c) < 32 for c in str(relative)):
            raise ValueError('control character in package path')
    for path in directory.rglob('*'):
        if path.is_file():
            data = path.read_bytes()
            if re.search(rb'-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----|gh[pousr]_[A-Za-z0-9]{30,}|AKIA[0-9A-Z]{16}', data):
                raise ValueError('suspected secret in package file: ' + str(path.relative_to(directory)))
    text = (directory / 'SKILL.md').read_text()
    match = re.match(r'\A---\n(.*?)\n---(?:\n|$)', text, re.S)
    if not match:
        raise ValueError('missing SKILL.md frontmatter')
    fields = dict(re.findall(r'^([a-z]+):\s*(.*?)\s*$', match[1], re.M))
    if fields.get('name', '').strip('\"\'') != name or not fields.get('description', '').strip('\"\''):
        raise ValueError('frontmatter name/description invalid')


def owners():
    return json.loads(EXTERNAL.read_text())


def owner_for(name):
    return next((x for x in owners()['owners'] if name in x['skills']), None)


def inventory(target):
    manifest = load()
    for name, item in sorted(manifest.items()):
        print('managed\t' + name + '\t' + item['ownership'])
    runtime = target / '.agents/skills'
    for path in sorted(runtime.iterdir()) if runtime.is_dir() else []:
        if path.name in manifest:
            continue
        owner = owner_for(path.name)
        category = 'external:' + owner['id'] if owner else 'generated/private' if path.name.startswith('framer-project-') else 'unmanaged:review'
        print(category + '\t' + path.name)
    for owner in owners()['owners']:
        print('external-owner\t' + owner['id'] + '\t' + owner['restoration'])


def check(target, source_only=False):
    manifest = load()
    actual = {p.name for p in SKILLS.iterdir() if p.is_dir()}
    if actual != set(manifest):
        raise ValueError('manifest and source inventory differ')
    problems = []
    for name, entry in manifest.items():
        try:
            validate_package(SKILLS / name, name)
            if digest(SKILLS / name) != entry['sha256']:
                raise ValueError('content drift')
            for field in ('origin', 'revision', 'agents', 'dependencies', 'patches', 'license', 'ownership'):
                if field not in entry:
                    raise ValueError('missing provenance field: ' + field)
            if not isinstance(entry['origin'], str) or not entry['origin'].strip() or not entry['license']:
                raise ValueError('empty origin/license')
            if not entry['agents'] or set(entry['agents']) - {'codex', 'claude-code'}:
                raise ValueError('invalid supported agents')
            if entry['revision'] is not None and not re.fullmatch('[0-9a-f]{40}', entry['revision']):
                raise ValueError('revision must be a full commit or null')
            if not all(isinstance(entry[x], list) for x in ('dependencies', 'patches', 'agents')):
                raise ValueError('invalid provenance lists')
            link = PACKAGE / '.claude/skills' / name
            if 'claude-code' in entry['agents']:
                if not link.is_symlink() or link.resolve() != (SKILLS / name).resolve():
                    raise ValueError('invalid tracked Claude compatibility link')
            elif os.path.lexists(link):
                raise ValueError('unexpected tracked Claude compatibility link')
            if not source_only:
                for rel in ['.agents/skills'] + (['.claude/skills'] if 'claude-code' in entry['agents'] else []):
                    dest = target / rel / name
                    if not dest.is_symlink() or not dest.is_dir() or dest.resolve() != (SKILLS / name).resolve():
                        raise ValueError('missing/wrong managed runtime link: ' + rel)
                if os.path.lexists(target / '.codex/skills' / name):
                    raise ValueError('duplicate under application-managed Codex skills')
                if 'claude-code' not in entry['agents'] and os.path.lexists(target / '.claude/skills' / name):
                    raise ValueError('Codex-only skill exposed to Claude')
        except (ValueError, OSError) as error:
            problems.append(name + ': ' + str(error))
    if problems:
        raise ValueError('\n'.join(problems))
    if not source_only:
        for rel in ('.agents/skills', '.claude/skills'):
            if not (target / rel).is_dir() or (target / rel).is_symlink():
                raise ValueError('runtime parent must be a real directory: ' + rel)
        inventory(target)
    print('CHECK PASSED: provenance, hashes, package safety' + ('' if source_only else ', managed links'))


def acquire(args, stage):
    if args.from_dir:
        source = Path(args.from_dir).expanduser().absolute()
        if any(p in ('plugins', 'cache', '.system') for p in source.parts):
            raise ValueError('plugin/system/cache content must be restored by its owner')
        if source.is_symlink():
            raise ValueError('resolve and review the explicit canonical directory before importing')
        if not args.origin:
            raise ValueError('--origin is required; do not invent local authorship')
        return source, args.origin, None
    if not args.repo or not args.revision or not args.subdir:
        raise ValueError('provide --from-dir and --origin, or --repo --revision --subdir')
    url = urlparse(args.repo)
    if url.scheme != 'https' or url.netloc != 'github.com' or not re.fullmatch(r'/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(?:\.git)?', url.path) or url.query or url.fragment:
        raise ValueError('repository source must be a credential-free public GitHub HTTPS URL')
    if not re.fullmatch('[0-9a-f]{40}', args.revision):
        raise ValueError('pin a full 40-character commit revision')
    if args.subdir.startswith('/') or any(p in ('', '.', '..') for p in args.subdir.split('/')):
        raise ValueError('unsafe skill subdirectory')
    env = dict(os.environ, GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_SYSTEM=os.devnull, GIT_CONFIG_NOSYSTEM='1', GIT_TERMINAL_PROMPT='0')
    # No checkout, hooks, submodules or skill execution. Strip inherited Git overrides.
    for key in list(env):
        if key.startswith('GIT_') and key not in ('GIT_CONFIG_GLOBAL', 'GIT_CONFIG_SYSTEM', 'GIT_CONFIG_NOSYSTEM', 'GIT_TERMINAL_PROMPT'):
            del env[key]
    bare = stage / 'upstream.git'
    subprocess.run(['git', '-c', 'core.hooksPath=/dev/null', 'clone', '--bare', '--', args.repo, str(bare)], env=env, check=True)
    archive = subprocess.check_output(['git', '--git-dir=' + str(bare), 'archive', args.revision, '--', args.subdir], env=env)
    out = stage / 'source'
    out.mkdir()
    with tarfile.open(fileobj=io.BytesIO(archive)) as tar:
        for member in tar:
            path = Path(member.name)
            if path.is_absolute() or '..' in path.parts or not (member.isdir() or member.isfile()):
                raise ValueError('archive contains unsafe paths/links/special files')
            dest = out / path
            if member.isdir():
                dest.mkdir(parents=True, exist_ok=True)
            else:
                dest.parent.mkdir(parents=True, exist_ok=True)
                with tar.extractfile(member) as data, dest.open('xb') as file:
                    shutil.copyfileobj(data, file)
                dest.chmod(0o755 if member.mode & 0o111 else 0o644)
    return out / args.subdir, args.repo + '#' + args.subdir, args.revision


def change(args):
    manifest = load()
    name = args.name
    if owner_for(name):
        raise ValueError('external-owner skill: restore through its installer; do not vendor a duplicate')
    if args.command == 'update':
        if name not in manifest:
            raise ValueError('unknown managed skill')
        if (manifest[name]['patches'] or manifest[name]['ownership'] in ('local', 'fork')) and not args.reviewed_patches:
            raise ValueError('local/fork patches require explicit --reviewed-patches describing how the candidate preserves or supersedes them')
        if digest(SKILLS / name) != manifest[name]['sha256']:
            raise ValueError('local changes detected; review before update')
    elif name in manifest or os.path.lexists(SKILLS / name) or os.path.lexists(PACKAGE / '.claude/skills' / name):
        raise ValueError('managed name collision')
    elif args.command != 'import' and any(os.path.lexists(args.target / p / name) for p in ('.agents/skills', '.claude/skills', '.codex/skills')):
        raise ValueError('runtime name collision; review and use explicit import instead')
    if not args.license:
        raise ValueError('--license is required: package license path or honest provenance/license note')
    with tempfile.TemporaryDirectory(prefix='dotfiles-skill-') as temp:
        stage = Path(temp)
        source, origin, revision = acquire(args, stage)
        if args.command == 'import' and source.resolve() != (args.target / '.agents/skills' / name).resolve():
            raise ValueError('import source must be the named installed universal skill')
        validate_package(source, name)
        candidate = stage / 'candidate'
        shutil.copytree(source, candidate, symlinks=True)
        validate_package(candidate, name)
        if args.license_file:
            license_file = Path(args.license_file)
            if not license_file.is_file() or license_file.is_symlink():
                raise ValueError('license file must be regular')
            dest = candidate / 'LICENSE.imported'
            if dest.exists():
                raise ValueError('LICENSE.imported collision')
            shutil.copyfile(license_file, dest)
        entry = dict(origin=origin, revision=revision, sha256=digest(candidate), agents=(args.agents.split(',') if args.agents else manifest.get(name, {}).get('agents', ['codex', 'claude-code'])), dependencies=(args.dependency if args.dependency is not None else manifest.get(name, {}).get('dependencies', [])), patches=([dict(note=args.reviewed_patches, evidence=origin)] if args.reviewed_patches else []), license=args.license, ownership=manifest.get(name, {}).get('ownership', 'imported'))
        if set(entry['agents']) - {'codex', 'claude-code'} or 'codex' not in entry['agents']:
            raise ValueError('--agents must include codex, optionally claude-code')
        # All validation precedes writes. Snapshot touched sources for rollback on failure.
        files = [MANIFEST, PACKAGE / 'SKILLS_REGISTRY.md', PACKAGE / 'THIRD_PARTY.md', PACKAGE / 'skills-lock.json']
        snapshots = {p: p.read_bytes() for p in files}
        link = PACKAGE / '.claude/skills' / name
        previous_link = os.readlink(link) if link.is_symlink() else None
        original = stage / 'original'
        existed = (SKILLS / name).exists()
        if existed:
            shutil.copytree(SKILLS / name, original)
        try:
            if existed:
                shutil.rmtree(SKILLS / name)
            shutil.copytree(candidate, SKILLS / name)
            if link.is_symlink():
                link.unlink()
            if 'claude-code' in entry['agents']:
                link.symlink_to('../../.agents/skills/' + name)
            manifest[name] = entry
            lock_path = PACKAGE / 'skills-lock.json'
            lock = json.loads(lock_path.read_text())
            if name in lock['skills']:
                expected_url = 'https://github.com/' + lock['skills'][name]['source']
                if args.repo and args.repo.removesuffix('.git') != expected_url:
                    raise ValueError('vendor source change requires separate ownership review')
                lock['skills'][name]['computedHash'] = entry['sha256']
                lock_path.write_text(json.dumps(lock, indent=2) + '\n')
            MANIFEST.write_text(json.dumps(manifest, indent=2, sort_keys=True) + '\n')
            registry = PACKAGE / 'SKILLS_REGISTRY.md'
            lines = registry.read_text().splitlines()
            row = '| `' + name + '` | ' + entry['ownership'] + ' | See skills-manifest.json | ' + ', '.join(entry['agents']) + ' | See manifest | Explicit agent-skills lifecycle | Reviewed complete package |'
            previous = next((i for i, line in enumerate(lines) if line.startswith('| `' + name + '` |')), None)
            if previous is not None:
                lines[previous] = row
            else:
                index = next(i for i, line in enumerate(lines) if line.startswith('| `'))
                while index < len(lines) and lines[index].startswith('|'):
                    index += 1
                lines.insert(index, row)
            registry.write_text('\n'.join(lines) + '\n')
            with (PACKAGE / 'THIRD_PARTY.md').open('a') as file:
                file.write('\n### Reviewed import: ' + name + '\n\nOrigin: ' + origin + '\n\nLicense: ' + args.license + '\n\nRevision: ' + (revision or 'unknown/local; no upstream revision claimed') + '\n')
            check(args.target, source_only=True)
        except BaseException:
            shutil.rmtree(SKILLS / name, ignore_errors=True)
            if existed:
                shutil.copytree(original, SKILLS / name)
            if link.is_symlink():
                link.unlink()
            if previous_link:
                link.symlink_to(previous_link)
            for path, data in snapshots.items():
                path.write_bytes(data)
            raise
    print('IMPORTED: ' + name + '; review diff, then explicitly deploy. Runtime siblings preserved.')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('command', choices=('list', 'check', 'add', 'add-repo', 'import', 'update', 'record-patch', 'deploy'))
    parser.add_argument('name', nargs='?')
    parser.add_argument('--target', type=Path, default=Path.home())
    parser.add_argument('--source-only', action='store_true')
    parser.add_argument('--from-dir')
    parser.add_argument('--origin')
    parser.add_argument('--repo')
    parser.add_argument('--revision')
    parser.add_argument('--subdir')
    parser.add_argument('--license')
    parser.add_argument('--license-file')
    parser.add_argument('--agents')
    parser.add_argument('--reviewed-patches')
    parser.add_argument('--dependency', action='append')
    parser.add_argument('--note')
    parser.add_argument('--dry-run', action='store_true')
    parser.add_argument('--backup', action='store_true')
    args = parser.parse_args()
    if args.command == 'list':
        inventory(args.target)
    elif args.command == 'check':
        check(args.target, args.source_only)
    elif args.command == 'deploy':
        from deploy import deploy
        check(args.target, source_only=True)
        deploy(args.target, 'dry' if args.dry_run else 'install', args.backup, packages=('agents',))
    elif args.command == 'record-patch':
        manifest = load()
        if args.name not in manifest or not args.note or not args.origin:
            raise ValueError('record-patch requires a managed name, --note and --origin review evidence')
        validate_package(SKILLS / args.name, args.name)
        manifest[args.name]['patches'].append(dict(note=args.note, evidence=args.origin))
        manifest[args.name]['sha256'] = digest(SKILLS / args.name)
        MANIFEST.write_text(json.dumps(manifest, indent=2, sort_keys=True) + '\n')
        lock_path = PACKAGE / 'skills-lock.json'
        lock = json.loads(lock_path.read_text())
        if args.name in lock['skills']:
            lock['skills'][args.name]['computedHash'] = manifest[args.name]['sha256']
            lock_path.write_text(json.dumps(lock, indent=2) + '\n')
        print('RECORDED REVIEW: ' + args.name + '; inspect provenance and hash diff')
    else:
        if not args.name:
            parser.error('skill name required')
        if args.command == 'add-repo' and args.from_dir:
            parser.error('add-repo requires a pinned repository source')
        if args.command == 'import' and not args.from_dir:
            parser.error('import requires explicit --from-dir of installed skill')
        change(args)


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError, subprocess.CalledProcessError, KeyError) as error:
        print('FAILED: ' + str(error), file=sys.stderr)
        sys.exit(1)
