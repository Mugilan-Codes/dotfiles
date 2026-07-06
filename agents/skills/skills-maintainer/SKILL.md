---
name: skills-maintainer
description: Audit and maintain this dotfiles repository's local, third-party, and generated agent skills without confusing runtime installations with editable source.
---

# Skills Maintainer

Use this skill to maintain the declared agent-skill topology in the dotfiles
repository and the runtime views used by Codex and Claude Code.

## Topology

- Dotfiles-owned skills and intentional forks: `$DOTFILES/agents/skills/<name>`
- Third-party desired state: `$DOTFILES/agents/skills.conf`
- Canonical runtime view: `$HOME/.agents/skills/<name>`
- Claude Code compatibility view: `$HOME/.claude/skills/<name>`
- Generated Framer project state: real runtime directories matching
  `$HOME/.agents/skills/framer-project-*`
- Third-party CLI state: `$HOME/.agents/.skill-lock.json`

`$DOTFILES` means the current repository root, resolved with
`git rev-parse --show-toplevel`. A local clone of `mattpocock/skills` is not
part of this topology.

## Ownership Rules

1. Edit a skill only when it is declared in `LOCAL_SKILLS` and its source is
   under `$DOTFILES/agents/skills`.
2. Treat runtime third-party directories as CLI-owned artifacts. Never edit
   them as local source; change the allowlist or update through
   `scripts/agent-skills`.
3. A local fork needs explicit ownership, upstream attribution, and local
   change notes in `agents/SKILLS_REGISTRY.md` and `agents/THIRD_PARTY.md`.
4. Keep generated `framer-project-*` directories outside Git. They may contain
   private project metadata.
5. Never install through, write through, or preserve a whole-directory
   `$HOME/.agents/skills` symlink. It can turn a runtime mutation into a hidden
   repository edit.
6. Never use the skills CLI to install a local source from inside
   `$HOME/.agents/skills`. Local links belong to the dotfiles wrapper.

## Workflow

1. Inspect repository status and the entry types under both runtime roots.
2. Run `scripts/agent-skills plan`.
3. For an audit-only request, stop after reporting the plan and status.
4. For an authorized implementation, update local source or
   `agents/skills.conf`, refresh the registry and attribution, then run
   `scripts/agent-skills install`.
5. Use `scripts/agent-skills update` only when third-party updates are
   explicitly authorized.
6. Run `scripts/agent-skills status` after every runtime change.

The wrapper must remain collision-safe: it may create missing managed links,
but it must refuse real directories, regular files, unexpected symlinks,
local modifications to CLI-managed contents, or links into a removable local
clone.

## Validation

Verify every configured skill has:

- a `SKILL.md`
- non-empty `name` and `description` frontmatter
- a directory name matching its declared name
- resolvable relative Markdown references
- exactly one configured owner
- a valid Codex path and, when configured, a Claude Code compatibility link

Also check for broken links, unexpected copies, duplicate names, stale CLI
source records, generated-state leakage into Git, and undocumented forks.

## Documentation

Update these files when ownership or lifecycle changes:

- `agents/README.md`
- `agents/SKILLS_REGISTRY.md`
- `agents/THIRD_PARTY.md`
- `README.md` when bootstrap commands change
- `AGENTS.md` when repository policy changes

Recommend a fresh Codex or Claude Code session when skills are added, removed,
renamed, or their frontmatter changes.
