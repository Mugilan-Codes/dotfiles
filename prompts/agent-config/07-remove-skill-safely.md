# Remove a skill safely

## Objective and inputs

Remove one tracked skill and its exact references while preserving a scoped
recovery path.

- Skill: `<SKILL_NAME>`
- Reason: `<REASON>`

This prompt never removes generated Framer state.

## Authority and safety

- Scoped repository removal of the named tracked skill is authorized after
  ownership/dependency checks. Installer and real runtime changes are not.
- Do not stage, commit, push, pull, fetch, or change branches.
- Preserve pre-existing/unrelated changes. Do not reset, restore, checkout,
  clean, recursively clear runtime parents, or perform broad deletion.
- Never use global skill installation. This workflow does not run
  `skills@latest`; any later authorized third-party operation must be
  project-scoped from `dotfiles/agents`.
- Do not inspect/copy secrets, private generated data, or application-managed
  `.codex`/Claude contents.
- Use a valid handoff without repeating completed audits; reconfirm current
  status and affected paths.

## Discovery and canonical model

Find the Git root, read applicable `AGENTS.md`, and inspect branch, HEAD,
upstream, and full status. Read the named skill, configuration, registry,
provenance, project lock, package README, licences, and `skills-maintainer`.
Search all tracked references and dependencies before editing.

Canonical skills are under `agents/.agents/skills`; static Claude links are
under `agents/.claude/skills`. The `agents` package uses
`stow --no-folding`, preserving real runtime parent directories. Determine
whether the name is local, local fork, approved vendored third party,
generated runtime, or application managed. Stop if it is generated
`framer-project-*` or application-managed state.

## Workflow

1. Identify ownership, dependants, documentation references, allowlists, lock
   records, licences shared with other skills, static Claude link, Codex-only
   classification, and runtime observation.
2. If any dependency remains, stop for a user decision rather than breaking
   it or expanding scope.
3. Preserve a recovery path: record the current Git object/diff and, when
   useful, make a scoped external backup outside the repository. Never copy
   private/generated runtime content.
4. Remove only `agents/.agents/skills/<SKILL_NAME>` and its tracked
   `agents/.claude/skills/<SKILL_NAME>` link when applicable.
5. Remove the exact name from its ownership/allowlist/Codex-only configuration
   and registry/provenance/docs. Retain shared licence files still required by
   other skills.
6. For a vendored skill, explicitly reconcile its `skills-lock.json` record.
   The audited CLI removal left stale project-lock entries, so never assume a
   remove command made the lock accurate. Do not run that installer here.
7. Confirm remaining lock names exactly match remaining third-party
   allowlists and that no local/fork ownership was altered.
8. Simulate the resulting Stow plan. Do not delete or change real runtime
   paths in this operation.

## Validation

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
bash -n scripts/agent-skills
scripts/agent-skills audit
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Search for remaining references to the exact name; distinguish intentional
historical/provenance mentions. Verify dependencies, lock/allowlist parity,
Claude-link removal, retained licences, file modes, generated exclusions, and
no broad `.codex` changes.

## Report and handoff

Report ownership, dependency evidence, recovery path, every removed/modified
path, lock/licence decisions, pre-existing changes, validation, and the
separate command/authority needed for any later runtime unstow/restow.

```yaml
operation: remove-skill-safely
skill:
  name:
  reason:
  former_ownership:
dependants_found: []
recovery_path:
files_removed: []
files_modified: []
symlinks_removed: []
lock_changes: []
licenses_retained_or_removed: []
pre_existing_changes: []
validation:
  passed: []
  failed: []
installer_ran: false
runtime_changed: false
staged: false
committed: false
pushed: false
unresolved_blockers: []
```
