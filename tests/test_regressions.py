#!/usr/bin/env python3
"""Offline regression tests. All writes and subprocess effects use temporary fixtures."""
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
import io
import tarfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parent.parent
FUNCTIONS = ROOT / 'zsh/.oh-my-zsh/custom/functions.zsh'
VENDOR = ROOT / 'agents/.agents/skills/here-now/scripts'


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    value = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(value)
    return value


safe = module('safe_files', VENDOR / 'safe-files.py')
deployment = module('deployment', ROOT / 'scripts/deploy.py')


class Fixture(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='dotfiles-test-', dir='/private/tmp')
        self.addCleanup(self.tmp.cleanup)
        self.base = Path(self.tmp.name)
        self.home = self.base / 'home'
        self.home.mkdir()
        self.bin = self.base / 'bin'
        self.bin.mkdir()
        self.env = dict(os.environ, HOME=str(self.home), ZDOTDIR=str(self.home), TMPDIR=str(self.base), PATH=str(self.bin) + ':' + os.environ['PATH'], PYTHONDONTWRITEBYTECODE='1', GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_SYSTEM=os.devnull, GIT_CONFIG_NOSYSTEM='1', GIT_OPTIONAL_LOCKS='0')

    def run_command(self, args, ok=True, **kwargs):
        p = subprocess.run(args, cwd=self.base, env=self.env, capture_output=True, text=True, **kwargs)
        if ok:
            self.assertEqual(p.returncode, 0, p.stdout + p.stderr)
        else:
            self.assertNotEqual(p.returncode, 0, p.stdout + p.stderr)
        return p

    def zsh(self, code, ok=True):
        return self.run_command(['/bin/zsh', '-f', '-c', 'source ' + shlex.quote(str(FUNCTIONS)) + '\n' + code], ok=ok)

    def executable(self, name, content):
        path = self.bin / name
        path.write_text('#!/bin/sh\n' + content)
        path.chmod(0o755)
        return path


