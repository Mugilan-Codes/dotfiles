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
   Update them only through the explicit project-scoped installer workflow.
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

The `agents` package must always use `stow --no-folding`. Runtime parent
directories remain real so generated and application-owned entries can
coexist. With GNU Stow 2.4.1, tracked skill directories are materialized as
real runtime directories whose files are individual Stow-managed links.

Always simulate before applying:

```sh
stow --target="$HOME" --simulate --no-folding --verbose agents
stow --target="$HOME" --no-folding --verbose agents
```

Never use `--adopt` for this package.

## Third-party workflow

Run the installer only from `$DOTFILES/agents`, only in project scope, and
only for names allowlisted in `skills.conf`:

```sh
cd "$DOTFILES/agents"
npx skills@latest add mattpocock/skills
npx skills@latest add heredotnow/skill
```

Select project scope, the explicit approved names, Codex, and Claude Code.
Never use `--global`, `-g`, `--all`, or a global update. Non-interactive
automation must spell out every selected skill and agent.

`skills@latest` is intentional. Record the resolved CLI version in every
update report, inspect its current help in an isolated fixture, and review all
resulting Git changes. The CLI may recreate vendored directories and remove
files deleted upstream.

Use the read-only guardrails:

```sh
scripts/agent-skills pre-install
scripts/agent-skills post-install
scripts/agent-skills audit
scripts/agent-skills status
```

The CLI's remove operation may leave stale entries in project
`skills-lock.json`. Inspect and reconcile those entries explicitly; never
rewrite the lock blindly.

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
- Stow runtime file links resolve into the dotfiles repository
- the generated Framer directory and its runtime Claude link remain intact

Every installer result needs a Git diff review before documentation is
declared current or changes are committed. Start fresh Codex and Claude Code
sessions after discovery-affecting changes.
