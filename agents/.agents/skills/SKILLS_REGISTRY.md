# Codex Skills Registry

Last reviewed: 2026-07-06

Audit scope: `$HOME/.agents/skills`. The 2026-07-06 audit found 18 tracked reusable skill folders with valid `SKILL.md` frontmatter. Generated `framer-project-*` folders are local-only and intentionally excluded from this public registry.

| Skill | Path | Purpose | Status | Important Files | Known Issues |
| --- | --- | --- | --- | --- | --- |
| `tdd` | `$HOME/.agents/skills/tdd` | Test-first implementation using behavior-focused red-green cycles at user-approved seams. | keep | `SKILL.md`, `tests.md`, `mocking.md` | Requires agreement on the seams under test before writing tests; three older support files remain installed but are no longer referenced by `SKILL.md`. |
| `teach` | `$HOME/.agents/skills/teach` | Stateful teaching workspace with missions, cited HTML lessons, reusable assets, references, and learning records. | optional | `SKILL.md`, `MISSION-FORMAT.md`, `RESOURCES-FORMAT.md`, `LEARNING-RECORD-FORMAT.md` | Best for intentional learning sessions; overkill for one-off explanations. |
| `grill-with-docs` | `$HOME/.agents/skills/grill-with-docs` | Run a focused plan or design interview while maintaining domain terminology and ADRs. | fix | `SKILL.md` | Directly invokes `/grilling`, which is not installed; legacy local domain templates remain but are no longer referenced. |
| `improve-codebase-architecture` | `$HOME/.agents/skills/improve-codebase-architecture` | Scan for deepening opportunities, present a visual HTML report, and interview the user about a selected candidate. | fix | `SKILL.md`, `HTML-REPORT.md` | Directly invokes missing `/grilling`; `/codebase-design` and `/domain-modeling` are installed, but several older local design references are no longer used. |
| `bug-triage` | `$HOME/.agents/skills/bug-triage` | Reproduce, isolate, fix, and verify bugs with focused changes. | keep | `SKILL.md` | New skill; no field history yet. |
| `code-review` | `$HOME/.agents/skills/code-review` | Review a branch or commit range independently against repository standards and an originating spec. | keep | `SKILL.md` | Requires a resolvable fixed point; the Spec axis cannot run without a discoverable or user-supplied spec. |
| `codebase-design` | `$HOME/.agents/skills/codebase-design` | Supply deep-module vocabulary, dependency strategies, seam discipline, and design-it-twice interface exploration. | keep | `SKILL.md`, `DEEPENING.md`, `DESIGN-IT-TWICE.md` | Terminology-heavy reference intended for focused design work rather than broad repository review. |
| `domain-modeling` | `$HOME/.agents/skills/domain-modeling` | Maintain domain terminology and record durable architectural decisions as they are resolved. | keep | `SKILL.md`, `CONTEXT-FORMAT.md`, `ADR-FORMAT.md` | Writes domain documentation inline; should not be invoked merely to read existing vocabulary. |
| `handoff` | `$HOME/.agents/skills/handoff` | Produce a compact, redacted conversation handoff in the OS temporary directory. | optional | `SKILL.md` | Explicit-only command; references existing artifacts instead of embedding them, so the handoff is not standalone without repository access. |
| `setup-matt-pocock-skills` | `$HOME/.agents/skills/setup-matt-pocock-skills` | Configure repository issue-tracker, triage-label, and domain-document conventions for engineering workflow skills. | fix | `SKILL.md`, `issue-tracker-github.md`, `issue-tracker-gitlab.md`, `issue-tracker-local.md`, `triage-labels.md`, `domain.md` | References uninstalled skills: `to-issues`, `triage`, `to-prd`, `qa`, `diagnosing-bugs`, and `wayfinder`. |
| `staged-diff-review` | `$HOME/.agents/skills/staged-diff-review` | Review only staged Git changes before commit. | keep | `SKILL.md` | New skill; overlaps with built-in staged-change review behavior but uses your local wording. |
| `repo-onboarding` | `$HOME/.agents/skills/repo-onboarding` | Quickly orient Codex and the user to repo structure, commands, architecture, and risks. | keep | `SKILL.md` | New skill; should stay read-only unless user asks for changes. |
| `dsa-solution-review` | `$HOME/.agents/skills/dsa-solution-review` | Review DSA solutions with brute, better, optimal progression and Java-first final code. | keep | `SKILL.md` | New skill; assumes algorithm interview context. |
| `framer` | `$HOME/.agents/skills/framer` | Orchestrate explicitly requested Framer project setup, sessions, canvas and CMS edits, code components, assets, localization, and publishing. | optional | `SKILL.md` | Requires networked CLI setup and a generated local project-scoped skill; generic website requests no longer trigger it. |
| `framer-code-components` | `$HOME/.agents/skills/framer-code-components` | Provide Framer code-component constraints, property-control references, patterns, and examples. | optional | `SKILL.md` | Supporting skill only and intentionally large; direct invocation bypasses the required base and project-scoped Framer workflow. |
| `here-now` | `$HOME/.agents/skills/here-now` | Publish files and static sites with here.now or store and share private files through here.now Drives. | optional | `SKILL.md`, `scripts/publish.sh`, `scripts/drive.sh` | Requires network access and `curl`, `file`, and `jq`; anonymous sites expire after 24 hours, while permanent sites and private Drives require credentials. |
| `loopy` | `$HOME/.agents/skills/loopy` | Discover, find, audit, craft, run, debrief, save, adapt, and publish bounded AI-agent loops. | keep | `SKILL.md`, `agents/openai.yaml`, `references/discover.md`, `references/audit.md`, `references/run.md`, `references/debrief.md`, `references/publish.md` | Broad workflow surface requires careful request routing; live Loop Library lookup depends on network access. |
| `skills-maintainer` | `$HOME/.agents/skills/skills-maintainer` | Audit and maintain the local skills folder, guide, and registry. | keep | `SKILL.md` | New skill; recommend a fresh Codex session after frontmatter changes so discovery metadata refreshes. |

