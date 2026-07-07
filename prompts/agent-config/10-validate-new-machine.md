# Validate new-machine reproducibility

## Objective

Prove that the current working tree can bootstrap a clean machine from Git
into a disposable HOME, including intended unstaged and untracked files,
without altering the real HOME or repository index.

Use a valid handoff to avoid repeating earlier audits, but always reconfirm
current status and fixture isolation before applying Stow.

## Authority and safety

- Creating, committing inside, and deleting a fixture under `/private/tmp` is
  authorized. The real repository is read-only for this test.
- Do not edit the real worktree, real index, or real runtime; do not run an
  installer, stage/commit in the real repo, push, pull, fetch, or change real
  branches.
- Never write to real `$HOME/.agents`, `$HOME/.claude`, or `$HOME/.codex`.
- Preserve existing changes. Do not reset, restore, clean, or broadly delete.
- Never use global skill installation. Do not invoke Node, npm, npx,
  `skills@latest`, upstream clones, or network access during bootstrap; that
  CLI is only for separate project-scoped add/update work from
  `dotfiles/agents`.
- Do not copy secrets, caches, sessions, databases, logs, migration backups,
  private generated data, or application state into the fixture.

## Discovery and canonical model

Find the root with `git rev-parse --show-toplevel`, read applicable
`AGENTS.md`, and inspect branch, HEAD, upstream, ignored files, and complete
staged/unstaged/untracked status with
`git status --short --untracked-files=all`. Review intended untracked paths
before copying.

Canonical tracked skills are `agents/.agents/skills`; static Claude links are
`agents/.claude/skills`; Codex reads `$HOME/.agents/skills`; `agents` requires
`stow --no-folding`, leaving `.agents/skills` and `.claude/skills` as real
directories. Ownership classes are local, local fork, approved vendored third
party, generated runtime, and application managed. Generated
`framer-project-*` and broad `.codex` state must not be copied from the real
machine.

## Fixture

1. Create:

   ```text
   /private/tmp/dotfiles-new-machine-test-TIMESTAMP/fixture/repo
   /private/tmp/dotfiles-new-machine-test-TIMESTAMP/fixture/home
   ```

2. Copy the current working tree with a symlink/mode-preserving tool such as
   `rsync -a`. Include intended staged, unstaged, and untracked repository
   files. Explicitly exclude `.git`, `.DS_Store`, caches, build artifacts,
   runtime directories, migration backups, `.env`/credentials, databases,
   logs, sessions, and other ignored machine state. Inspect the source list
   and exclusions before copying.
3. Initialize a Git repository only inside the copied repo:

   ```sh
   git init
   git add -A
   git -c user.name='Fixture' -c user.email='fixture.invalid' \
     commit -m 'fixture: current working tree'
   ```

4. Create real fixture parent directories:

   ```sh
   mkdir -p "$FIXTURE_HOME/.agents/skills" "$FIXTURE_HOME/.claude/skills"
   ```

5. Add non-private runtime-only sentinels:

   ```text
   $FIXTURE_HOME/.agents/skills/framer-project-fixture/
   $FIXTURE_HOME/.claude/skills/framer-project-fixture
   ```

   The Claude sentinel link must resolve to the generated sentinel directory.

## Bootstrap and assertions

From the fixture repo, with `HOME="$FIXTURE_HOME"` on every runtime-sensitive
command, run the documented split flow:

```sh
stow --target="$FIXTURE_HOME" --simulate --verbose zsh tmux git starship
stow --target="$FIXTURE_HOME" --simulate --no-folding --verbose agents
stow --target="$FIXTURE_HOME" --verbose zsh tmux git starship
stow --target="$FIXTURE_HOME" --no-folding --verbose agents
HOME="$FIXTURE_HOME" scripts/agent-skills status
HOME="$FIXTURE_HOME" scripts/agent-skills audit
```

Verify:

- zsh, tmux, Git, Starship, and agents targets resolve into the fixture repo;
- `.agents/skills` and `.claude/skills` remain real directories;
- approved runtime skill directories are real and their files are Stow links;
- every tracked skill is recreated directly from Git;
- every intended static Claude link resolves; `staged-change-reviewer` remains
  Codex-only;
- sentinels survive and are absent from the copied Git tree;
- no fixture `.codex` package/state is created;
- no Node/npm/network/global metadata/upstream clone is required.

Repeat both Stow applications to prove idempotency. Then delete managed links
with matching package/mode commands:

```sh
stow --target="$FIXTURE_HOME" --delete --verbose zsh tmux git starship
stow --target="$FIXTURE_HOME" --delete --no-folding --verbose agents
```

Verify only managed links were removed and both sentinels survived. Reapply
the exact bootstrap commands and rerun status/audit. With `--no-folding`,
empty Stow-created skill directories may remain after deletion; verify they
contain no managed links/files and do not broadly clean them. Do not weaken
runtime validation to make the fixture pass; fix only a proven repository
portability defect with separate edit authority.

## Cleanup and report

After success, delete only the verified fixture root. If validation fails,
preserve it and report the path/evidence.

Report fixture path, copy method/exclusions, exact commands, Node/npm/network
usage, parent types, link shapes, inventories, status/audit, idempotent
restow, delete/reapply, sentinels, `.codex` absence, cleanup, and any
portability issue.

```yaml
operation: validate-new-machine
fixture_path:
fixture_removed:
copy_method:
exclusions: []
stow_commands: []
node_required: false
npm_required: false
network_required: false
parent_directories_real:
skill_file_links_resolve:
static_claude_links_resolve:
codex_only_preserved:
status_passed:
audit_passed:
restow_idempotent:
delete_reapply_passed:
generated_sentinel_preserved:
codex_state_created: false
real_repository_changed: false
real_runtime_changed: false
staged_in_real_repository: false
unresolved_blockers: []
```
