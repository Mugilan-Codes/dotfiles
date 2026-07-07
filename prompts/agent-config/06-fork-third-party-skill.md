# Fork a third-party skill

## Objective and inputs

Make an intentional, reviewed local fork authoritative in this repository.

- Skill: `<SKILL_NAME>`
- Upstream: `<UPSTREAM_SOURCE>`
- Reason: `<REASON_FOR_FORK>`

Do not classify unexplained drift as a fork. Establish provenance and the
deliberate local delta first.

## Authority and safety

- Repository edits needed to create/reclassify the fork and its documentation
  are authorized. No installer or real runtime/Stow change is authorized.
- Do not stage, commit, push, pull, fetch, or change branches.
- Preserve existing/unrelated changes and evidence. Do not reset, restore,
  clean, or broadly delete.
- Never use global skill installation or overwrite a local/fork name through
  an installer. This workflow does not run `skills@latest`; a separately
  authorized third-party operation must run it only from `dotfiles/agents`.
- Do not inspect/copy secrets, private generated data, or broad
  application-managed `.codex`/Claude contents.
- If a valid handoff exists, continue from it and reconfirm only mutable
  safety-critical state.

## Discovery and canonical model

Find the Git root, read applicable `AGENTS.md`, inspect branch, HEAD, upstream,
and staged/unstaged/untracked status. Read the skill, `agents/skills.conf`,
`skills-lock.json`, registry, provenance, licences, package README, and
`skills-maintainer`.

Canonical tracked content belongs under `agents/.agents/skills`; static
Claude links belong under `agents/.claude/skills`. Runtime parents remain real
through `stow --no-folding`. Distinguish local, intentional local fork,
approved vendored third party, generated runtime, and application-managed
content. Generated `framer-project-*` and broad `.codex` state cannot become
fork source.

## Workflow

1. Identify current ownership and all tracked/runtime/lock/registry references.
   Stop if the named content is generated, private, or application-managed.
2. Verify `<UPSTREAM_SOURCE>`, applicable licence, attribution, and source
   revision when available. Preserve the upstream licence and notices.
3. Compare the proposed fork with upstream and document the exact local delta,
   purpose, compatibility implications, and maintenance burden. Never silently
   fork because files happen to differ.
4. Keep or place the authoritative fork at
   `agents/.agents/skills/<SKILL_NAME>`. Preserve supporting relative links and
   valid matching frontmatter.
5. Reclassify the name into `LOCAL_FORK_SKILLS` and remove it from all
   automatic third-party allowlists. A fork must not be installer-owned.
6. If it was vendored, remove/reconcile only its own project-lock entry; verify
   lock ownership for every remaining third-party name. Do not blindly rewrite
   the lock.
7. Record upstream, revision evidence, licence, reason, and local changes in
   `agents/THIRD_PARTY.md` and `agents/SKILLS_REGISTRY.md`.
8. Keep the same skill name only after explicitly checking collision and
   discovery behavior for Codex and Claude. Create/retain the relative static
   Claude link only when intended; otherwise record Codex-only classification.
9. Protect the name from future install/update selections and document manual
   upstream review as its update method.
10. Simulate Stow; do not apply it.

## Validation

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
bash -n scripts/agent-skills
scripts/agent-skills audit
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Verify frontmatter, references, licence/provenance, exact documented delta,
fork/allowlist disjointness, lock reconciliation, dependencies, modes, Claude
targeting, generated exclusions, and absence of broad `.codex` content.

## Report and handoff

```yaml
operation: fork-third-party-skill
skill:
  name:
  ownership: local-fork
  upstream:
  upstream_revision:
  reason:
  local_delta: []
  targets: []
license:
allowlist_changes: []
lock_changes: []
files_created: []
files_modified: []
files_deleted: []
symlinks_changed: []
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
