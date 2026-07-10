# Update the approved Matt Pocock skills

## Objective

Audit the latest Matt Pocock release, then update exactly the approved skill
allowlist configured in `agents/skills.conf` from `mattpocock/skills`,
preserving the vendored Stow architecture and every local skill/fork. Treat
`MATT_SKILLS` as the final suite selection; do not revive obsolete planning
names such as `to-prd`, `to-plan`, or `to-issues`.

If a valid prior YAML handoff is supplied, continue from it and reconfirm only
mutable safety-critical state. Do not repeat an already completed audit.

## Authority and safety

- Repository edits and the explicit Matt project-scoped installer run are
  authorized. Applying/removing Stow links or changing real runtime paths is
  not authorized.
- Do not stage, commit, push, pull, fetch, or change branches.
- Never use `--global`, `-g`, `--all`, a global update, or a vague
  “update everything” selection.
- Never run `skills update --help`; the audited CLI previously mutated a
  runtime while handling that command. Inspect help/source only in an
  isolated fixture.
- Preserve all pre-existing and unrelated changes. Do not reset, restore,
  clean, or broadly delete.
- Do not read/copy secrets, private generated data, or application-managed
  `.codex`/Claude state.

## Discovery and canonical model

Find the root with `git rev-parse --show-toplevel`, read applicable
`AGENTS.md`, inspect branch/HEAD/upstream and full staged, unstaged, and
untracked status, then read `agents/skills.conf`, lock, registry, provenance,
licences, package README, and `skills-maintainer`.

Use the configured `MATT_SKILLS` value as the sole operational allowlist; do
not maintain a second hardcoded list. Canonical source is
`agents/.agents/skills`; static Claude links are in
`agents/.claude/skills`; runtime parents stay real through
`stow --no-folding`. Distinguish local, local fork, vendored third party,
generated runtime, and application-managed content. Protect local/fork names,
generated `framer-project-*`, and broad `.codex` state.

Before installation, compare the allowlist with current upstream names and
dependencies. Record the release/version, upstream commit, invocation class,
renames, removals, and additions. When the approved selection changes, pass
that exact set to the installer and immediately reconcile `MATT_SKILLS`, the
registry, and provenance so the wrapper remains the sole durable source of
truth.

## Workflow

1. Record or require a clean tree; if acknowledged changes exist, inventory
   them before installation and later separate them from this update.
2. Confirm the Matt allowlist does not overlap `LOCAL_SKILLS` or
   `LOCAL_FORK_SKILLS`, and configured targets include Codex and Claude Code.
3. Preserve an external scoped backup if current vendored or runtime evidence
   is ambiguous.
4. Run `scripts/agent-skills pre-install`.
5. Resolve and record the current CLI version, then run from exactly the
   package directory:

   ```sh
   cd "$DOTFILES/agents"
   npx --yes skills@latest add mattpocock/skills \
     --skill $MATT_SKILLS \
     --agent $SKILLS_TARGET_AGENTS \
     --yes
   ```

   Use the exact expanded command printed by `pre-install`; the variables
   above denote values read from `agents/skills.conf`. Remain in project
   scope.
6. Stop on any unexpected name or runtime change. Do not auto-revert.
7. Review every file addition, modification, upstream deletion, symlink,
   executable-mode change, and `skills-lock.json` delta. Removed upstream
   support files require deliberate review.
8. Verify `grill-with-docs` still has its required `grilling` dependency and
   reconcile every other documented dependency.
9. Verify source attribution, MIT licence copy, upstream revision when
   verifiable, content hashes, targets, and provenance. Record the resolved
   CLI version as update evidence, not as a fixed operational pin.
10. Run `scripts/agent-skills post-install` and update documentation only
    after the content review.

## Validation

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
git diff --summary
bash -n scripts/agent-skills
scripts/agent-skills post-install
scripts/agent-skills audit
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Verify allowlist/lock parity, hashes, frontmatter, relative links, static
Claude links, licence/provenance, executable modes, generated exclusions, and
that no approved skill is duplicated under application-managed `.codex`.
Simulation is allowed; do not apply Stow.

## Report and handoff

Report pre-existing state, configured selection/targets, exact command,
resolved CLI and upstream revision, additions/modifications/deletions/modes,
dependency and lock review, docs, validation, and runtime unchanged state.

```yaml
operation: update-matt-pocock-skills
source: mattpocock/skills
configured_allowlist: []
targets: []
resolved_cli_version:
upstream_revision:
pre_existing_changes: []
files_created: []
files_modified: []
files_deleted: []
modes_changed: []
lock_review:
dependency_review:
license_and_provenance:
validation:
  passed: []
  failed: []
project_scope: true
runtime_changed: false
staged: false
committed: false
pushed: false
unresolved_blockers: []
```