class ShellTests(Fixture):
    def test_editor_quotes_no_eval_and_arguments(self):
        editor = self.executable('editor with space', 'printf "<%s>\\n" "$@"\n')
        spec = shlex.quote('"' + str(editor) + '" --wait')
        p = self.zsh('VISUAL=' + spec + '\n_dotfiles_edit "file with space" "" "-name"')
        self.assertEqual(p.stdout, '<--wait>\n<file with space>\n<>\n<-name>\n')
        p = self.zsh('VISUAL=' + shlex.quote('$(touch BAD)') + '\n_dotfiles_edit x', ok=False)
        self.assertFalse((self.base / 'BAD').exists())

    def test_ports_and_loopback(self):
        for port in ('', '0', '65536', '-1', '1+1', '99999999999999999999999'):
            self.zsh('_valid_tcp_port ' + shlex.quote(port), ok=False)
        for port in ('1', '65535', '0080'):
            self.zsh('_valid_tcp_port ' + shlex.quote(port))
        p = self.zsh('python3() { print -r -- "$*"; }; servehere 8081')
        self.assertIn('-m http.server 8081 --bind 127.0.0.1', p.stdout)
        self.zsh('python3() { print UNEXPECTED; }; servehere invalid', ok=False)

    def test_listener_selection_and_failures(self):
        p = self.zsh('lsof() { print -r -- "$*" > "$HOME/lsof.args"; print 4242; }; kill() { print -r -- "$*"; }; killport 3000')
        self.assertEqual((self.home / 'lsof.args').read_text().strip(), '-nP -a -iTCP:3000 -sTCP:LISTEN -t')
        self.assertEqual(p.stdout.strip(), '-TERM -- 4242')
        p = self.zsh('lsof() { return 1; }; kill() { print BAD; }; killport 3000')
        self.assertIn('No listeners', p.stdout)
        p = self.zsh('lsof() { print -u2 denied; return 1; }; kill() { print BAD; }; killport 3000', ok=False)
        self.assertNotIn('No listeners', p.stdout)
        self.zsh('lsof() { print 0; }; kill() { print BAD; }; killport 3000', ok=False)
        self.zsh('lsof() { print 4242; }; kill() { return 37; }; killportf 3000', ok=False)

    def test_option_boundaries(self):
        self.zsh('mkcd "-directory with spaces"; [[ "$PWD:t" == "-directory with spaces" ]]')
        (self.base / 'sample').write_text('-fNO_SUCH_FILE\n')
        p = self.zsh('fzf() { cat; }; _dotfiles_edit() { print -r -- "$1"; }; fzf-content -fNO_SUCH_FILE')
        self.assertIn('./sample', p.stdout)
        self.executable('unzip', 'printf "%s\\n" "$1"')
        (self.base / '-archive.zip').write_text('fake')
        p = self.zsh('extract -archive.zip')
        self.assertIn(str(self.base / '-archive.zip'), p.stdout)

    def test_cleanup_and_clipboard_failures(self):
        for rel in ('.Trash', 'Library/Caches', 'Library/Developer/Xcode/DerivedData', 'Downloads'):
            (self.home / rel).mkdir(parents=True)
        mock = 'find() { [[ "$*" == *-exec* ]] && return 37; print fake; }; du() { print "1K fake"; }; '
        for function, answer in (('emptytrash','EMPTY'),('cleanmac','CLEAN'),('cleanderived','DERIVED')):
            p = self.zsh(mock + function + ' <<< ' + answer, ok=False)
            self.assertEqual(p.returncode, 37)
        self.zsh('neatcli() { return 37; }; dlcleanx <<< YES', ok=False)
        self.zsh('pbcopy() { return 37; }; cpwd', ok=False)
        self.zsh('orb() { return 37; }; docker() { print BAD; }; orbreload', ok=False)

    def test_completion_is_atomic(self):
        (self.home / '.zfunc').mkdir()
        old = self.home / '.zfunc/_neatcli'
        old.write_text('# original\n')
        for generator in ('print partial; return 37', 'print "if then"', 'return 0'):
            self.zsh('neatcli() { ' + generator + '; }; compinit() { return 0; }; neatcomp', ok=False)
            self.assertEqual(old.read_text(), '# original\n')
            self.assertEqual(len(list(old.parent.iterdir())), 1)
        self.zsh('neatcli() { print "# valid"; }; compinit() { return 0; }; neatcomp')
        self.assertEqual(old.read_text(), '# valid\n')

    def test_fzf_quoted_placeholder(self):
        block = FUNCTIONS.read_text().split('zoxfz() {')[1]
        preview = re.search(r"--preview='(.*?)'", block, re.S).group(1)
        directory = self.base / '$(touch UNEXPECTED) space'
        directory.mkdir()
        self.executable('eza', 'exit 0\n')
        self.run_command(['/bin/sh', '-c', preview.replace('{}', shlex.quote(str(directory)))])
        self.assertFalse((self.base / 'UNEXPECTED').exists())

    def test_git_abort_failure_and_missing_key(self):
        alias = subprocess.check_output(['git', 'config', '--file', str(ROOT / 'git/.gitconfig'), '--get', 'alias.abort'], text=True).strip()[1:]
        (self.base / 'rebase-merge').mkdir()
        self.executable('git', 'case "$*" in "rev-parse --git-dir") echo . ;; "rev-parse --git-path rebase-merge") echo rebase-merge ;; "rebase --abort") exit 37 ;; *) exit 1 ;; esac\n')
        p = self.run_command(['/bin/sh', '-c', alias], ok=False)
        self.assertEqual(p.returncode, 37)
        self.run_command([str(ROOT / 'scripts/git-ssh-identity'), str(self.base / 'missing'), 'never-contact.invalid'], ok=False)


