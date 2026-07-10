# Skills operating guide

This guide answers which tracked skill to use. The exact ownership, source,
hash, and licence records remain in [SKILLS_REGISTRY.md](SKILLS_REGISTRY.md)
and [THIRD_PARTY.md](THIRD_PARTY.md).

Invocation is **model** unless the skill sets `disable-model-invocation: true`.
User-invoked skills must be named explicitly. All skills are available to
Codex through `$HOME/.agents/skills`; all except `staged-change-reviewer` have
a tracked Claude compatibility link.

## Inventory and selection

| Skill | Type / invocation | Invoke when | Avoid when | Requirements and current state | Outputs, writes, risk | Update source |
| --- | --- | --- | --- | --- | --- | --- |
| `bug-triage` | Local; model; frequent; light | A normal reproducible bug needs diagnosis and a focused fix | The failure is hard, flaky, or performance-related | Project test/run command: PROJECT-SPECIFIC | May edit code/tests; medium | Local edit |
| `code-review` | Matt; model; occasional; heavy | Review a branch since an explicit fixed point against both standards and a spec | Only staged changes need review, or no fixed point exists | Git: SATISFIED; parallel sub-agents: SATISFIED in Codex, host-dependent elsewhere; tracker doc/spec: PROJECT-SPECIFIC | Report only by default; low | Matt installer allowlist |
| `codebase-design` | Matt; model; occasional; moderate | Design a deep module, interface, seam, or testable architecture | A tiny local edit has no design choice | Optional parallel agents for “design it twice”; project code: PROJECT-SPECIFIC | Advice/design; may guide code; medium | Matt installer allowlist |
| `diagnosing-bugs` | Matt; model; frequent for hard bugs; heavy | A bug is difficult, flaky, slow, or lacks a tight feedback loop | A simple known fix needs only focused triage | Test/CLI/browser harness: PROJECT-SPECIFIC; Playwright/browser: OPTIONAL; `CONTEXT.md`/ADRs: OPTIONAL | May create harnesses and edit code/tests; medium | Matt installer allowlist |
| `domain-modeling` | Matt; model; occasional; moderate | Resolve domain language or record a durable architectural decision | The task has no domain ambiguity or durable decision | Writable repo: PROJECT-SPECIFIC; `CONTEXT.md` and `docs/adr/` are created lazily | Writes glossary/ADRs; medium | Matt installer allowlist |
| `dsa-solution-review` | Local; model; frequent for practice; light | Review correctness, complexity, edge cases, and alternatives for a DSA solution | The request is ordinary application code review | Problem statement and solution: PROJECT-SPECIFIC | Review/explanation; no commit; low | Local edit |
| `framer` | Local fork; model; occasional; heavy | The request explicitly concerns a Framer project | Generic websites or UI work outside Framer | Node/npx: SATISFIED; network/account/permission: PROJECT-SPECIFIC; generated `framer-project-*`: created by setup/session | Can mutate/publish Framer only with authority; high | Manual fork review |
| `framer-code-components` | Local fork; model; occasional; heavy | Build or fix a Framer React code component | Ordinary React component work | `framer`, Framer session/project skill, Node/network: PROJECT-SPECIFIC | Writes remote/local component state; high | Manual fork review |
| `grill-with-docs` | Matt; user; occasional; heavy | Interactively clarify a design while capturing glossary/ADRs | A short question has no ambiguity to resolve | `grilling` and `domain-modeling`: SATISFIED; writable project docs: PROJECT-SPECIFIC | May write `CONTEXT.md`/ADRs; medium | Matt installer allowlist |
| `grilling` | Matt; model; occasional; moderate | Requirements need a rigorous question-by-question interview | The conversation already contains enough detail | User availability: PROJECT-SPECIFIC | Conversation output; low | Matt installer allowlist |
| `handoff` | Matt; user; occasional; light | Prepare a compact continuation handoff for a fresh task/agent | Work is complete or the same context is healthy | None | Handoff text/file if requested; no implicit commit; low | Matt installer allowlist |
| `here-now` | Other vendor; model; rare; heavy | Publish a site/file or use private here.now Drive storage | Local-only work or no publication authority | `curl`, `file`, `jq`: SATISFIED; network: REQUIRED AT USE; API/Drive tokens: OPTIONAL/PARTIAL (not set) | Writes `.herenow/state.json`, may store credentials and publish; high | `heredotnow/skill` installer selection |
| `improve-codebase-architecture` | Matt; user; rare; heavy | Produce an evidence-backed architecture improvement report | A small refactor or isolated design question | `codebase-design`, `domain-modeling`, `grilling`: SATISFIED; browser for HTML preview: OPTIONAL | May produce HTML/report and proposals; medium | Matt installer allowlist |
| `loopy` | Local fork; model; rare; heavy | Craft, audit, run, improve, or prepare publication of a reusable agent loop | A one-shot task needs no repeatable loop | Network/catalog: OPTIONAL; scheduling/publishing authority: PROJECT-SPECIFIC | May draft files; external publish only with authority; high | Manual fork review |
| `prototype` | Matt; model; occasional; moderate | A cheap throwaway experiment will answer a technical uncertainty | The implementation path is already known | Project toolchain: PROJECT-SPECIFIC | Temporary prototype files; must not silently become production; medium | Matt installer allowlist |
| `repo-onboarding` | Local; model; frequent in unfamiliar repos; light | Quickly map structure, commands, conventions, risks, and entry points | The repository is already understood | Git/read access: SATISFIED; repo docs: PROJECT-SPECIFIC | Read-only report; low | Local edit |
| `research` | Matt; model; occasional; heavy | Primary-source technical research or a question needing parallel investigation | Stable facts already available locally | Network: REQUIRED AT USE; background agents: SATISFIED in Codex, host-dependent elsewhere | Research report/citations; low | Matt installer allowlist |
| `setup-matt-pocock-skills` | Matt; user; setup-only; moderate | Enable tracker/spec/ticket/domain conventions in an application repo | Dotfiles installation alone, or a repo not using these flows | Writable application repo; `gh` SATISFIED, `glab` MISSING/OPTIONAL, local tracker available | Creates `docs/agents/*`; may update `AGENTS.md`/`CLAUDE.md`; medium | Matt installer allowlist |
| `skills-maintainer` | Local; model; maintenance-only; heavy | Audit or maintain this repository’s tracked skills and links | Ordinary application development | `scripts/agent-skills`, Git, Stow: SATISFIED; installer/network only for separately authorized updates | May edit tracked skill metadata/docs; no implicit install/commit; high | Local edit |
| `staged-change-reviewer` | Local; model; occasional; moderate | Codex should review the index with its OpenAI review interface | Claude review or unstaged/branch comparison | Git: SATISFIED; Codex metadata: SATISFIED | Read-only findings; low | Local edit; Codex-only |
| `staged-diff-review` | Local; model; frequent before commit; light | Review exactly `git diff --cached` in either Codex or Claude | Branch/spec review needs `code-review` | Git and staged diff: SATISFIED | Read-only findings; low | Local edit |
| `tdd` | Matt; model; frequent for behavior changes; moderate | Build in red-green tracer-bullet slices at agreed seams | Spikes, docs-only work, or trivial changes | Project test command: PROJECT-SPECIFIC; optional `CONTEXT.md`/ADRs | Writes tests/code; no implicit commit; medium | Matt installer allowlist |
| `teach` | Matt; user; occasional; heavy | Build a structured learning mission for Java/Spring, system design, Flutter, or another subject | A single factual answer is enough | Writable learning directory and optional network/community research: PROJECT-SPECIFIC | Creates mission, lessons, glossary, notes; medium | Matt installer allowlist |
| `to-spec` | Matt; user; occasional; heavy | Synthesize an already-discussed feature into a tracker-ready spec | More interviewing is still needed or the task is small | `docs/agents/issue-tracker.md`, labels/domain docs: PROJECT-SPECIFIC; tracker credentials/network for remote publish | Publishes issue/spec; external write; high | Matt installer allowlist |
| `to-tickets` | Matt; user; occasional; heavy | Split an approved plan/spec into dependency-aware vertical slices | A normal Codex plan is enough | Tracker setup: PROJECT-SPECIFIC; `gh` SATISFIED, `glab` optional/missing, local `tickets.md` supported | Writes tickets or creates issues; external write; high | Matt installer plus documented local adaptation |
| `writing-great-skills` | Matt; user; occasional; moderate | Design or refactor a skill’s invocation and instructions | Routine registry/link maintenance | None | Advice or skill edits; medium | Matt installer allowlist |

