#!/usr/bin/env python3
"""Stow deployment with conflict preflight and explicit reversible replacement."""
import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
CONFIG_FILES = {
    'zsh': ('.zshenv', '.zprofile', '.zshrc', '.zlogin',
            '.oh-my-zsh/custom/aliases.zsh', '.oh-my-zsh/custom/functions.zsh',
            '.oh-my-zsh/custom/completions.zsh'),
    'tmux': ('.tmux.conf',),
    'git': ('.gitconfig', '.gitignore-global'),
    'starship': ('.config/starship.toml',),
}
PACKAGES = (*CONFIG_FILES, 'agents')
AGENT_PARENTS = {Path(p) for p in ('.agents', '.agents/skills', '.claude', '.claude/skills', '.codex')}
BACKUPS = '.dotfiles-backups'


def desired(packages=PACKAGES):
    items = {}
    for package in packages:
        if package != 'agents':
            items.update((rel, ROOT / package / rel) for rel in CONFIG_FILES[package])
            continue
        items.update((rel, ROOT / package / rel) for rel in ('.codex/AGENTS.md', '.claude/CLAUDE.md'))
        manifest = json.loads((ROOT / package / 'skills-manifest.json').read_text())
        for name, entry in manifest.items():
            rel = '.agents/skills/' + name
            items[rel] = ROOT / package / rel
            if 'claude-code' in entry['agents']:
                rel = '.claude/skills/' + name
                items[rel] = ROOT / package / rel
    for rel, source in items.items():
        if any(p.is_symlink() for p in reversed(source.parents) if ROOT in p.parents):
            raise ValueError('missing source or symlinked source parent: ' + rel)
        if rel.startswith('.claude/'):
            expected = ('../.codex/AGENTS.md' if rel == '.claude/CLAUDE.md'
                        else '../../.agents/skills/' + source.name)
            if not source.is_symlink() or os.readlink(source) != expected:
                raise ValueError('wrong Claude compatibility link: ' + rel)
        elif source.is_symlink() or not (source.is_dir() if rel.startswith('.agents/skills/') else source.is_file()):
            raise ValueError('missing or wrong deployment source: ' + rel)
    return items


def exists(path):
    return os.path.lexists(path)


def link_points_to(dest, source):
    return dest.is_symlink() and Path(os.path.abspath(dest.parent / os.readlink(dest))) == source


def conflicts(target, items, real_parents):
    found = set()
    for rel, source in items.items():
        path = Path(rel)
        dest = target / path
        for relative, original in reversed(list(zip(path.parents, source.parents))[:-1]):
            parent = target / relative
            if exists(parent) and (parent.is_symlink() or not parent.is_dir()):
                if relative in real_parents or not link_points_to(parent, original):
                    found.add(parent)
                break
        else:
            if exists(dest) and not link_points_to(dest, source):
                found.add(dest)
    return sorted((p for p in found if not any(q in p.parents for q in found)), key=str)


def validate_target(target):
    if target == ROOT or ROOT in target.parents:
        raise ValueError('deployment target must be outside the repository')
    for parent in (*reversed(target.parents), target):
        if exists(parent) and (parent.is_symlink() or not parent.is_dir()):
            raise ValueError('target and ancestors must be real directories: ' + str(parent))


def run_stow(stow, target, items, packages, simulate=False):
    paths = {Path(rel) for rel in items}
    paths.update(parent for path in tuple(paths) for parent in path.parents if parent != Path('.'))
    allowed = '|'.join(re.escape(str(path)) for path in sorted(paths))
    # Use a neutral system directory so user Stow defaults cannot enable adoption,
    # override the managed paths or fold agent parents differently.
    command = [stow, '--dir=' + str(ROOT), '--target=' + str(target),
               r'--ignore=\A(?!(?:' + allowed + r')\z).*']
    if simulate:
        command.append('--simulate')
    subprocess.run([*command, *packages], cwd='/var/empty',
                   env=dict(os.environ, HOME='/var/empty'), check=True)


def write_record(path, record):
    temp = path.with_suffix('.tmp')
    temp.write_text(json.dumps(record, indent=2) + '\n')
    temp.replace(path)


def identity(path):
    info = path.lstat()
    return [info.st_dev, info.st_ino]


