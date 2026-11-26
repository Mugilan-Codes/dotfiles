# AI workflow index

Choose a row, then give the agent the task, authoritative inputs, permitted
actions and acceptance criteria. Pick the surface and effort in
[tool and model selection](guides/tool-and-model-selection.md). Use the
[instructions and context guide](guides/instructions-and-context.md) to scope
access, resume a task or adapt a workflow for another approved environment.

| Workflow | Start here |
| --- | --- |
| **Engineering** | |
| Feature implementation and integrations | [feature-implementation](engineering.md#feature-implementation) |
| Reproducible bug diagnosis and focused fix | [bug-triage](../.agents/skills/bug-triage/SKILL.md) |
| Ambiguous regression, flakiness or performance troubleshooting | [diagnosing-bugs](../.agents/skills/diagnosing-bugs/SKILL.md) |
| Measurable code optimization | [code-optimization](engineering.md#code-optimization) |
| Behavior-preserving refactoring | [behavior-preserving-refactor](engineering.md#behavior-preserving-refactor) |
| Branch or PR review against a base and spec | [code-review](../.agents/skills/code-review/SKILL.md) |
| Review staged Git changes | [staged-diff-review](../.agents/skills/staged-diff-review/SKILL.md) |
| Test-first implementation or bug fix | [tdd](../.agents/skills/tdd/SKILL.md) |
| Add coverage or a regression test without editing production code | [regression-tests](engineering.md#regression-tests) |
| Dependency, schema, data, API or configuration migration | [compatibility-migration](engineering.md#compatibility-migration) |
| Defensive security review | [defensive-security-review](engineering.md#defensive-security-review) |
| System, API or database design | [architecture-design](engineering.md#architecture-design) |
| Module interface or ownership design | [codebase-design](../.agents/skills/codebase-design/SKILL.md) |
| Docker, CI/CD or deployment failure | [delivery-troubleshooting](engineering.md#delivery-troubleshooting) |
| Git diff summary, commit text or PR draft | [git-preparation](engineering.md#git-preparation) |
| Read-only acceptance check and stop | [verification-only](engineering.md#verification-only) |
| **Onboarding and learning** | |
| First look at a repository | [repo-onboarding](../.agents/skills/repo-onboarding/SKILL.md) |
| Architecture/dependency mapping, request/data tracing or documentation-to-code mapping | [trace-flow](learning.md#trace-flow) |
| Learn a technology through applied exercises | [teach](../.agents/skills/teach/SKILL.md) |
| Transfer technical ownership to a person | [technical-handover](learning.md#technical-handover) |
| Export context for another agent session | [handoff](../.agents/skills/handoff/SKILL.md) |
| Resume from an implementation report | [resume-work](learning.md#resume-work) |
| **Research and productivity** | |
| Evidence brief or product/technology comparison | [evidence-brief](research.md#evidence-brief) |
| Technical documentation research saved to a repo | [research](../.agents/skills/research/SKILL.md) |
| Document analysis and reconciliation | [document-reconciliation](research.md#document-reconciliation) |
| Spreadsheet analysis and improvement | [spreadsheet-analysis](research.md#spreadsheet-analysis) |
| Google Drive organization, email/admin review or knowledge management | [organize-records](research.md#organize-records) |
| Scheduled-task specification | [scheduled-task-spec](research.md#scheduled-task-spec) |
| **Personal management** | |
| Financial audit, monthly/annual budget, expenses or subscriptions | [finance-review](personal.md#finance-review) |
| Workout log, fitness progress, nutrition data or meals | [fitness-nutrition-review](personal.md#fitness-nutrition-review) |
| Car trip, fuel, FASTag or commute analysis | [travel-cost-review](personal.md#travel-cost-review) |
| Annual planning or digital organization reset | [annual-planning](personal.md#annual-planning) |

## Use or maintain a workflow

- **Terminal** Run `rg -n 'schema|migration' agents/prompts/README.md` from
  the dotfiles root and open the linked section. To browse files interactively
  when fzf is already available, run `rg --files agents/prompts | fzf`.
- **Editor or chat** In Codex or Claude Code with this checkout in scope,
  say “Use `agents/prompts/engineering.md#compatibility-migration` with
  these inputs …” and supply the inputs. If Chat or Work lacks repository
  access, open the template in your editor and paste its fenced text into
  the conversation. Fill the named placeholders, drop irrelevant clauses,
  and paste or attach only the relevant excerpts, files and check results.
- **Managed skills** Select the named skill in Codex or type `$bug-triage`.
  In Claude Code type `/bug-triage` or `/handoff`. Include the authorized
  mode, changed behavior or expected evidence. See the
  [skill inventory](../SKILLS_GUIDE.md) for capabilities and prerequisites.
- **Maintenance** Reuse a suitable row first. Add a short kebab-case heading
  with a stable ID, tool/effort, one fenced prompt containing its inputs and
  acceptance, and an index row. Update links when moving a section. Keep model
  names in the model guide, keep private notes out of Git, and run
  `python3 -B tests/test_regressions.py WorkflowTests`.
- **Examples** Read the [seven fictional evaluations](guides/examples.md).
  The [skill reconciliation](guides/skill-reconciliation.md) records the
  inventory decisions, live changes and recovery steps.
