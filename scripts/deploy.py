#!/usr/bin/env python3
"""Stow deployment with conflict preflight and explicit reversible replacement."""
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
PACKAGES = ('zsh', 'tmux', 'git', 'starship', 'agents')


def desired(packages=PACKAGES):
    items = {}
    for package in packages:
        base = ROOT / package
        def walk(directory):
            for path in sorted(directory.iterdir()):
                rel = path.relative_to(base)
                if not rel.parts[0].startswith('.') or rel.name == '.stow-local-ignore':
                    continue
                if path.is_dir() and not path.is_symlink() and rel.parent != Path('.agents/skills'):
                    walk(path)
                else:
                    items[str(rel)] = path
        walk(base)
    return items


def exists(path):
    return os.path.lexists(path)


def conflicts(target, items):
    found = set()
    for rel, source in items.items():
        dest = target / rel
        for parent in list(dest.parents)[:-1]:
            if parent == target.parent:
                break
            if parent == target:
                continue
            if exists(parent) and (parent.is_symlink() or not parent.is_dir()):
                # Existing Stow folding is valid only when it resolves to this source.
                if dest.resolve() != source.resolve():
                    found.add(parent)
        if exists(dest) and not (dest.is_symlink() and dest.resolve() == source.resolve()):
            # An existing parent Stow link can make the leaf a real file in source.
            if dest.resolve() != source.resolve():
                found.add(dest)
    return sorted((p for p in found if not any(q in p.parents for q in found)), key=str)


def write_record(path, record):
    temp = path.with_suffix('.tmp')
    temp.write_text(json.dumps(record, indent=2) + '\n')
    temp.replace(path)


def restore(record_path):
    record_path = Path(record_path).resolve()
    record = json.loads(record_path.read_text())
    target = Path(record['target'])
    # Refuse all conflicts before restoring anything; records are local trusted artifacts.
    for item in record['backups']:
        backup = record_path.parent / item['backup']
        if not exists(backup):
            raise ValueError('restore backup is missing: ' + str(backup))
    for item in record['links']:
        dest = target / item['path']
        if exists(dest) and (not dest.is_symlink() or os.readlink(dest) != item['link']):
            raise ValueError('restore refuses changed destination: ' + str(dest))
    created_dirs = set(record['directories'])
    for directory in created_dirs:
        p = Path(directory)
        if p.is_symlink() or (exists(p) and not p.is_dir()):
            raise ValueError('restore refuses changed directory: ' + directory)
        if p.is_dir():
            expected = {str(target / x['path']) for x in record['links']} | created_dirs
            if any(str(x) not in expected for x in p.iterdir()):
                raise ValueError('restore refuses directory with new content: ' + directory)
    for item in record['backups']:
        dest = target / item['path']
        if exists(dest) and str(dest) not in created_dirs and not any(x['path'] == item['path'] for x in record['links']):
            raise ValueError('restore refuses occupied original: ' + str(dest))
    for item in reversed(record['links']):
        dest = target / item['path']
        if dest.is_symlink():
            dest.unlink()
    for name in reversed(record['directories']):
        p = Path(name)
        if p.is_dir():
            p.rmdir()
    for item in record['backups']:
        backup = record_path.parent / item['backup']
        backup.rename(target / item['path'])
    print('RESTORED: ' + str(record_path))


def shell_sources(target, mode):
    for item in json.loads((ROOT / 'shell-sources.json').read_text()):
        dest = target / item['destination']
        if (dest / item['probe']).is_file():
            print('COMPLETED: ' + item['name'] + ' (existing installation retained)')
            continue
        if mode == 'dry':
            print('WOULD CLONE: ' + item['name'] + ' at ' + item['revision'])
            continue
        if mode == 'check':
            raise ValueError('missing shell integration: ' + item['name'])
        if any(p.is_symlink() for p in [dest, *dest.parents]):
            raise ValueError('shell integration destination crosses a symlink')
        if exists(dest):
            raise ValueError('incomplete existing integration; inspect manually: ' + str(dest))
        dest.parent.mkdir(parents=True, exist_ok=True)
        env = dict(os.environ, GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_SYSTEM=os.devnull, GIT_CONFIG_NOSYSTEM='1', GIT_TERMINAL_PROMPT='0')
        for key in list(env):
            if key.startswith('GIT_') and key not in ('GIT_CONFIG_GLOBAL', 'GIT_CONFIG_SYSTEM', 'GIT_CONFIG_NOSYSTEM', 'GIT_TERMINAL_PROMPT'):
                del env[key]
        with tempfile.TemporaryDirectory(prefix='dotfiles-shell-') as temporary:
            clone = Path(temporary) / 'clone'
            subprocess.run(['git', '-c', 'core.hooksPath=/dev/null', 'clone', '--no-checkout', item['url'], str(clone)], env=env, check=True)
            subprocess.run(['git', '-C', str(clone), '-c', 'core.hooksPath=/dev/null', 'checkout', '--detach', item['revision']], env=env, check=True)
            shutil.copytree(clone, dest, symlinks=True)
        print('COMPLETED: ' + item['name'])