class VendorTests(Fixture):
    def test_nested_manifest_and_well_known(self):
        site = self.base / 'site'
        for rel in ('index.html', '.well-known/assetlinks.json', 'nested/.well-known/security.txt', '.env', 'nested/.env.local', '.git/config', 'nested/.git/config', '.herenow/state.json', 'nested/.herenow/state.json', '.ssh/id_ed25519', 'key.pem', '.codex/config.toml'):
            p = site / rel; p.parent.mkdir(parents=True, exist_ok=True); p.write_text('FAKE')
        (site / 'escape').symlink_to(self.home)
        (site / 'link.html').symlink_to(site / 'index.html')
        manifest = safe.manifest(str(site))
        self.assertEqual({f['path'] for f in manifest['files']}, {'index.html', '.well-known/assetlinks.json', 'nested/.well-known/security.txt'})
        with self.assertRaises(ValueError):
            safe.manifest(site / '.env')

    def test_export_containment_and_existing_files(self):
        dest = self.base / 'export'
        def export(path, dry=False):
            with patch.dict(os.environ, self.env, clear=True):
                return safe.export_page({'files':[{'path':path}]}, '', str(dest), 'https://example.invalid/files', dry, [])
        self.executable('curl', 'printf fixture\n')
        for path in ('../escape', '/absolute', 'a/../../escape', 'a//b', 'a/./b', 'a\\b', 'x\ny'):
            with self.assertRaises(ValueError): export(path)
        self.assertFalse(dest.exists())
        export('dir/file', dry=True)
        self.assertFalse(dest.exists())
        export('dir/file')
        self.assertEqual((dest / 'dir/file').read_text(), 'fixture')
        with self.assertRaises(FileExistsError): export('dir/file')
        (dest / 'parent').symlink_to(self.home)
        with self.assertRaises(OSError): export('parent/escaped')
        (dest / 'leaf').symlink_to(self.home / 'escaped')
        with self.assertRaises(FileExistsError): export('leaf')
        self.assertFalse((self.home / 'escaped').exists())
        self.executable('curl', 'printf partial; exit 22\n')
        with self.assertRaises(subprocess.CalledProcessError): export('failed')
        self.assertFalse((dest / 'failed').exists())

    def test_scripts_use_guarded_manifest_and_export(self):
        # Full script wiring, with fake credentials and curl. No actual network.
        self.env['HERENOW_API_KEY']='TEST_PLACEHOLDER'
        self.env['TEST_BODY']=str(self.base / 'manifest.json')
        self.executable('curl', '''case "$*" in
 *'/publish'*) while [ "$#" -gt 0 ]; do if [ "$1" = -d ]; then printf '%s' "$2" > "$TEST_BODY"; break; fi; shift; done; printf '%s' '{"error":"fixture stop"}'; exit 0 ;;
 *) out=''; while [ "$#" -gt 0 ]; do if [ "$1" = -o ]; then out=$2; shift; fi; shift; done
    printf '%s' '{"files":[{"path":"../escape"}],"nextCursor":null}' > "$out"; printf 200 ;;
esac
''')
        site = self.base / 'site'; site.mkdir(); (site / '.env').write_text('fake'); (site / 'index.html').write_text('fixture')
        p = self.run_command(['/bin/bash', str(VENDOR / 'publish.sh'), str(site)], ok=False)
        self.assertNotIn('TEST_PLACEHOLDER', p.stdout + p.stderr)
        body = json.loads((self.base / 'manifest.json').read_text())
        self.assertEqual([f['path'] for f in body['files']], ['index.html'])
        self.run_command(['/bin/bash', str(VENDOR / 'drive.sh'), 'export', 'drv_fixture', '', '--to', str(self.base / 'export')], ok=False)
        self.assertFalse((self.base / 'escape').exists())


