# Audit agent configuration

## Objective

Perform a read-only audit of the dotfiles repository's tracked agent
configuration and safely observable runtime topology. Detect drift, broken
Stow links, inconsistent registry or lock data, generated-state leakage,
provenance gaps, and obsolete documentation. Do not fix findings.

If a valid YAML handoff is supplied, treat it as authoritative for completed
work and reconfirm only mutable safety-critical facts. Without a handoff,
perform the full audit below. Do not repeat completed phases merely to rebuild
context.

## Authority and safety

- This is audit-only. Do not edit files, run an installer, apply/unstow/restow,
  change runtime paths, stage, commit, push, pull, fetch, switch branches, or
  create a branch.
- Do not use broad cleanup, reset, restore, checkout, or deletion commands.
- Preserve and report all existing staged, unstaged, and untracked changes.
- Never use global skill installation or `npx skills add/update/remove`.
  `skills@latest` is reserved for a separately authorized project-scoped
  add/update from `dotfiles/agents`; this audit does not run it.
- Do not inspect secrets or private application contents. For `.codex`, inspect
  names, types, modes, sizes, and other safe metadata only unless the user
  explicitly authorizes reading a known-safe configuration file.

## Repository discovery

1. Determine the repository root with `git rev-parse --show-toplevel`; do not
   assume a username-specific path.
2. Read every applicable `AGENTS.md`, starting at the repository root.
3. Inspect `git status --short --untracked-files=all`, branch, HEAD, upstream,
   ahead/behind counts, and staged versus unstaged state.
4. If changes predate this audit, preserve them and separate them from audit
   findings.

## Expected model

- Canonical tracked skills: `agents/.agents/skills/{name}`.
- Static Claude compatibility links: `agents/.claude/skills/{name}`.
- Codex runtime discovery: `$HOME/.agents/skills`; do not duplicate approved
  skills in application-managed `$HOME/.codex`.
- The `agents` package requires `stow --no-folding`; both
  `$HOME/.agents/skills` and `$HOME/.claude/skills` are real directories.
- Ownership classes are local, intentional local fork, approved vendored
  third party, generated runtime, and application managed.
- Generated `framer-project-*` directories and their runtime-only Claude links
  remain outside Git. Application credentials, databases, sessions, logs,
  caches, application-managed skills, and broad host state remain outside Git.

## Audit

Inspect `AGENTS.md`, `README.md`, `CODEX_USAGE.md`, `agents/README.md`,
`agents/skills.conf`, `agents/skills-lock.json`,
`agents/SKILLS_REGISTRY.md`, `agents/THIRD_PARTY.md`,
`agents/.stow-local-ignore`, tracked skill frontmatter and links,
`scripts/agent-skills`, and applicable licences.

Check:

- configured, tracked, registered, locked, and Claude-linked inventories agree;
- each `SKILL.md` has a matching non-empty name and description;
- local/fork names never overlap installer allowlists;
- third-party source, content hash, licence, provenance, dependencies, and
  executable modes are recorded;
- Codex-only skills have no Claude link;
- tracked and deployed links resolve to canonical source;
- no generated/private/application state leaked into Git;
- no obsolete mixed-runtime manager or global-install instruction remains.

Use read-only validation:

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
bash -n scripts/agent-skills
scripts/agent-skills status
scripts/agent-skills audit
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Inspect real runtime entries with `stat`, `readlink`, and `realpath` only when
needed. A Stow simulation is allowed; applying or deleting links is not.

## Report

Report repository state, tracked topology, skill inventory by ownership,
runtime parent/link health, documentation findings, risks, skipped checks, and
a prioritized change plan. State explicitly that no files or runtime state
changed.

End with a reusable YAML handoff:

```yaml
operation: audit-agent-configuration
repository:
  path:
  branch:
  head:
  tracking:
  ahead:
  behind:
  staged_files:
  unstaged_files:
  untracked_files:
architecture:
  tracked_skill_root: agents/.agents/skills
  claude_link_root: agents/.claude/skills
  agents_stow_flags: [--no-folding]
inventory:
  local: []
  local_forks: []
  vendored_third_party: []
  codex_only: []
  generated_excluded: []
validation:
  passed: []
  failed: []
findings: []
recommended_changes: []
runtime_changed: false
unresolved_blockers: []
```
