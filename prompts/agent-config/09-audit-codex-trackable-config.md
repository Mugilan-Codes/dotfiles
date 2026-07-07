# Audit trackable Codex configuration

## Objective

Safely reassess whether newly present user-authored `.codex` configuration is
portable and suitable for this dotfiles repository. Produce an include/exclude
recommendation only; audit-only is the default.

If a valid earlier handoff exists, do not repeat its completed audit. Recheck
current names/types/metadata and any specifically identified new entries.

## Authority and safety

- Read-only metadata inspection is authorized. Do not edit repository or
  runtime files, run installers, apply Stow, stage, commit, push, pull, fetch,
  or change branches.
- Treat `.codex` as sensitive. Begin with names, entry types, modes, ownership,
  sizes, and timestamps. Do not print file contents by default.
- Never print or copy authentication material, tokens, credentials, hook
  commands that may contain secrets, session/history/memory contents,
  databases, logs, caches, private generated data, or application telemetry.
- Do not use broad recursive content search under `.codex`.
- Preserve existing changes and do not reset, restore, clean, delete, move, or
  alter runtime paths.
- Never use global skill installation or recommend tracking all of `.codex`.
  Do not run `skills@latest`; it is reserved for separately authorized,
  project-scoped third-party work from `dotfiles/agents`.

## Repository discovery and expected model

Find the Git root, read applicable `AGENTS.md`, and inspect branch, HEAD,
upstream, staged/unstaged/untracked state, `.gitignore`, current package roots,
and existing policy/docs.

The canonical portable skill root is `agents/.agents/skills`; static Claude
links live in `agents/.claude/skills`; the `agents` package requires
`stow --no-folding` and real runtime parent directories. Ownership categories
are local, local fork, approved vendored third party, generated runtime, and
application managed. `$HOME/.codex` is application-managed by default;
generated `framer-project-*` stays outside Git.

## Audit method

1. Inventory `.codex` at shallow depth using safe metadata only. Avoid
   following symlinks into private trees.
2. Classify each relevant entry as:
   - portable user-authored configuration;
   - application-managed configuration;
   - credentials/authentication;
   - databases;
   - sessions/history/memory;
   - logs;
   - caches;
   - application-managed system/plugin skills;
   - local user-authored skills.
3. Read contents only when all are true: the item is plausibly user-authored
   portable config, it is a text file of bounded size, repository policy
   permits it, and content inspection is explicitly authorized. Redact any
   unexpected secret and stop expanding scope.
4. Prefer moving reviewed user-authored skills into
   `agents/.agents/skills/{name}` rather than Stowing `.codex/skills`.
5. Never propose a whole `.codex` Stow package. Recommend the narrowest
   allowlist of portable user-authored files, with explicit excludes for all
   other categories.
6. Check for naming collisions with tracked, generated, and plugin/system
   skills without reading private contents.
7. Make no changes; provide a separate implementation plan and required
   authority.

## Validation

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
scripts/agent-skills status
scripts/agent-skills audit
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Do not run Node/npm/network commands. Confirm the audit output itself contains
no secret values or private content.

## Report and handoff

Report safe metadata scope, categorized entries by name/type only, portable
include candidates, mandatory excludes, collision risks, an implementation
plan, validations, and skipped sensitive checks. State that runtime and
repository state were unchanged.

```yaml
operation: audit-codex-trackable-config
repository:
  path:
  head:
metadata_scope:
categories:
  portable_user_authored: []
  application_managed_config: []
  credentials: []
  databases: []
  sessions_history_memory: []
  logs: []
  caches: []
  application_managed_skills: []
  local_user_authored_skills: []
include_recommendation: []
exclude_recommendation: []
skill_migration_candidates: []
validation:
  passed: []
  failed: []
sensitive_contents_printed: false
repository_changed: false
runtime_changed: false
staged: false
committed: false
pushed: false
unresolved_blockers: []
```