class DeploymentTests(Fixture):
    def install(self, *args, ok=True):
        return self.run_command([str(ROOT / 'install.sh'), *args], ok=ok)

    def test_dry_run_fresh_repeat_and_check(self):
        target = self.base / 'target with spaces'
        self.install('--dry-run', '--target', str(target))
        self.assertFalse(target.exists())
        self.install('--check', '--target', str(target), ok=False)
        self.install('--target', str(target))
        snapshot = sorted(str(p.relative_to(target)) for p in target.rglob('*'))
        self.install('--target', str(target))
        self.assertEqual(snapshot, sorted(str(p.relative_to(target)) for p in target.rglob('*')))
        self.install('--check', '--target', str(target))
        self.assertEqual((target / '.claude/CLAUDE.md').resolve(), (target / '.codex/AGENTS.md').resolve())
        self.assertTrue((target / '.agents/skills/bug-triage').is_symlink())
        self.assertFalse((target / '.agents/skills').is_symlink())
        self.assertFalse((target / 'skills-manifest.json').exists())
        (target / '.agents/skills/bug-triage').unlink()
        self.install('--check', '--target', str(target), ok=False)

    def test_conflict_backup_restore_and_changed_restore_refusal(self):
        target = self.base / 'conflict'; target.mkdir()
        (target / '.zshrc').write_text('ORIGINAL')
        self.install('--target', str(target), ok=False)
        self.assertEqual((target / '.zshrc').read_text(), 'ORIGINAL')
        self.assertFalse((target / '.dotfiles-backups').exists())
        self.install('--target', str(target), '--backup')
        record = next((target / '.dotfiles-backups').glob('*/restore.json'))
        (target / '.zshrc').unlink(); (target / '.zshrc').write_text('NEW')
        self.install('--restore', str(record), ok=False)
        (target / '.zshrc').unlink()
        self.install('--restore', str(record))
        self.assertEqual((target / '.zshrc').read_text(), 'ORIGINAL')

    def test_parent_conflict_restores_and_unmanaged_survives(self):
        target = self.base / 'parent'; target.mkdir()
        (target / '.config').write_text('ORIGINAL PARENT')
        runtime = target / '.agents/skills/external'; runtime.mkdir(parents=True)
        (runtime / 'SKILL.md').write_text('untouched')
        self.install('--target', str(target), '--backup')
        record = next((target / '.dotfiles-backups').glob('*/restore.json'))
        self.install('--restore', str(record))
        self.assertEqual((target / '.config').read_text(), 'ORIGINAL PARENT')
        self.assertEqual((runtime / 'SKILL.md').read_text(), 'untouched')

    def test_repository_path_spaces(self):
        clone = self.base / 'repository with spaces'
        shutil.copytree(ROOT, clone, symlinks=True, ignore=shutil.ignore_patterns('.git', '__pycache__'))
        target = self.base / 'spaced deployment'
        self.run_command([str(clone / 'install.sh'), '--target', str(target)])
        self.assertEqual((target / '.zshrc').resolve(), clone / 'zsh/.zshrc')

    def test_mocked_shell_provisioning_repeats_without_update(self):
        target = self.base / 'shell target'; target.mkdir()
        calls = []
        def git(args, **kwargs):
            calls.append(args)
            if 'clone' in args:
                clone = Path(args[-1]); clone.mkdir()
                (clone / 'oh-my-zsh.sh').write_text('# fixture')
                (clone / 'zsh-autosuggestions.zsh').write_text('# fixture')
                (clone / 'zsh-syntax-highlighting.zsh').write_text('# fixture')
            return subprocess.CompletedProcess(args, 0)
        with patch.object(deployment.subprocess, 'run', side_effect=git):
            deployment.shell_sources(target, 'dry')
            self.assertEqual(calls, [])
            deployment.shell_sources(target, 'install')
            count = len(calls)
            deployment.shell_sources(target, 'install')
            self.assertEqual(len(calls), count)
        self.assertEqual(count, 6)

    def test_mocked_bootstrap_packages_and_read_only_modes(self):
        # Run the actual Bash bootstrap with OS/package boundaries replaced in
        # an isolated script copy; no real Homebrew/CLT command can be reached.
        repo = self.base / 'bootstrap'; repo.mkdir()
        prefix = self.base / 'brew'; (prefix / 'bin').mkdir(parents=True)
        (prefix / 'opt').mkdir()
        log = self.base / 'brew.calls'
        brew = prefix / 'bin/brew'
        brew.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> ' + shlex.quote(str(log)) + '\nmkdir -p ' + shlex.quote(str(prefix / 'opt')) + '/"$3"\n')
        brew.chmod(0o755)
        (prefix / 'bin/python3').symlink_to(sys.executable)
        clt = self.executable('xcode-select', 'exit 0\n')
        script = (ROOT / 'install.sh').read_text().replace('/opt/homebrew', str(prefix)).replace('/usr/bin/xcode-select', str(clt))
        (repo / 'install.sh').write_text(script); (repo / 'install.sh').chmod(0o755)
        (repo / 'Brewfile.core').write_text('brew "fixture"\n')
        (repo / 'scripts').mkdir()
        (repo / 'scripts/deploy.py').write_text('print("MOCK deployment boundary")\n')
        self.run_command([str(repo / 'install.sh'), '--dry-run'])
        self.assertFalse(log.exists())
        self.run_command([str(repo / 'install.sh'), '--check'], ok=False)
        self.assertFalse(log.exists())
        self.run_command([str(repo / 'install.sh')])
        self.assertEqual(log.read_text(), 'install --formula fixture\n')
        self.run_command([str(repo / 'install.sh')])
        self.assertEqual(log.read_text(), 'install --formula fixture\n')
        self.run_command([str(repo / 'install.sh'), '--unknown'], ok=False)



