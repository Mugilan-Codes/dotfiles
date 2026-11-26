# Onboarding and learning

### trace-flow

Use to answer a targeted architecture, dependency, request or data-flow question, or to connect documentation to implementation. Codex or Claude Code · standard effort.

```text
Trace [QUESTION_OR_SCENARIO] from [ENTRY_POINT_OR_DOC] to [BOUNDARY] in [REPO_AND_REVISION]. Follow only the involved modules, dependencies, data stores and failure branches. Compare documented behavior with implementation and use paths/symbols as evidence.

Return a short ordered trace or dependency map, mismatches and what remains unverified at runtime. Keep the repository read-only and stop once the question is answered.
```

For first-pass orientation, use [repo-onboarding](../.agents/skills/repo-onboarding/SKILL.md).

### technical-handover

Use to transfer ownership to a person. ChatGPT Work, Claude Cowork or a coding agent with approved source access · standard effort.

```text
Prepare a handover for [RECEIVING_ROLE] taking over [COMPONENT_OR_TASK]. Use [APPROVED_DOCS_CODE_AND_STATUS]. Cover purpose, entry points, routine commands or runbook links, recent decisions, known failure signals and the next owned actions.

Cite owning files or documents. Mark assumptions and unresolved checks. Deliver a short handover the recipient can use to run or verify [FIRST_TASK] without repeating discovery. Omit real secrets and unrelated records.
```

Use [handoff](../.agents/skills/handoff/SKILL.md) to export the current agent session for another agent.

### resume-work

Use to continue interrupted work from a trusted handoff. Codex or Claude Code for a repository, Work or Cowork for other artifacts · standard effort.

```text
Resume [OBJECTIVE] using [HANDOFF], [EXPECTED_REVISION_OR_ARTIFACT_VERSION] and [REMAINING_ACCEPTANCE]. Confirm the current revision/state and preserve unrelated changes. Reuse recorded evidence that still applies; repeat only checks affected by drift or a new change.

Continue from [NEXT_STEP] within [AUTHORIZED_SCOPE]. Report new edits and validation, unresolved items and the next action. Stop when the remaining acceptance criteria pass or a concrete blocker prevents progress.
```
