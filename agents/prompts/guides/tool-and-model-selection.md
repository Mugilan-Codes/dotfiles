# Tool and model selection

Official documentation checked 2026-11-26. Confirm availability in the active
workspace and client before relying on a model, connector or execution mode.

## Choose the workspace and tools

| Surface | Use it for | Context, permissions and proof |
| --- | --- | --- |
| ChatGPT Chat | Routine questions, small examples and drafting. Use deep research for a sourced investigation when offered. | Supply excerpts, files, project instructions or approved apps. Verify claims against sources and run any proposed code separately. [Getting started](https://learn.chatgpt.com/docs/quickstart) · [Deep research](https://help.openai.com/en/articles/10500283-deep-research-in-chatgpt) |
| ChatGPT Work | Multi-step research, multi-file documents and spreadsheets, or approved app operations. | Use selected files/apps and the offered cloud or local mode. Check connector write scope and device/workspace controls. Verify delivered files, formulas or remote changes. [Work overview](https://learn.chatgpt.com/docs/enterprise/chatgpt-work-overview) |
| Codex Desktop / CLI | Repository implementation, debugging and verification. Desktop suits diff review and parallel local work; CLI suits terminal-native builds and checks. | Give it the checkout/root and commands. Review the sandbox, approvals and resulting diff. [Getting started](https://learn.chatgpt.com/docs/quickstart) · [Sandbox](https://learn.chatgpt.com/docs/sandboxing) |
| Codex local / worktree | Use the current checkout when its state is needed. Use a Desktop worktree for independent writable changes or a clean review baseline. | A worktree isolates the checkout; account, credentials and external resources may still be shared. Confirm base/dirty state and run checks from the chosen checkout. [Local environments](https://learn.chatgpt.com/docs/environments/local-environment) · [Worktrees](https://learn.chatgpt.com/docs/environments/git-worktrees) |
| Codex Cloud | Delegate isolated coding work with a reproducible setup, where supported. | Select the authorized repository, branch and configured environment. Verify permitted network access, setup and dependencies; review the diff and cloud check logs before integration. [Cloud environments](https://learn.chatgpt.com/docs/environments/cloud-environments) |
| Claude Chat | Questions, reasoning and drafting with attachments, project knowledge or approved connectors. | Check project audience and visible tools. Review citations and validate code outside the conversation. [Claude projects](https://support.claude.com/en/articles/9519177-how-can-i-create-and-manage-projects) |
| Claude Code | Work directly with a repository, run shell checks and review changes. | Scope working directories and permission mode. Review effective settings and diff/test evidence. [Permissions](https://code.claude.com/docs/en/permissions) · [Settings](https://code.claude.com/docs/en/settings) |
| Claude Cowork | Multi-step file/app work, research synthesis and document generation. | Use approved folders/connectors and the appropriate confirmation mode. Local capabilities can require the Desktop app even with a cloud session. Verify resulting changes, citations and files. [Cowork setup](https://support.claude.com/en/articles/13345190-get-started-with-claude-cowork) · [Cowork surfaces](https://support.claude.com/en/articles/15520349-use-claude-cowork-on-web-desktop-and-mobile) |

A **skill** supplies a procedure and optional resources. An **app or MCP
server** supplies tools and data access. A **plugin** packages related
capabilities, potentially including skills and MCP configuration. Use the
smallest approved integration that covers the job. Check its owner, execution
location, account and read/write permissions before invoking it. Review
bundled hooks or executables before enabling a plugin. [OpenAI plugins](https://learn.chatgpt.com/docs/plugins) · [Claude Code MCP](https://code.claude.com/docs/en/mcp)

## Choose effort before model

| Effort | Start here |
| --- | --- |
| Low or fast | Routine questions, copy edits, narrow checks, a known small change or a frequent bounded automation. |
| Standard or medium | Default for implementation, focused bug fixes and document/spreadsheet work with clear inputs. Verify through the normal entry point or against source records. |
| High | Ambiguous debugging, architecture, a compatibility migration, deep research, or reconciliation with conflicting inputs. Add evidence before increasing effort. |
| Highest available | Escalate when an important uncertainty survives a targeted pass or a high-impact decision needs more analysis. Keep the scope and proof criteria explicit. |

For independent verification, give a fresh read-only conversation or agent the
revision, spec and acceptance checks. Use parallel agents only for material
independent work such as separate components, distinct source sets or distinct
review criteria. Provide a shared baseline, isolate concurrent writes and
assign one integrator; serial work usually fits a small or tightly coupled task.

## Current model guidance

- **ChatGPT Chat** Use a fast/Instant option for routine work, Medium for
  multi-step questions, and High or higher for demanding reasoning if offered.
  The current picker can route Latest to GPT-6.2, while older pickers can offer
  a different lineup. Choose within the visible picker. [ChatGPT models](https://help.openai.com/en/articles/20001354-gpt-6-and-other-models-in-chatgpt)
- **ChatGPT Work / Codex** Start with GPT-6.2 Sol when available. Try GPT-6.2
  Astra for complex work, GPT-6 Luna for simple recurring tasks, or GPT-6.1
  Terra for visual UI/chart work. Start routine implementations at standard
  effort where selectable. The [portable preferences](../../portable/README.md)
  snapshot records a personal high-effort setting; it loads only when merged.
  [OpenAI model selection](https://developers.openai.com/api/docs/guides/model-selection)
- **Claude Chat, Code or Cowork** Use Sonnet 5.5 for an everyday
  speed/capability balance if offered. Choose Opus 5.5 for complex coding
  or analysis and consider Haiku 5.5 where available for quick, bounded
  work. Check the product picker, or `/model` and `/effort` in Claude Code.
  [Claude Code models](https://code.claude.com/docs/en/model-config) · [Claude model guide](https://platform.claude.com/docs/en/about-claude/models/choosing-a-model)
- **API** OpenAI's task guidance starts most API workflows on GPT-6.2 Sol
  at medium; Anthropic's API guide starts most workloads on Opus 5.5.
  Verify exact model ID, supported tools and effort in the provider docs
  before setting an API default. API billing, usage controls and tool
  configuration are distinct from consumer app subscriptions.
  [OpenAI API models](https://developers.openai.com/api/docs/models) · [Claude API models](https://platform.claude.com/docs/en/models/overview)
- **Managed workspaces** Model access, tools, file access, usage controls
  and data policy depend on the workspace, plan, region and admin settings.
  Verify with the workspace owner before relying on a capability.
  [OpenAI Enterprise models](https://help.openai.com/en/articles/11165333-chatgpt-enterprise-and-edu-models-and-limits) · [Claude Code managed settings](https://code.claude.com/docs/en/settings)

Recheck the linked vendor page and active picker after a client, plan or
provider change. Update this section and its verification date when the
recommendation changes. Use a representative task and observed quality and
latency before changing a durable default.
