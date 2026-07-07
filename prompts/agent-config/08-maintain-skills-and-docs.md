# Maintain skills and documentation

## Objective

Reconcile the agent package after additions, updates, forks, removals, or
manual edits. Validate ownership and topology, then make only exact
documentation/configuration corrections justified by the current diff.

Use or follow the repository's `skills-maintainer` skill. If a valid handoff
describes the preceding operation, trust it for completed work and verify
only mutable state plus the resulting diff.

## Authority and safety

- Repository edits to agent configuration, registry, provenance, licences, and
  documentation are authorized.
- Do not run an installer, apply/remove Stow, alter real runtime paths, stage,
  commit, push, pull, fetch, or change branches. Use the separate final-review
  prompt if staging/commit is later authorized.
- Preserve unrelated and pre-existing changes; identify them before editing.
- Do not reset, restore, clean, broadly rewrite docs, or perform destructive
  cleanup.
- Never use global skill installation. This maintenance pass does not run
  `skills@latest`; any later authorized add/update must run only in project
  scope from `dotfiles/agents`.
- Do not inspect/copy secrets, private generated data, sessions, databases,
  logs, caches, or broad `.codex`/Claude application state.

## Discovery and expected model

Find the Git root, read applicable `AGENTS.md`, inspect branch, HEAD, upstream,
and all staged/unstaged/untracked changes. Read `skills-maintainer`,
`agents/skills.conf`, project lock, registry, provenance, licences, package
README, and every changed skill.

Canonical tracked skills live in `agents/.agents/skills`; static relative
Claude links live in `agents/.claude/skills`; Codex reads
`$HOME/.agents/skills`. `stow --no-folding` is mandatory for `agents`, keeping
runtime parents real. Classify names as local, local fork, approved vendored
third party, generated runtime, or application managed. Generated
`framer-project-*` and broad `.codex` state remain outside Git.

## Maintenance checks

1. Inventory changed names and determine exact ownership, source, targets,
   dependencies, update method, and whether the change came from an authorized
   installer.
2. Validate each `SKILL.md` frontmatter name/description, folder name,
   supporting relative links, dependencies, executable modes, and absence of
   private/generated content.
3. Reconcile ownership lists and explicit third-party allowlists without
   overlapping local/fork names.
4. Reconcile project-lock names, sources, and hashes only for approved
   third-party skills. Treat stale removal entries explicitly.
5. Verify licence copies/caveats, upstream attribution and revision evidence,
   documented local-fork deltas, and resolved CLI version for installer runs.
6. Verify every intended Claude link is relative and canonical, and every
   Codex-only skill lacks one.
7. Confirm runtime topology expectations and generated exclusions. Do not
   weaken validators merely to accommodate drift.
8. Update only inaccurate sections of `SKILLS_REGISTRY.md`,
   `THIRD_PARTY.md`, `agents/README.md`, root docs, or prompt guidance. Do not
   blindly regenerate prose.
9. Run `scripts/agent-skills post-install` only when reviewing an installer
   result; always run `status` and `audit`.

## Validation

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

When relevant:

```sh
scripts/agent-skills post-install
```

Review added/deleted paths, symlinks, and executable modes in both unstaged and
staged diffs. Confirm no global-install instruction or fixed obsolete CLI pin
was introduced.

## Report and handoff

List exact documentation/config changes and why each was required; inventory,
ownership, source/licence/lock/mode/link results; pre-existing changes;
validation; runtime unchanged state; and skipped checks.

```yaml
operation: maintain-skills-and-docs
triggering_change:
skills_reviewed: []
ownership_changes: []
configuration_changes: []
lock_changes: []
license_and_provenance_changes: []
documentation_changes: []
symlink_or_mode_changes: []
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
