# Recover from a failed skill installation

## Objective and inputs

Diagnose a failed or interrupted skill installer operation, preserve evidence,
and produce a scoped recovery plan. Restore affected paths only after explicit
additional authority.

- Failed command: `<FAILED_COMMAND>`
- Optional error output: `<ERROR_OUTPUT>`
- Optional backup: `<BACKUP_PATH>`

If a valid incident handoff exists, continue from it without repeating
completed discovery; reconfirm current Git/runtime evidence first.

## Authority and safety

- Stop all further installers. Read-only diagnosis and disposable fixture work
  are authorized. Repository/runtime restoration is not authorized by default.
- Do not run add/update/remove again, use global installation, or invoke
  `skills update --help`. A later retry, if separately authorized, must use
  project-scoped `skills@latest` from `dotfiles/agents`.
- Do not stage, commit, push, pull, fetch, change branches, reset, restore,
  checkout, clean, broadly remove, or automatically roll back.
- Preserve pre-existing changes, the current Git diff, index state, logs
  supplied by the user, file modes, symlinks, runtime topology, and backup
  evidence.
- Never expose/copy secrets, private generated state, sessions, databases,
  caches, or broad application-managed `.codex`/Claude contents.
- Preserve local forks and generated `framer-project-*`; never clear real
  runtime parent directories.

## Discovery and canonical model

Find the Git root, read applicable `AGENTS.md`, inspect branch, HEAD, upstream,
and complete staged/unstaged/untracked status. Read configuration, lock,
registry, provenance, relevant skill paths, wrapper output, and backup
metadata without modifying them. Inspect exact runtime entries only with safe
metadata, `stat`, `readlink`, and `realpath`.

Canonical tracked source is `agents/.agents/skills`; static Claude links are
`agents/.claude/skills`; `agents` uses `stow --no-folding` and real runtime
parents. Classify affected names as local, local fork, approved vendored third
party, generated runtime, or application managed. Do not rely on any removed
mixed-runtime manager.

## Investigation

1. Record `<FAILED_COMMAND>`, working directory, intended source/names/targets,
   resolved CLI version if known, failure boundary, and exact error evidence.
2. Determine precisely which tracked paths, untracked paths, lock entries,
   static/runtime symlinks, executable modes, registry/provenance/licence
   files, and runtime entries changed. Separate prior changes from installer
   effects using Git and the handoff/backup.
3. Check whether the command ran from `dotfiles/agents`, used project scope,
   selected only allowlisted names, or unexpectedly touched global/runtime
   state.
4. Treat Git as evidence, not an automatic destructive rollback. Do not assume
   the project lock is correct; audited removal behavior can leave stale
   entries.
5. Inspect `<BACKUP_PATH>` by safe names/types/hashes and compare only affected
   paths. Never copy an entire backup into place.
6. Reproduce in a disposable temporary repository/HOME when possible, using
   non-private fixture data and no real runtime. Do not rerun against the real
   repository merely to confirm failure.
7. Identify root cause and propose the smallest recovery sequence. Separate:
   repository file restoration, lock reconciliation, symlink/mode repair,
   documentation correction, and later Stow runtime repair.
8. List every mutating command that requires user approval. Restoration must
   name exact paths and preserve all unrelated/local/fork/generated state.

## Read-only validation

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
git diff --summary
bash -n scripts/agent-skills
scripts/agent-skills status
scripts/agent-skills audit
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Run only checks that cannot worsen the incident. If runtime or repository
topology is incomplete, report expected validation failures rather than
weakening the validator.

## Report and handoff

Report root cause, incident timeline, affected and preserved paths,
tracked/lock/symlink/mode/runtime impact, backup evidence, safe recovery plan,
commands requiring approval, validation plan, and unresolved blockers. State
explicitly that no restoration occurred unless separately authorized.

```yaml
operation: recover-failed-install
failed_command:
working_directory:
intended_source:
intended_skills: []
targets: []
resolved_cli_version:
root_cause:
pre_existing_changes: []
impacted:
  tracked_paths: []
  untracked_paths: []
  lock_entries: []
  symlinks: []
  executable_modes: []
  runtime_entries: []
preserved:
  local_skills: []
  local_forks: []
  generated_runtime: []
backup:
  path:
  verified:
safe_recovery_plan: []
commands_requiring_approval: []
validation_plan: []
installer_stopped: true
repository_restored: false
runtime_changed: false
staged: false
committed: false
pushed: false
unresolved_blockers: []
```