def restore(record_path):
    record_path = Path(os.path.abspath(record_path))
    validate_target(record_path.parent)
    if record_path.is_symlink():
        raise ValueError('restore record must be a real file')
    record = json.loads(record_path.read_text())
    target = Path(record['target'])
    if not target.is_absolute() or record_path.parent.parent != target / BACKUPS:
        raise ValueError('restore record must stay under its original target backup root')
    validate_target(target)

    def destination(rel):
        path = Path(rel)
        if path.is_absolute() or '..' in path.parts or not path.parts or path.parts[0] == BACKUPS:
            raise ValueError('invalid restore destination: ' + rel)
        return target / path

    links = {destination(item['path']): item['link'] for item in record['links']}
    directories = []
    for name in record['directories']:
        directories.append(destination(str(Path(name).relative_to(target))))
    originals = []
    untouched = set()
    for item in record['backups']:
        if not re.fullmatch(r'[0-9]+', item['backup']):
            raise ValueError('invalid restore backup name')
        dest = destination(item['path'])
        validate_target(dest.parent)
        backup = record_path.parent / item['backup']
        if not exists(backup):
            if 'identity' in item and exists(dest) and identity(dest) == item['identity']:
                # The move either never happened or an earlier restore finished it.
                untouched.add(dest)
                continue
            raise ValueError('restore backup is missing: ' + str(backup))
        if 'identity' in item and identity(backup) != item['identity']:
            raise ValueError('restore backup was replaced: ' + str(backup))
        originals.append((dest, backup))
    links = {p: link for p, link in links.items() if not any(q in untouched for q in (p, *p.parents))}
    directories = [p for p in directories if not any(q in untouched for q in (p, *p.parents))]

    # Check the entire plan, including previously existing parents, before any mutation.
    for dest, link in links.items():
        validate_target(dest.parent)
        if exists(dest) and (not dest.is_symlink() or os.readlink(dest) != link):
            raise ValueError('restore refuses changed destination: ' + str(dest))
    expected = set(links) | set(directories)
    for directory in directories:
        validate_target(directory)
        if directory.is_dir() and any(child not in expected for child in directory.iterdir()):
            raise ValueError('restore refuses directory with new content: ' + str(directory))
    for dest, backup in originals:
        if exists(dest) and dest not in expected:
            raise ValueError('restore refuses occupied original: ' + str(dest))
    for dest in links:
        if dest.is_symlink():
            dest.unlink()
    for directory in sorted(directories, key=lambda p: len(p.parts), reverse=True):
        if directory.is_dir():
            directory.rmdir()
    for dest, backup in originals:
        backup.rename(dest)
    print('RESTORED: ' + str(record_path))


def shell_sources(target, mode):
    missing = []
    for item in json.loads((ROOT / 'shell-sources.json').read_text()):
        dest = target / item['destination']
        validate_target(dest.parent)
        if dest.is_symlink():
            raise ValueError('shell integration destination is a symlink: ' + str(dest))
        if (dest / item['probe']).is_file():
            print('COMPLETED: ' + item['name'] + ' (existing installation retained)')
            continue
        if exists(dest):
            raise ValueError('incomplete existing integration; inspect manually: ' + str(dest))
        missing.append((dest, item))
    for dest, item in missing:
        if mode == 'dry':
            print('WOULD CLONE: ' + item['name'] + ' at ' + item['revision'])
            continue
        if mode == 'check':
            raise ValueError('missing shell integration: ' + item['name'])
        validate_target(dest.parent)
        dest.parent.mkdir(parents=True, exist_ok=True)
        env = dict(os.environ, GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_SYSTEM=os.devnull, GIT_CONFIG_NOSYSTEM='1', GIT_TERMINAL_PROMPT='0')
        for key in list(env):
            if key.startswith('GIT_') and key not in ('GIT_CONFIG_GLOBAL', 'GIT_CONFIG_SYSTEM', 'GIT_CONFIG_NOSYSTEM', 'GIT_TERMINAL_PROMPT'):
                del env[key]
        with tempfile.TemporaryDirectory(prefix='.dotfiles-shell-', dir=dest.parent) as temporary:
            clone = Path(temporary) / 'clone'
            subprocess.run(['git', '-c', 'core.hooksPath=/dev/null', 'clone', '--no-checkout', item['url'], str(clone)], env=env, check=True)
            subprocess.run(['git', '-C', str(clone), '-c', 'core.hooksPath=/dev/null', 'checkout', '--detach', item['revision']], env=env, check=True)
            if not (clone / item['probe']).is_file():
                raise ValueError('pinned source lacks expected entry file: ' + item['name'])
            if exists(dest):
                raise ValueError('shell integration appeared during install: ' + str(dest))
            clone.rename(dest)
        print('COMPLETED: ' + item['name'])


