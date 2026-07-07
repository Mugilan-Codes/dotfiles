# Update `here-now`

## Objective

Update only the approved `here-now` skill from `heredotnow/skill` through the
project-scoped `skills@latest` workflow, with explicit review of its executable
scripts and licence caveat.

Use any valid supplied YAML handoff without repeating completed audits;
reconfirm only mutable repository/runtime safety state.

## Authority and safety

- Repository edits and this one project-scoped installer operation are
  authorized. Real runtime/Stow changes are not.
- Do not stage, commit, push, pull, fetch, or create/switch branches.
- Never use `--global`, `-g`, `--all`, global update, or update unrelated
  skills.
- Never run `skills update --help`; it behaved as a mutating command in the
  audited CLI. Inspect help/source only in a disposable fixture.
- Preserve existing and unrelated changes. Do not reset, restore, clean, or
  broadly delete.
- Do not inspect or copy secrets, private generated data, session state, or
  broad `.codex`/Claude application contents.

## Discovery and architecture

Find the repository root, read applicable `AGENTS.md`, inspect branch, HEAD,
upstream, staged/unstaged/untracked status, and read `agents/skills.conf`,
lock, registry, provenance, package README, and `skills-maintainer`.

Canonical tracked source is `agents/.agents/skills`; Claude compatibility
uses static relative links in `agents/.claude/skills`; `agents` requires
`stow --no-folding` and real runtime parent directories. Keep local skills,
local forks, approved vendored skills, generated runtime, and
application-managed state distinct. Never import `framer-project-*` or broad
`.codex` state.

## Workflow

1. Confirm `HERE_NOW_SOURCE` is `heredotnow/skill`, the allowlist contains
   only `here-now`, and it does not collide with local/fork ownership.
2. Require a clean tree or explicitly inventory acknowledged prior changes.
3. Preserve a scoped external backup if existing evidence is ambiguous.
4. Run `scripts/agent-skills pre-install`.
5. Resolve and record the CLI version, then run only from the package:

   ```sh
   cd "$DOTFILES/agents"
   npx --yes skills@latest add heredotnow/skill \
     --skill here-now \
     --agent $SKILLS_TARGET_AGENTS \
     --yes
   ```

   Use the exact expanded target arguments printed by `pre-install`; the
   variable above denotes the configured value.

6. Stop on unexpected names or runtime changes; preserve evidence.
7. Review all file, deletion, symlink, mode, and lock changes. Inspect changes
   to these security-sensitive executable scripts line by line:

   ```text
   agents/.agents/skills/here-now/scripts/drive.sh
   agents/.agents/skills/here-now/scripts/publish.sh
   ```

   Confirm both retain executable mode and do not introduce unexpected
   credential access, upload/publish behavior, command execution, or unsafe
   path handling.
8. Preserve the documented caveat that upstream declares MIT in its README
   but lacks a top-level licence file, unless verified upstream evidence has
   changed. Do not invent a licence copy.
9. Verify the vendored `SKILL.md` install note remains project-scoped and does
   not recommend `--global` or `-g`. If an installer reintroduces upstream
   global-install wording, replace only that note with this repository's
   project-scoped workflow and update the lock/provenance records.
10. Verify source, content hash, targets, static Claude link, upstream revision
   when verifiable, lock record, dependencies, and provenance.
11. Run `scripts/agent-skills post-install`, then make exact documentation
    updates. Do not apply Stow.

## Validation

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
git diff --summary
bash -n agents/.agents/skills/here-now/scripts/drive.sh
bash -n agents/.agents/skills/here-now/scripts/publish.sh
bash -n scripts/agent-skills
scripts/agent-skills post-install
scripts/agent-skills audit
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Also verify frontmatter, relative links, executable modes in Git and the
worktree, generated exclusions, and absence of unintended `.codex` content.

## Report and handoff

```yaml
operation: update-here-now
source: heredotnow/skill
selected_skills: [here-now]
targets: []
resolved_cli_version:
upstream_revision:
pre_existing_changes: []
files_created: []
files_modified: []
files_deleted: []
script_review:
  drive_sh:
  publish_sh:
executable_modes_preserved:
lock_review:
license_caveat:
install_policy_note:
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
