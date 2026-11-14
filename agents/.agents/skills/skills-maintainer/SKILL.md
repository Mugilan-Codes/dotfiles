---
name: skills-maintainer
description: Audit and maintain this dotfiles repository's Git-vendored local, forked, and approved third-party agent skills without confusing tracked source with generated or application-managed runtime state.
---

# Skills Maintainer

Use this skill for changes to the agent-skill package, allowlists, provenance,
licenses, validation, or Stow deployment in this dotfiles repository.

## Canonical topology

- Tracked skills: `$DOTFILES/agents/.agents/skills/<name>`
- Tracked Claude compatibility links:
  `$DOTFILES/agents/.claude/skills/<name>`
- Project installer lock: `$DOTFILES/agents/skills-lock.json`
- Runtime Codex/universal view: `$HOME/.agents/skills/<name>`
- Runtime Claude view: `$HOME/.claude/skills/<name>`
- Generated Framer state: real directories matching
  `$HOME/.agents/skills/framer-project-*`

`$DOTFILES` is the result of `git rev-parse --show-toplevel`.

Both locally owned and approved third-party skills are Git-tracked. The
repository contents—not an installer cache or CLI version—are the
reproducible artifact.

## Ownership rules

1. Edit local skills and intentional forks only in
   `agents/.agents/skills/<name>`.
2. Treat approved third-party contents there as reviewed vendored source.
   Update them through the explicit reviewed agent-skills lifecycle or project-scoped installer workflow.
3. Protect local names and forks from every third-party selection. Stop on a
   name collision.
4. Keep generated `framer-project-*` directories outside Git; they may contain
   private project metadata.
5. Keep `$HOME/.codex` application-managed. Do not vendor system/plugin
   skills or build a broad Codex Stow package.
6. Keep Claude compatibility links relative and tracked. Do not duplicate
   skill contents under `.claude`.
7. Update `SKILLS_REGISTRY.md`, `THIRD_PARTY.md`, applicable licenses, and
   `skills.conf` whenever ownership, source, selection, or provenance changes.

## Stow model

The repository is canonical. `$HOME/.agents/skills`,
`$HOME/.claude/skills`, and `$HOME/.codex` remain real parent directories so
generated and application-owned entries can coexist. Ordinary Stow exposes
each managed child skill as one directory-level symlink to its matching
canonical repository directory. Never create an independent `SKILL.md`
symlink inside a real runtime skill directory.

Use the repository wrapper for topology and ownership validation. Always
simulate before any separately authorized apply:

```sh
scripts/agent-skills status
scripts/agent-skills audit
stow --target="$HOME" --simulate --verbose agents
```

Never use `--no-folding` or `--adopt` for this package. Preserve unmanaged
siblings, especially real `framer-project-*` directories. Adding or updating
a skill can require a fresh Codex or Claude Code session before discovery
changes appear.

## Reviewed lifecycle

Use `scripts/agent-skills list` and `check` to separate managed, external and
unmanaged state. Follow `agents/README.md` for implemented `add`, `add-repo`,
`import`, `update`, `record-patch` and `deploy` commands. Pinned repository
imports require a full revision and subdirectory; local origin must be honest.
Imports copy the complete reviewed package without executing scripts. Preserve
license information, supported-agent distinctions and dependency declarations.

Updates refuse local drift. Local/fork/patch-bearing candidates require an
explicit explanation of patch preservation. Review every diff before recording
new hashes. `record-patch` records a concrete change and review evidence; it is
not permission to bless unexplained content. Existing installer hashes remain
in `skills-lock.json`; lifecycle provenance is in `skills-manifest.json`.

If using the legacy `npx skills@latest add SOURCE` workflow, run `pre-install`
first and `post-install` afterward from `dotfiles/agents`, project scope only.
Select approved names/agents, never global or all. Record the resolved CLI
version and review/reconcile changed packages and stale lock entries. Do not
use `skills update --help` on live source; it previously performed an update.
Never overwrite local forks or strip the here-now safety patch on update.

Restore plugin-owned skills through the owning installer recorded in
`external-skills.json`; do not vendor caches. New unmanaged skills remain
reported until their provenance and contents have been explicitly reviewed.

## Validation

Confirm:

- every configured directory has `SKILL.md` with a matching name and a
  non-empty description
- relative Markdown references resolve
- configured executable files retain executable mode
- Claude links resolve to tracked canonical skills
- the project lock matches only approved third-party sources and contents
- generated/private state is absent from Git
- no approved skill is duplicated under `$HOME/.codex/skills`
- every managed runtime skill is a directory symlink to the matching
  canonical repository directory, with no separately linked `SKILL.md`
- the generated Framer directory and its runtime Claude link remain intact

Every installer result needs a Git diff review before documentation is
declared current or changes are committed. Start fresh Codex and Claude Code
sessions after discovery-affecting changes.
