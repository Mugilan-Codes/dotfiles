# Research and productivity

### evidence-brief

Use for a question or comparison with a decision and an audience. Chat or Claude Chat for a few sources, deep research or Work/Cowork for multi-source synthesis · standard to high effort.

```text
Answer [QUESTION_OR_DECISION] for [AUDIENCE] as of [DATE]. Compare [OPTIONS] by [CRITERIA] within [SCOPE]; use [REQUIRED_SOURCES_OR_VERSIONS]. Prefer primary sources and link evidence next to the claims it supports.

Explain material disagreements and gaps, then give a recommendation only if requested. Deliver a concise brief or comparison table with confidence and the fact that would change the decision.
```

For technical documentation research saved to a repository, use [research](../.agents/skills/research/SKILL.md).

### document-reconciliation

Use when documents disagree or an approved draft needs corrections. Work or Cowork · standard to high effort.

```text
Compare [DOCUMENTS_AND_VERSIONS] for [QUESTION_OR_FIELDS]. Treat [AUTHORITY_ORDER] as the source of truth. Cite exact locations for conflicting claims, gaps and proposed corrections. Preserve the author's wording outside approved edits.

Deliver a discrepancy table with disposition, evidence and any owner decision. Return a draft by default; edit only [APPROVED_DRAFT] if specified. Verify the final draft against the owning sources.
```

### spreadsheet-analysis

Use to audit or improve a workbook or connected sheet. Work or Cowork with spreadsheet tooling · standard to high effort.

```text
Analyze [WORKBOOK_OR_SHEET] in [TABS_AND_RANGES] for [QUESTION] using [EXPECTED_TOTALS_UNITS_AND_CALCULATION_RULES]. Check column types, missing values, duplicates and formula/range references relevant to the result. Reconcile key totals back to source rows.

Return findings with cell/range evidence, calculations and assumptions. If asked to edit, change only [APPROVED_COPY_OR_RANGES] and verify totals, formulas and representative rows after editing.
```

### organize-records

Use for Drive folders, mailbox/admin queues or a knowledge base. Work or Cowork with a scoped connector · standard effort.

```text
Review [ACCOUNT_SCOPE_AND_FOLDER_QUERY_OR_COLLECTION] for [GOAL] over [DATE_RANGE]. Use [CLASSIFICATION_AND_RETENTION_RULES] and cite record IDs or locations. Flag action deadlines, uncertain duplicates, ownership and sharing impacts where relevant.

Return a proposed organization or admin action list with counts and the next decisions. Keep files, messages, labels and sharing read-only unless [EXPLICITLY_APPROVED_ACTIONS] grants a precise change. Verify any approved changes with a targeted reread.
```

### scheduled-task-spec

Use to draft a recurring task contract. Work or Cowork with scheduling available · low to standard effort.

```text
Draft a recurring task for [PURPOSE] with [CADENCE_TIME_ZONE_AND_START] and [PERMITTED_SOURCES]. Specify the read/write scope, trigger or change threshold, report fields, recipient or destination, and behavior when input is missing or unchanged. Include a sample run using [FICTIONAL_INPUT].

Return the exact schedule and copy-ready automation prompt. Keep activation and external delivery outside scope unless separately authorized. Make repeated runs safe and avoid duplicate alerts.
```

For portable agent loops with a reusable trigger and proof, see [loopy](../.agents/skills/loopy/SKILL.md).
