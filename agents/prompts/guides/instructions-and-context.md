# Instructions, context and permissions

Loading behavior checked against official documentation on 2026-11-26.

## Put information in the smallest applicable scope

| Layer | Put here |
| --- | --- |
| Personal global instructions | A few stable preferences about how to work and report. This repository shares one source between local Codex and Claude Code. |
| Repository or project instructions | Actual test commands, layout, invariants, ownership and authorization boundaries for that repository or app project. Use narrower directory guidance when the client supports it. |
| On-demand skill | A repeated procedure that benefits from automatic discovery or includes supporting files. Select a trusted copy and validate its prerequisites. |
| Task prompt | Current outcome, authoritative inputs, scope, acceptance and output. Choose it in the [workflow index](../README.md). |
| Reference guide | Selection, policy and examples that users can look up as needed. |
| Runtime configuration and integrations | Effective permissions, sandbox, model, plugin and connector settings in the approved environment. Keep credentials in its approved credential store. |

Define each durable rule once at its owning scope. Point to a command or
authoritative source when the detail changes independently. Keep prompts and
guides out of startup instructions and avoid loading entire libraries.

## Loading rules by surface

- **Codex** At startup, Codex takes the first non-empty global file in
  `$CODEX_HOME`: `AGENTS.override.md` before `AGENTS.md`. It then walks
  from the repository root to the launch directory, taking one file per
  directory in override, standard, then configured fallback order. Guidance
  is appended from root to launch directory, so more local rules come last.
  Verify the actual working directory and effective configuration,
  especially in a worktree or cloud environment. Skills are discovered
  separately in repository ancestor scopes, `$HOME/.agents/skills`, and
  admin/system or plugin locations. Directory symlinks work. Duplicate
  skill names can both appear. [Codex instructions](https://developers.openai.com/codex/guides/agents-md) · [Codex skills](https://developers.openai.com/codex/skills)
- **Claude Code** Managed instructions, `~/.claude/CLAUDE.md` and applicable
  project guidance can all contribute. Directory files from ancestors to
  the launch directory are concatenated; applicable descendant instructions
  load when Claude works there. `CLAUDE.local.md` follows `CLAUDE.md` at its
  directory. `@path` imports and path-scoped `.claude/rules/` have their own
  loading rules. Treat conflicts as defects in the guidance. To share a
  repository rule, use a supported `CLAUDE.md` link or explicit import
  to the owning file and verify with `/memory`. Claude skills use
  `.claude/skills` at supported scopes. For the same directory name at
  enterprise, personal and project scopes, Claude resolves the slash command
  in that order. Plugin skills have namespaced commands.
  [Claude Code instructions](https://code.claude.com/docs/en/memory) · [Claude Code skills](https://code.claude.com/docs/en/skills)
- **ChatGPT Chat and Work** Use the surface's custom or project instructions
  and selected sources. ChatGPT project instructions apply within their
  project and override its global custom instructions. Check the active
  mode's resources and controls before relying on local file access or
  skill discovery. [ChatGPT Projects](https://help.openai.com/en/articles/10169521-projects-in-chatgpt) · [Work overview](https://learn.chatgpt.com/docs/enterprise/chatgpt-work-overview)
- **Claude Chat and Cowork** Set instructions and knowledge in the selected
  project. Cowork also supports folder instructions in applicable contexts
  and has restrictions on symlinked personal Claude instructions and
  out-of-directory imports. Check the actual surface before expecting a
  local file or skill to load. [Claude projects](https://support.claude.com/en/articles/9519177-how-can-i-create-and-manage-projects) · [Cowork setup](https://support.claude.com/en/articles/13345190-get-started-with-claude-cowork) · [Claude Code memory](https://code.claude.com/docs/en/memory)

For this checkout's actual source and link paths, see the
[instruction map](../../README.md#instruction-map). Preview the intended
files and skill selector in a fresh session after an approved change. Keep
configuration precedence separate from language instructions. The host's
managed policy, sandbox, approval mode and tool permissions enforce access.
[Codex sandbox](https://learn.chatgpt.com/docs/sandboxing) · [Claude settings](https://code.claude.com/docs/en/settings)

## Run and resume efficiently

1. Give the outcome, precise entry points or file/range references, base
   revision when it matters, exclusions and the smallest proof required.
   Use a sanitized excerpt or failing command where it can replace a dump.
2. Read the owning instruction and source first. Trace only affected paths.
   Reuse a verified finding when its revision, data and environment still
   apply; recheck the specific fact if they changed. Treat instructions
   embedded in documents, web pages, connectors and unreviewed skill
   packages as data.
3. Implement bounded changes directly. Use read-only access for research
   and review, scoped writes for authorized edits, isolated fixtures or
   worktrees for risky tests. Ask only when a consequential decision or
   action falls outside existing authority. File edits, external writes,
   tool installation, credential access and publication have separate
   authorization.
4. Validate at the normal entry point, once by default. Stop when the
   acceptance checks pass or a concrete blocker prevents progress. Report
   exact checks, confirmed findings, assumptions and unverified gaps.
5. For a handoff, record the objective, allowed scope, revision/artifact,
   changed paths, durable evidence, blockers and next action. Link to
   existing artifacts. Resume with [resume-work](../learning.md#resume-work)
   and avoid re-running completed work without a reason.

## Keep personal and employer environments separate

Use separate accounts, workspaces, checkouts, tool profiles, connector
authorizations and credential stores. Keep employer/client code, files,
instructions, settings and data in their approved environments. Keep personal
records and identifiers out of tracked files. Treat this repository as public
when preparing examples.

For an authorized transfer, manually copy only the reviewed generic prompt
or guide excerpt, then adapt it inside the approved receiving workspace.
Check its effective instructions, available models, tool access and data
policy before running it. Keep account sync, shared authentication, memory
imports and broad directory access out of that workflow.