class SkillTests(Fixture):
    def setUp(self):
        super().setUp()
        self.repo = self.base / 'repo'
        shutil.copytree(ROOT, self.repo, symlinks=True, ignore=shutil.ignore_patterns('.git', '__pycache__'))
        self.run_command(['/usr/bin/git', 'init', str(self.repo)])
        self.cli = self.repo / 'scripts/agent-skills'
        self.source = self.base / 'source'; self.source.mkdir()
        (self.source / 'SKILL.md').write_text('---\nname: fixture-skill\ndescription: Fixture skill\n---\nInstructions\n')
        (self.source / 'references').mkdir(); (self.source / 'references/example.md').write_text('reference')
        (self.source / 'LICENSE').write_text('Fixture license')

    def cli_run(self, *args, ok=True):
        return self.run_command([str(self.cli), *args, '--target', str(self.home)], ok=ok)

    def add(self, command='add', source=None, ok=True):
        return self.cli_run(command, 'fixture-skill', '--from-dir', str(source or self.source), '--origin', 'local regression fixture; no upstream claimed', '--license', 'LICENSE', ok=ok)

    def test_add_collision_update_drift_and_provenance(self):
        self.add()
        dest = self.repo / 'agents/.agents/skills/fixture-skill'
        self.assertTrue((dest / 'references/example.md').exists())
        self.add(ok=False)
        (self.source / 'references/example.md').write_text('new reference')
        self.add('update')
        self.assertEqual((dest / 'references/example.md').read_text(), 'new reference')
        (dest / 'SKILL.md').write_text((dest / 'SKILL.md').read_text()+'local edit\n')
        self.add('update', ok=False)
        self.cli_run('check', '--source-only', ok=False)
        data = json.loads((self.repo / 'agents/skills-manifest.json').read_text())
        self.assertIsNone(data['fixture-skill']['revision'])
        del data['fixture-skill']['origin']
        (self.repo / 'agents/skills-manifest.json').write_text(json.dumps(data))
        self.cli_run('check', '--source-only', ok=False)

    def test_import_preserves_runtime_and_links_check(self):
        runtime = self.home / '.agents/skills/fixture-skill'
        runtime.parent.mkdir(parents=True)
        shutil.copytree(self.source, runtime)
        self.add(ok=False)
        self.add('import', runtime)
        self.assertFalse(runtime.is_symlink())
        self.cli_run('deploy', ok=False)
        self.cli_run('deploy', '--backup')
        extra = self.home / '.agents/skills/extra-skill'; extra.mkdir()
        self.cli_run('check')
        self.run_command([str(self.cli), 'status'])
        output = self.cli_run('list').stdout
        self.assertIn('unmanaged:review\textra-skill', output)
        (self.home / '.claude/skills/fixture-skill').unlink()
        self.cli_run('check', ok=False)
        self.assertTrue(extra.exists())

    def test_escaping_symlink_and_external_owner_rejected(self):
        (self.source / 'escape').symlink_to(self.home)
        self.add(ok=False)
        (self.source / 'escape').unlink()
        self.cli_run('add', 'caveman', '--from-dir', str(self.source), '--origin', 'test', '--license', 'LICENSE', ok=False)
        self.cli_run('add-repo', 'fixture-skill', '--repo', 'https://github.com/example/skills', '--revision', 'main', '--subdir', 'fixture-skill', '--license', 'LICENSE', ok=False)
        self.cli_run('add-repo', 'fixture-skill', '--repo', 'https://user:secret@example.invalid/repo', '--revision', 'a'*40, '--subdir', '../escape', '--license', 'LICENSE', ok=False)

    def test_pinned_repository_acquisition_without_network(self):
        store = module('fixture_store', self.repo / 'scripts/skill-store.py')
        archive = io.BytesIO()
        with tarfile.open(fileobj=archive, mode='w') as tar:
            for name, data in [('skills/fixture-skill/SKILL.md', (self.source / 'SKILL.md').read_bytes()), ('skills/fixture-skill/LICENSE', b'fixture license')]:
                info = tarfile.TarInfo(name); info.size = len(data); tar.addfile(info, io.BytesIO(data))
        from argparse import Namespace
        args = Namespace(from_dir=None, repo='https://github.com/example/skills', revision='a'*40, subdir='skills/fixture-skill')
        stage = self.base / 'fetch'; stage.mkdir()
        with patch.object(store.subprocess, 'run') as clone, patch.object(store.subprocess, 'check_output', return_value=archive.getvalue()) as read:
            source, origin, revision = store.acquire(args, stage)
        self.assertEqual(revision, 'a'*40)
        self.assertIn('#skills/fixture-skill', origin)
        self.assertTrue((source / 'LICENSE').exists())
        self.assertIn('--bare', clone.call_args.args[0])
        self.assertEqual(clone.call_args.kwargs['env']['GIT_CONFIG_GLOBAL'], os.devnull)
        self.assertIn('archive', read.call_args.args[0])

    def test_legacy_audit_and_metadata_validation(self):
        self.run_command([str(self.cli), 'audit'])
        self.add()
        self.run_command([str(self.cli), 'audit'])
        data = json.loads((self.repo / 'agents/skills-manifest.json').read_text())
        del data['fixture-skill']['license']
        (self.repo / 'agents/skills-manifest.json').write_text(json.dumps(data))
        self.cli_run('check', '--source-only', ok=False)

    def test_update_requires_patch_review_and_secret_rejection(self):
        self.add()
        self.cli_run('record-patch', 'fixture-skill', '--origin', 'fixture review', '--note', 'local patch preserved')
        self.add('update', ok=False)
        self.cli_run('update', 'fixture-skill', '--from-dir', str(self.source), '--origin', 'reviewed fixture', '--license', 'LICENSE', '--reviewed-patches', 'candidate preserves patch')
        (self.source / 'private.key').write_text('fixture only')
        self.add('update', ok=False)



if __name__ == '__main__':
    unittest.main(verbosity=2)