No skill grants install, commit, push, publish, issue-creation, or remote-write
authority by itself. Those remain separate user permissions.

## Fast decision guide

- New repository: `repo-onboarding`.
- Straightforward failure: `bug-triage`; hard/flaky/performance failure:
  `diagnosing-bugs`.
- DSA practice: `dsa-solution-review`.
- Test-first behavior change: `tdd`; uncertain feasibility first: `prototype`.
- One module/interface decision: `codebase-design`; sustained vocabulary and
  decision capture: `domain-modeling`; both plus questioning:
  `grill-with-docs`.
- Staged pre-commit review: `staged-diff-review` (or Codex-only
  `staged-change-reviewer`); branch/spec review: `code-review`.
- Small task planning: normal Codex plan; durable product spec: `to-spec`;
  multi-task tracker publication: `to-tickets`.
- Custom skill design: `writing-great-skills`; this repository’s lifecycle:
  `skills-maintainer`.
- Generic freelance site: ordinary web workflow; Framer project: `framer`;
  authorized quick hosting: `here-now`.
- Long-running work nearing a context boundary: `handoff`; repeatable agent
  procedure: `loopy`.

## Project setup boundary

Run `setup-matt-pocock-skills` separately inside each application repository
only when its spec/ticket workflow is wanted. It may create
`docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`, and
`docs/agents/domain.md`, and add pointers to existing agent instructions.
`CONTEXT.md` and `docs/adr/` are optional and created lazily by domain work.
