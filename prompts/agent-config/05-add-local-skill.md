# Add a local skill

## Objective and inputs

Create a user-authored skill in the canonical tracked package.

- Name: `<SKILL_NAME>`
- Purpose: `<PURPOSE>`
- Targets: optional `<TARGET_AGENTS>`; infer Codex and Claude compatibility
  from the content when omitted, and explain the choice.

Use a valid prior YAML handoff without repeating completed audits. Infer
repository conventions before asking for information.

## Authority and safety

- Creating/editing the local skill and its repository metadata is authorized.
- Do not run an installer, apply/remove Stow links, or alter real runtime
  paths.
- Do not stage, commit, push, pull, fetch, or change branches. Use the separate
  final-review prompt if staging/commit is later authorized.
- Preserve every pre-existing/unrelated change. Do not reset, restore, clean,
  or broadly delete.
- Never use global skill installation. This local workflow does not run
  `skills@latest`; a later third-party operation must use it only in project
  scope from `dotfiles/agents`.
- Do not include secrets, credentials, project-private generated data,
  session/history contents, databases, logs, caches, or application-managed
  `.codex`/Claude state.

## Discovery and canonical model

Find the repository root with Git, read applicable `AGENTS.md`, inspect branch,
HEAD, upstream, and complete staged/unstaged/untracked status. Read
`agents/skills.conf`, registry, provenance, package README, neighbouring local
skills, and `skills-maintainer`.

Create canonical source under:

```text
agents/.agents/skills/<SKILL_NAME>
```

Static Claude compatibility links belong under `agents/.claude/skills`.
Codex reads `$HOME/.agents/skills`. The `agents` package always uses
`stow --no-folding` so runtime parents remain real. Keep ownership categories
separate: local, local fork, approved vendored third party, generated runtime,
and application managed. This workflow creates only a local skill; it must not
import `framer-project-*` or broad `.codex` state.

## Workflow

1. Validate `<SKILL_NAME>` against repository naming conventions and confirm
   it does not collide with any configured, tracked, locked, runtime-generated,
   or application-managed skill.
2. Create a focused `SKILL.md` with YAML frontmatter:

   ```yaml
   ---
   name: <SKILL_NAME>
   description: <non-empty trigger-oriented description>
   ---
   ```

   The directory and declared name must match exactly.
3. Add only necessary supporting files. Use relative Markdown links and avoid
   machine-specific paths or private data.
4. Add the name to the local ownership list in `agents/skills.conf`; never add
   it to a third-party allowlist or `skills-lock.json`.
5. Update `agents/SKILLS_REGISTRY.md` and practical documentation with the
   local ownership, purpose, targets, dependencies, and edit-locally update
   method. Update `THIRD_PARTY.md` only if attribution is genuinely relevant.
6. If Claude-compatible, create this relative tracked link:

   ```text
   agents/.claude/skills/<SKILL_NAME>
     -> ../../.agents/skills/<SKILL_NAME>
   ```

   If intentionally Codex-only, add it to the configured Codex-only inventory
   and do not create a Claude link. Explain the compatibility decision.
7. Do not create runtime links directly. Simulate deployment only.

## Validation

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
bash -n scripts/agent-skills
scripts/agent-skills audit
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Verify frontmatter/name/description, all relative references, ownership-list
uniqueness, registry entry, lock exclusion, Claude-link target or Codex-only
classification, file modes, generated/private exclusions, and no unintended
`.codex` contents.

## Report and handoff

Report the skill design, target decision, every created/modified/symlinked
path, pre-existing changes, validation, runtime unchanged state, and any
follow-up. Do not report the worktree as clean when earlier changes remain.

```yaml
operation: add-local-skill
skill:
  name:
  purpose:
  ownership: local
  targets: []
  dependencies: []
files_created: []
files_modified: []
symlinks_created: []
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
