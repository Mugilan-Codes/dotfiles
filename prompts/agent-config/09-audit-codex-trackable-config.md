# Audit a portable skill candidate

## Objective

Decide whether one specifically identified, user-authored custom skill belongs
in the canonical dotfiles skill package. This is not an inventory or lifecycle
workflow for application-managed skills or plugins. Audit-only is the default.

- Candidate path: `<EXACT_CANDIDATE_PATH>`
- Claimed provenance: `<HOW_THIS_WAS_AUTHORED_OR_OBTAINED>`

## Authority and safety

- Inspect only the exact candidate and safe symlink metadata needed to assess
  it. Do not list or inspect neighboring application-managed entries.
- Do not edit repository/runtime files, run installers, apply Stow, stage,
  commit, push, pull, fetch, or change branches.
- Never print or copy credentials, sessions, history, databases, logs, caches,
  generated private data, or application telemetry.
- Do not use broad recursive searches in application-managed directories.
- Never recommend tracking a whole host configuration directory.

## Canonical model

Portable custom user skills belong under `agents/.agents/skills/<name>`.
Tracked Claude compatibility links belong under
`agents/.claude/skills/<name>`, and the `agents` package requires
`stow --no-folding`. Approved vendored skills also require allowlist, lock,
registry, provenance, and licence review. Generated `framer-project-*` state,
plugins, and application-managed skills remain outside Git.

## Audit method

1. Confirm repository root, policy, Git state, and the candidate's exact path.
2. Require credible user-authored or fork provenance. Reject generated,
   private, host-specific, or application-owned material.
3. Read bounded text content only when repository policy permits it and the
   candidate is plausibly portable. Stop on unexpected sensitive content.
4. Verify `SKILL.md` frontmatter, support-file references, scripts, executable
   modes, requirements, outputs, writes, risk, licence, and dependencies.
5. Check the name against `agents/.agents/skills`, `skills.conf`,
   `SKILLS_REGISTRY.md`, and the generated Framer naming rule. Do not inspect
   host inventories for comparison.
6. Recommend either rejection or a later, separately authorized migration to
   the canonical root. State the registry/provenance/licence/link changes that
   migration would require.

## Validation

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
scripts/agent-skills status
scripts/agent-skills audit
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Do not run Node/npm/network commands. Confirm that no private content or secret
value appears in the report.

## Report and handoff

```yaml
operation: audit-portable-skill-candidate
repository:
  path:
  head:
candidate:
provenance:
portable:
collision:
requirements: []
outputs_and_writes: []
risk:
recommendation:
implementation_plan: []
validation:
  passed: []
  failed: []
sensitive_contents_printed: false
repository_changed: false
runtime_changed: false
staged: false
committed: false
pushed: false
unresolved_blockers: []
```
