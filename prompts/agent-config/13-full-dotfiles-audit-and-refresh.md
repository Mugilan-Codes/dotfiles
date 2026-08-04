# Full dotfiles audit and refresh

## Objective

Perform a complete maintenance pass on this dotfiles repository after a long
interval. Audit repository structure, Git state, Stow topology, tracked skill
ownership, runtime links, frontmatter, Markdown references, executable modes,
licenses, provenance, lock hashes, documentation, requirements, and generated
state. Check current upstream refs read-only, refresh every already-approved
third-party allowlist, and install only the requested Taste default:
`Leonxlnx/taste-skill` → `design-taste-frontend`.

Explain for each installed skill what it does, when it should be considered,
whether it is model-invoked or user-invoked, and whether it has hooks, scripts,
watchers, or background behavior. Produce keep/remove recommendations, but do
not remove skills without a separate explicit request.

## Authority and safety

- Repository edits and explicit project-scoped installer runs for the
  configured third-party sources are authorized.
- Never install globally; do not use `--global`, `-g`, or `--all`.
- Do not apply or remove Stow, change real runtime paths, stage, commit, push,
  pull, fetch, switch branches, or deploy externally.
- Simulate Stow only. Treat real runtime deployment as a separate next action.
- Preserve unrelated changes. Do not reset, restore, clean, broadly delete,
  or inspect secrets, credentials, private generated state, databases, logs,
  caches, or broad application-managed `.codex`/Claude state.
- Protect local skills, intentional forks, generated `framer-project-*`
  directories, and application-managed state from third-party installers.

## Workflow

1. Read the repository instructions and inspect structure, complete Git status,
   branch, HEAD, tracking, and staged/unstaged/untracked state.
2. Read `agents/skills.conf`, the lock, registry, provenance, licenses,
   package README, `skills-maintainer`, and the existing audit/update prompts.
3. Inventory every skill by ownership, target agent, source, dependencies,
   invocation mode, scripts, executable files, and likely overlap.
4. Check current upstream refs with read-only requests. Record the CLI version,
   source revisions, available Taste skill names, license evidence, and any
   scanner warnings. Review changed instructions and scripts manually.
5. Run `scripts/agent-skills pre-install`, then from `dotfiles/agents` run
   explicit project-scoped updates for the configured Matt and `here-now`
   selections and install only `design-taste-frontend` for Codex and Claude
   Code.
6. Review every file, deletion, symlink, mode, support metadata, and lock
   change. Reapply documented local adaptations only where justified.
7. Reconcile `skills.conf`, `skills-lock.json`, `SKILLS_REGISTRY.md`,
   `THIRD_PARTY.md`, licenses, README files, and prompt links. Never rewrite
   the lock blindly.
8. Run the repository validators, relevant shell checks, `git diff --check`,
   and `stow --target="$HOME" --simulate --verbose agents`.

## Required report

Report only changed files, update evidence, skill inventory and keep/remove
recommendations, validation results, runtime state, blockers, and next action.
State explicitly whether the new Taste skill is discoverable only after a
fresh agent session and whether real Stow deployment remains pending.

```yaml
operation: full-dotfiles-audit-and-refresh
upstream_sources: []
updated_skills: []
installed_skills: [design-taste-frontend]
keep_recommendations: []
remove_recommendations: []
pre_existing_changes: []
files_created: []
files_modified: []
files_deleted: []
symlinks_changed: []
modes_changed: []
lock_changes: []
validation:
  passed: []
  failed: []
project_scope: true
runtime_changed: false
staged: false
committed: false
pushed: false
unresolved_blockers: []
next_action:
```