## Audit Findings

- Tracked reusable skill folders: `bug-triage`, `code-review`, `codebase-design`, `domain-modeling`, `dsa-solution-review`, `framer`, `framer-code-components`, `grill-with-docs`, `handoff`, `here-now`, `improve-codebase-architecture`, `loopy`, `repo-onboarding`, `setup-matt-pocock-skills`, `skills-maintainer`, `staged-diff-review`, `tdd`, `teach`.
- Newly documented reusable skills: `code-review`, `codebase-design`, `domain-modeling`, `handoff`, `setup-matt-pocock-skills`.
- Materially changed skills reconciled: `grill-with-docs`, `improve-codebase-architecture`, `tdd`, `teach`.
- Generated `framer-project-*` folders remain local, untracked, and excluded from Git.
- Ignored local junk: `$HOME/.agents/skills/.DS_Store`; two additional ignored `.DS_Store` files under the `agents` package currently make the Stow simulation conflict.
- Frontmatter check: all 18 tracked reusable skills and the generated Framer project skill have non-empty `name` and `description` fields matching their folder names.
- Missing `SKILL.md` files: none.
- Relative Markdown references checked: 33 across 52 Markdown files.
- Broken relative references: none.
- Unresolved cross-skill references: `/grilling`; `to-issues`, `triage`, `to-prd`, `qa`, `diagnosing-bugs`, and `wayfinder`.
- Status summary: 10 `keep`, 5 `optional`, 3 `fix`, 0 `remove`.

## Status Meanings

- `keep`: useful and ready to use.
- `fix`: installed and useful but has known breakage that should be repaired soon.
- `optional`: useful only for specific workflows.
- `remove`: not recommended to keep installed.
