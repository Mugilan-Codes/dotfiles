# Fictional workflow evaluations

Static walkthrough on 2026-11-26. The input examples are fictional. Each row
checks that the selected prompt or skill accepts the necessary context,
constrains the action and has an observable stop condition.

| Scenario and workflow | Example input | Static result |
| --- | --- | --- |
| TypeScript feature · [feature-implementation](../engineering.md#feature-implementation) | In `copper-catalog`, add optional `limit` at `GET /items`. Omitted gives the current result; 1–50 is allowed; 0 and 51 return 400. Keep sorting unchanged. Run `npm test -- items`. | Pass. The behavior, public entry point, boundary cases and focused command fit the prompt. Acceptance includes unchanged default behavior. |
| Production-like regression · [diagnosing-bugs](../../.agents/skills/diagnosing-bugs/SKILL.md) | In `orchid-queue` at `fixture-regression`, queue latency doubles only with 32 workers. Use sanitized traces and a local replay; diagnosis only. | Pass. The skill asks for a feedback loop, ranked hypotheses and targeted probes. The supplied mode limits work to diagnosis; the local replay supplies the evidence boundary. |
| Schema migration · [compatibility-migration](../engineering.md#compatibility-migration) | Rename `orders.state` to `status` in `paper-orders`. Old and new app versions coexist; retry a backfill of 100 fake orders; keep the old field until an approved cleanup. | Pass. Inputs describe mixed versions and data. Acceptance covers equality of old/new values, retry without duplicate effects and restoration after a partial run. |
| Read-only review · [verification-only](../engineering.md#verification-only) | Verify `pine-api` at `fixture-review`: a rejected input returns 422 with no write and retry stays idempotent. Use disposable database fixtures and the existing integration check. | Pass. Acceptance is itemized, fixture writes are isolated, and status/evidence can be reported without editing the implementation. |
| Resume · [resume-work](../learning.md#resume-work) | At `fixture-resume`, parser edits and unit results are in a handoff. Only CLI integration acceptance remains. The checkout also contains an unrelated docs edit. | Pass. Check revision and state, reuse valid unit evidence, preserve the docs edit, and stop after the remaining relevant proof. |
| Finance spreadsheet · [finance-review](../personal.md#finance-review) | In `Sample Ledger`, opening balance 800, income 500, groceries 65, subscription 15, refund 5 and a mirrored 200 internal transfer between included accounts. Use fictional currency units. | Pass. The contract asks for source-row reconciliation and separate transfers/refunds. Expected ending total is 1,225 and net expenses are 75, with the 15 subscription called out. |
| Technical handover · [technical-handover](../learning.md#technical-handover) | Hand over `willow-sync` retries to an on-call engineer using a runbook, retry policy and a sanitized incident note. First task is to verify a recovery from an isolated fixture. | Pass. The prompt names the audience, owning evidence, recovery commands, known signals and first verification step. |

These checks assess task fit and expected outputs. They did not execute the
fictional scenarios or compare output across Codex, Claude or other models.
