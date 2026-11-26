# Engineering

### feature-implementation

Use for a bounded behavior change or integration. Codex or Claude Code · standard effort.

```text
Implement [BEHAVIOR] through [ENTRY_POINT] in [REPO]. Use [SPEC_OR_FILES] and local repository instructions. Acceptance: [OBSERVABLE_CASES]. Exclude [NON_GOALS].

Trace the owning code and its callers, reuse repository patterns, and preserve existing behavior outside scope. Make reversible decisions directly. Pause only for a consequential choice outside the requested scope. Run [FOCUSED_CHECKS] through the normal entry point. Stop when the cases pass. Report files, test results and any remaining gap.
```

Use [tdd](../.agents/skills/tdd/SKILL.md) when the change warrants a test-first loop.

### code-optimization

Use when a suspected cost already has a comparison workload. Codex or Claude Code · standard to high effort.

```text
Improve [METRIC] for [WORKLOAD] at [ENTRY_POINT] while preserving [INVARIANTS]. Use [BENCHMARK_OR_TRACE], [FIXTURE] and [TARGET_OR_BUDGET].

Measure the baseline before editing. Identify the dominant cost and make the smallest change that addresses it. Compare before and after under the same conditions; run correctness checks and report trade-offs. Stop when the target and correctness checks pass, or report why the evidence does not support a change.
```

For an unexplained slowdown, start with [diagnosing-bugs](../.agents/skills/diagnosing-bugs/SKILL.md).

### behavior-preserving-refactor

Use for structural changes to known behavior. Codex or Claude Code · standard effort.

```text
Refactor [SCOPE] to [STRUCTURAL_GOAL]. Preserve [PUBLIC_CONTRACTS], callers, failure behavior and compatibility. Use [BASELINE_CHECKS] to identify what the current implementation guarantees.

Record the baseline, add a focused characterization test only for a material uncovered invariant, then make the structural change at the owning layer. Rerun the same checks and inspect the diff for behavior drift. Stop when structure and parity are proven. Report changed paths, proof and any baseline gap.
```

### regression-tests

Use when existing behavior needs coverage or a bug needs a test-only reproduction. Codex or Claude Code · standard effort.

```text
Add tests for [CONTRACT_OR_REGRESSION] at [PUBLIC_SEAM] using [FIXTURE_AND_EXPECTED_RESULTS]. Change only [TEST_SCOPE]. Follow the existing runner and conventions and keep fixtures deterministic.

Prove the new assertions detect the target failure, using [KNOWN_BAD_CASE_OR_REVISION] if available. Run [FOCUSED_COMMAND], report failure and pass evidence where applicable, and stop. If production behavior remains broken, report it separately from the test change.
```

### compatibility-migration

Use for schema, data, API, dependency or configuration transitions. Codex or Claude Code · high effort.

```text
Migrate [CURRENT] to [TARGET] in [APPROVED_SCOPE]. Inputs: [CALLERS_AND_VERSIONS], [DATA_INVARIANTS], [AVAILABILITY_REQUIREMENTS], [TEST_TARGET] and [ROLLBACK_REQUIREMENTS]. Use [MODE: DESIGN_ONLY_OR_IMPLEMENT_IN_TEST].

Map old/new compatibility during rollout. Design an expand, backfill, verify and contract sequence where needed. Make retries safe and define integrity checks, stop thresholds and recovery before each irreversible step. Use a representative fixture to prove old/new compatibility, safe retry, data preservation and rollback or restore. Keep destructive cleanup and live rollout outside this task. Deliver the ordered transition, checks and results, plus any step needing approval.
```

### architecture-design

Use for a system, API or database design with real trade-offs. Chat for conceptual work, Codex or Claude Code for repository-grounded design · high effort.

```text
Design [SYSTEM_OR_INTERFACE] for [USE_CASES] under [SCALE], [INVARIANTS], [FAILURE_BUDGET] and [CONSTRAINTS]. Ground the design in [EXISTING_CONTRACTS_OR_DOCS].

Trace one normal and one failure path. Describe ownership and interfaces, data and consistency, authorization, failure recovery and observability where applicable. For an API or database include concrete contracts, schema/query paths and compatibility. Compare the smallest viable design with one credible alternative and give the decision, trade-offs and proof plan. Keep implementation out of scope.
```

For a module boundary or vocabulary decision, see [codebase-design](../.agents/skills/codebase-design/SKILL.md) and [domain-modeling](../.agents/skills/domain-modeling/SKILL.md).

### defensive-security-review

Use for a read-only defensive review of code or design you are authorized to inspect. Codex or Claude Code · high effort.

```text
Review [AUTHORIZED_SCOPE] against [ASSETS_TRUST_BOUNDARIES_AND_REQUIREMENTS] using [DIFF_OR_DESIGN] and sanitized evidence. Keep inspection read-only and limit checks to approved local defensive validation.

Trace authentication, authorization, untrusted inputs, secret handling and data exposure where relevant. Return prioritized findings with file/line or design evidence, impact, mitigation and a safe check for the fix. Mark unverified risks and coverage gaps. Keep exploit development, live probing and credential access outside scope.
```

### delivery-troubleshooting

Use for Docker, CI/CD or deployment failures when the failing stage matters. Codex or Claude Code · standard to high effort.

```text
Investigate [FAILED_STAGE] for [REVISION_AND_ENVIRONMENT] using [SANITIZED_LOG], [CONFIG_PATHS] and [LAST_KNOWN_GOOD]. Mode: [DIAGNOSE_ONLY_OR_FIX_REPO].

Locate the first causal failure and compare environment, inputs and versions with the working run. Use a local or isolated check to test the smallest plausible fix. Leave hosted state, live services and infrastructure unchanged. Report the cause, patch or proposed action, exact validation and what still requires a hosted rerun.
```

### git-preparation

Use to prepare a commit or PR from existing changes. Codex or Claude Code · low to standard effort.

```text
Prepare [DIFF_SUMMARY_COMMIT_MESSAGE_OR_PR_DRAFT] from [STAGED_UNSTAGED_OR_BASE_REF] against [INTENT_OR_SPEC]. Include [VERIFIED_CHECKS] and preserve unrelated work.

Read exactly the requested diff and identify conflicts with the intended scope or missing evidence. Draft the requested text with accurate scope and validation. Keep the repository and hosting service read-only. Return the draft and any blocker to using it.
```

For findings-first review, choose the relevant reviewer in the [workflow index](README.md).

### verification-only

Use to check existing work against explicit acceptance criteria. Codex or Claude Code · low to standard effort.

```text
Verify [SUBJECT_AND_REVISION] against [ACCEPTANCE_CRITERIA] in [AUTHORIZED_TARGET]. Use [CHECKS_OR_EVIDENCE]. Keep tracked files and external state unchanged. Use disposable fixtures for checks that write.

Run the smallest relevant set once. Stop when each criterion has evidence, or when a failure or blocker makes the verdict clear. Return pass, fail or blocked per criterion with evidence and a single next action for any gap.
```