def deployment_plan(target, packages, backup):
    validate_target(target)
    items = desired(packages)
    real_parents = AGENT_PARENTS if 'agents' in packages else set()
    codex_home = os.environ.get('CODEX_HOME')
    if real_parents and target == Path(os.path.abspath(Path.home())) and codex_home:
        if Path(codex_home) != target / '.codex':
            raise ValueError('nondefault CODEX_HOME requires selective deployment; see docs/RECOVERY.md')
    bad = conflicts(target, items, real_parents)
    if bad and not backup:
        raise ValueError('conflicting destinations (use --backup after review): ' + ', '.join(str(p) for p in bad))
    return items, real_parents, bad


def deploy(target, mode, backup=False, packages=PACKAGES):
    target = Path(os.path.abspath(target))
    items, real_parents, bad = deployment_plan(target, packages, backup and mode != 'check')
    stow = shutil.which('stow')
    if mode == 'dry':
        print('WOULD DEPLOY: ' + ', '.join(packages) + ' -> ' + str(target))
        for p in bad:
            print('WOULD BACK UP: ' + str(p))
        if stow and target.is_dir() and not bad:
            run_stow(stow, target, items, packages, simulate=True)
        else:
            print('STOW SIMULATION DEFERRED: requires Stow and an existing conflict-free target')
        return
    if not stow:
        raise ValueError('stow is required')
    if mode == 'check' or not bad:
        missing = [rel for rel in items if not exists(target / rel)]
        missing.extend(str(rel) + ' (real parent required)' for rel in sorted(real_parents)
                       if not (target / rel).is_dir())
        if mode == 'check' and missing:
            raise ValueError('missing/wrong deployment: ' + ', '.join(missing))
        if not missing:
            print('CHECK PASSED: managed links and instruction destinations' if mode == 'check'
                  else 'SKIPPED: deployment already complete')
            return
    backup_root = target / BACKUPS
    validate_target(backup_root)
    if backup_root.exists() and (backup_root.stat().st_uid != os.getuid() or backup_root.stat().st_mode & 0o077):
        raise ValueError('backup root must be private and owned by the current user: ' + str(backup_root))
    target.mkdir(parents=True, exist_ok=True)
    backup_root.mkdir(mode=0o700, exist_ok=True)
    run = Path(tempfile.mkdtemp(prefix='deploy-', dir=backup_root))
    record_path = run / 'restore.json'
    record = dict(target=str(target), backups=[], links=[], directories=[])
    write_record(record_path, record)
    print('RESTORE RECORD: ' + str(record_path), flush=True)
    for i, dest in enumerate(bad):
        entry = dict(path=str(dest.relative_to(target)), backup=str(i), identity=identity(dest))
        record['backups'].append(entry)
        write_record(record_path, record)
        dest.rename(run / str(i))
    # Precreate real parents so Stow owns precise leaves and skill directories.
    parents = {target / rel for rel in real_parents}
    for rel in items:
        parents.update(p for p in (target / rel).parents if p != target and target in p.parents)
    for parent in sorted(parents, key=lambda p: (len(p.parts), p)):
        if not exists(parent):
            record['directories'].append(str(parent))
            write_record(record_path, record)
            parent.mkdir()
    run_stow(stow, target, items, packages, simulate=True)
    record['links'] = [dict(path=rel, link=os.path.relpath(source, (target / rel).parent))
                       for rel, source in items.items() if not exists(target / rel)]
    write_record(record_path, record)
    run_stow(stow, target, items, packages)
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
    target = Path(os.path.abspath(args.target or Path.home()))
    if args.target is None:
        # Preflight before any shell clone; no incidental upgrades to existing clones.
        _, _, bad = deployment_plan(target, PACKAGES, args.backup and mode != 'check')
        if target / '.oh-my-zsh' in bad or target / '.oh-my-zsh/custom' in bad:
            raise ValueError('resolve conflicting Oh My Zsh directories manually before installation')
        shell_sources(target, mode)
    else:
        print('ISOLATED TARGET: package installation and shell downloads skipped.')
    deploy(target, mode, args.backup)


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError, TypeError, KeyError, subprocess.CalledProcessError) as error:
        print('FAILED: ' + str(error), file=sys.stderr)
        sys.exit(1)