def deploy(target, mode, backup=False, packages=PACKAGES):
    target = Path(os.path.abspath(target))
    if target == ROOT or ROOT in target.parents:
        raise ValueError('deployment target must be outside the repository')
    if target.is_symlink() or any(p.is_symlink() for p in target.parents):
        raise ValueError('target and ancestors must be real directories (use /private/tmp, not /tmp)')
    items = desired(packages)
    bad = conflicts(target, items)
    if bad and not backup:
        raise ValueError('conflicting destinations (use --backup after review): ' + ', '.join(str(p) for p in bad))
    stow = shutil.which('stow')
    if not stow:
        raise ValueError('stow is required')
    if mode == 'check':
        missing = [rel for rel, source in items.items() if not exists(target / rel) or (target / rel).resolve() != source.resolve()]
        # Skills and runtime parents must not be folded into repository directories.
        for rel in ('.agents/skills', '.claude/skills', '.codex'):
            if (target / rel).is_symlink() or not (target / rel).is_dir():
                missing.append(rel + ' (real parent required)')
        if missing or bad:
            raise ValueError('missing/wrong deployment: ' + ', '.join(missing))
        print('CHECK PASSED: managed links and instruction destinations')
        return
    if mode == 'dry':
        print('WOULD DEPLOY: ' + ', '.join(packages) + ' -> ' + str(target))
        for p in bad:
            print('WOULD BACK UP: ' + str(p))
        if target.is_dir() and not bad:
            subprocess.run([stow, '--dir=' + str(ROOT), '--target=' + str(target), '--simulate', *packages], check=True)
        return
    if not bad and all(exists(target / rel) and (target / rel).resolve() == source.resolve() for rel, source in items.items()):
        deploy(target, 'check', packages=packages)
        print('SKIPPED: deployment already complete')
        return
    target.mkdir(parents=True, exist_ok=True)
    # Journal every operation; partial failure leaves a recovery record.
    backup_root = target / '.dotfiles-backups'
    if backup_root.is_symlink():
        raise ValueError('backup root must not be a symlink')
    backup_root.mkdir(mode=0o700, exist_ok=True)
    run = Path(tempfile.mkdtemp(prefix='deploy-', dir=backup_root))
    record_path = run / 'restore.json'
    record = dict(target=str(target), backups=[], links=[], directories=[])
    write_record(record_path, record)
    print('RESTORE RECORD: ' + str(record_path), flush=True)
    for i, dest in enumerate(bad):
        entry = dict(path=str(dest.relative_to(target)), backup=str(i))
        record['backups'].append(entry)
        write_record(record_path, record)
        dest.rename(run / str(i))
    # Precreate real parents so Stow owns precise leaves and skill directories.
    parents = {target / '.codex', target / '.agents/skills', target / '.claude/skills'}
    for rel in items:
        parents.update(p for p in (target / rel).parents if p != target and target in p.parents)
    for parent in sorted(parents, key=lambda p: len(p.parts)):
        if not exists(parent):
            parent.mkdir()
            record['directories'].append(str(parent))
            write_record(record_path, record)
    before = {rel: exists(target / rel) for rel in items}
    subprocess.run([stow, '--dir=' + str(ROOT), '--target=' + str(target), '--simulate', *packages], check=True)
    try:
        subprocess.run([stow, '--dir=' + str(ROOT), '--target=' + str(target), *packages], check=True)
    finally:
        for rel in items:
            dest = target / rel
            if not before[rel] and dest.is_symlink():
                record['links'].append(dict(path=rel, link=os.readlink(dest)))
        write_record(record_path, record)
    deploy(target, 'check', packages=packages)
    print('COMPLETED: deployment; optional applications, credentials and integrations are manual.')


def main():
    parser = argparse.ArgumentParser()
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument('--dry-run', action='store_true')
    modes.add_argument('--check', action='store_true')
    parser.add_argument('--target', type=Path)
    parser.add_argument('--backup', action='store_true')
    parser.add_argument('--restore', type=Path)
    args = parser.parse_args()
    if args.restore:
        if args.dry_run or args.check or args.backup or args.target:
            parser.error('--restore is a standalone operation')
        restore(args.restore)
        return
    subprocess.run([sys.executable, '-B', str(ROOT / 'scripts/skill-store.py'), 'check', '--source-only'], check=True)
    mode = 'dry' if args.dry_run else 'check' if args.check else 'install'
    target = args.target or Path.home()
    if args.target is None:
        # Preflight before any shell clone; no incidental upgrades to existing clones.
        bad = conflicts(target, desired())
        if bad and not args.backup:
            raise ValueError('conflicts: ' + ', '.join(map(str, bad)))
        shell_sources(target, mode)
    else:
        print('ISOLATED TARGET: package installation and shell downloads skipped.')
    deploy(target, mode, args.backup)


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        print('FAILED: ' + str(error), file=sys.stderr)
        sys.exit(1)
