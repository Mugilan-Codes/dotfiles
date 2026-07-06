# Codex Usage

Practical prompt patterns for working with this repository.

## Instruction Discovery

Codex discovers `AGENTS.md` instructions from the repository hierarchy.
This repository keeps canonical policy in the root `AGENTS.md`; `CLAUDE.md`
is a relative symlink to it so Codex and Claude Code receive the same rules.
If a nested `AGENTS.md` is added later, its narrower instructions apply within
that subtree.

Codex reads user-managed skills from `$HOME/.agents/skills`. This repository
does not duplicate those skills under `$HOME/.codex/skills`; existing Codex
system/plugin skills there are independently managed.

## Start With Scope and Authority

Audit-only prompt:

```text
Audit this dotfiles repository. Inspect the current Git and runtime state,
report findings and risks, and do not modify files, links, packages, or
external systems.
```

Implementation prompt:

```text
Implement this scoped change. Preserve all pre-existing unrelated changes,
edit only the required files, and run relevant validation. You may edit the
repository, but do not install, Stow, stage, commit, push, or deploy unless I
authorize those actions separately.
```

State authority explicitly when needed:

```text
You may edit tracked files and run the real skill installer. Do not stage,
commit, push, apply Stow, or publish externally.
```

Editing, installing, applying Stow, staging, committing, pushing, and
deploying are separate permissions.

## Common Prompts

Repository onboarding:

```text
Use repo-onboarding to explain this repo's structure, Stow packages, agent
skill ownership, verification commands, current Git state, and maintenance
risks before changing anything.
```

Staged review:

```text
Use staged-diff-review to review only my staged changes. Do not modify,
unstage, commit, or push anything.
```

Audit agent skills:

```text
Use skills-maintainer and scripts/agent-skills plan/status to audit local,
third-party, and generated skills. Do not install or update anything.
```

Implement a local skill:

```text
Add this dotfiles-owned skill under agents/skills, update skills.conf and the
agent documentation, then run the authorized install and validation workflow.
Do not stage or commit.
```

Update third-party skills:

```text
Run scripts/agent-skills plan first. If healthy, run its explicit update
workflow for only the configured allowlist, report changed skills, and do not
change the pinned CLI version.
```

Modify a Stow package:

```text
Update the requested zsh/tmux/git/starship configuration. Inspect targets,
keep the change scoped, and run Stow simulation. Do not apply real Stow,
stage, or commit.
```

## Agent Skill Workflow

Desired third-party state is in `agents/skills.conf`; local source is under
`agents/skills`; generated Framer skills remain runtime-only.

```sh
scripts/agent-skills plan
scripts/agent-skills install
scripts/agent-skills status
scripts/agent-skills update
scripts/agent-skills unlink-local
```

Use `plan` and `status` for audits. `install`, `update`, and `unlink-local`
mutate runtime state and need explicit authority. Detailed ownership,
configuration, troubleshooting, and lifecycle guidance is in
`agents/README.md`.

## Good Defaults

- Ask Codex to inspect branch, HEAD, status, targets, and symlinks first.
- Preserve pre-existing changes and keep edits scoped.
- Ask for a short plan on non-trivial work.
- Require concise, copy-pasteable commands.
- Request changed files, runtime changes, validation results, and final Git
  status.
- Prefer `$HOME` and repository-root-relative paths in reusable docs.
