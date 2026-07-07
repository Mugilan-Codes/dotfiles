# Install selected third-party skills

## Objective and inputs

Vendor only the requested third-party skills into the dotfiles repository.

- Source: `<SOURCE_REPOSITORY>`
- Skills: `<SKILL_NAMES>`
- Targets: `<TARGET_AGENTS>` (default to `codex claude-code` where compatible)

Infer existing paths, configuration, and documentation conventions from the
repository. Ask only if a required input cannot be inferred safely.

If a valid prior YAML handoff is supplied, trust completed work and reconfirm
only mutable safety-critical state instead of repeating the audit.

## Authority and safety

- Repository edits and one project-scoped installer operation for the named
  source/skills are authorized. Real runtime changes are not authorized.
- Do not stage, commit, push, pull, fetch, create/switch branches, or apply
  Stow unless separately requested.
- Do not install globally; never use `--global`, `-g`, or `--all`.
- Do not run broad cleanup or destructive Git commands.
- Preserve unrelated existing changes. If the worktree is not clean, list and
  explicitly distinguish acknowledged pre-existing changes before installing.
- Do not inspect or copy secrets, generated/private project data, or broad
  `.codex`/Claude application state.
- Do not use `skills update --help`: the audited CLI previously performed an
  update instead of showing help. Inspect top-level help or source metadata in
  an isolated temporary fixture without touching real runtime state.

## Repository discovery and model

1. Find the root with `git rev-parse --show-toplevel`.
2. Read applicable `AGENTS.md` and inspect complete Git status, branch, HEAD,
   upstream, and staged/unstaged/untracked state.
3. Read `agents/skills.conf`, registry, provenance, lock, package README, and
   the `skills-maintainer` skill.

The canonical tracked root is `agents/.agents/skills`; static relative Claude
links live in `agents/.claude/skills`. The `agents` package always uses
`stow --no-folding`, keeping runtime parent directories real. Classify every
name as local, local fork, approved vendored third party, generated runtime,
or application managed. Never overwrite local/fork names, import generated
`framer-project-*`, or vendor application-managed `.codex` state.

## Workflow

1. Verify the selected names do not collide with local/fork/generated names.
2. Inspect available upstream names safely and confirm only `<SKILL_NAMES>`
   will be selected. Do not turn the request into “update everything.”
3. Run:

   ```sh
   scripts/agent-skills pre-install
   ```

4. Capture the resolved version for `skills@latest` in the report.
5. From the package directory only, run the explicit project install:

   ```sh
   cd "$DOTFILES/agents"
   npx --yes skills@latest add <SOURCE_REPOSITORY> \
     --skill <SKILL_NAMES> \
     --agent <TARGET_AGENTS> \
     --yes
   ```

   Adapt repeated arguments only as required by verified current CLI syntax.
   Do not add a global flag.
6. Stop if the installer touches real runtime/application paths or any name
   outside the selection. Preserve evidence; do not auto-revert.
7. Review every added, modified, deleted, symlink, executable-mode, and lock
   change using Git status, diffs, and diff summaries.
8. Run `scripts/agent-skills post-install`.
9. Update exact allowlists, `SKILLS_REGISTRY.md`, `THIRD_PARTY.md`, licence
   records, dependencies, targets, source, resolved CLI version, and upstream
   revision when verifiable. Reconcile `skills-lock.json`; never rewrite it
   blindly.
10. Simulate, but do not apply, runtime deployment:

   ```sh
   stow --target="$HOME" --simulate --no-folding --verbose agents
   ```

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

Also verify frontmatter, relative links, Claude targets, content hashes,
licences, executable modes, generated exclusions, and absence of unintended
`.codex` contents.

## Report and handoff

Report inputs, pre-existing changes, exact installer command, resolved CLI
version, upstream revision evidence, all file/mode/link/lock changes,
validation, runtime unchanged state, and skipped checks. Do not claim a clean
tree if unrelated or earlier changes remain.

```yaml
operation: install-third-party-skills
source:
selected_skills: []
targets: []
resolved_cli_version:
upstream_revision:
pre_existing_changes: []
files_created: []
files_modified: []
files_deleted: []
symlinks_changed: []
modes_changed: []
lock_changes: []
documentation_changes: []
validation:
  passed: []
  failed: []
installer_ran: true
project_scope: true
runtime_changed: false
staged: false
committed: false
pushed: false
unresolved_blockers: []
```
