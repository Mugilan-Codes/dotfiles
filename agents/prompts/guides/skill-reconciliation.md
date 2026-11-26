# Skill reconciliation and recovery

Observed 2026-11-26. The [manifest](../../skills-manifest.json) contains 27
managed skills (6 local, 3 forks, 18 vendors). The observed personal
`~/.agents/skills` tree exposed all 27 as matching directory links, alongside
15 [externally owned skills](../../external-skills.json), six unmanaged
directories and one generated Framer entry. The Claude Code tree had 26
matching links and one generated compatibility link. No managed name
appeared in the default `~/.codex/skills` directory. App/system/plugin
skills use their owning lifecycle. The [skills guide](../../SKILLS_GUIDE.md)
describes the reviewed repository inventory.

## Six unmanaged skills

Each was a real directory under `~/.agents/skills` with matching `SKILL.md`
frontmatter and an `agents/openai.yaml` containing interface labels and a
default prompt. No license, attribution, revision or maintenance owner was
visible in the package metadata. No same-name copy was present in the scoped
Claude or Codex-specific skills directories. The repository's existing
external inventory also lists them as unmanaged. These observations do not
establish provenance or grant redistribution rights.

| Skill | Recommended disposition | Rationale |
| --- | --- | --- |
| `investigate-first` | Replace with managed [diagnosing-bugs](../../.agents/skills/diagnosing-bugs/SKILL.md). | Ambiguous or intermittent failures already have a feedback-loop workflow. Give it the symptom, revision, reproduction and explicit permission to edit or investigate only. |
| `lean-build` | Consolidate into [feature-implementation](../engineering.md#feature-implementation). | The prompt scopes behavior and proof. Ponytail can add a simplicity lens in environments where its plugin is available. |
| `migration` | Replace with [compatibility-migration](../engineering.md#compatibility-migration). | Coexistence, data integrity and recovery need their own task contract beyond test-first behavior. |
| `safe-refactor` | Replace with [behavior-preserving-refactor](../engineering.md#behavior-preserving-refactor). | Baseline and parity checks apply to structural changes even when new tests are unnecessary. |
| `surgical-patch` | Replace with managed [bug-triage](../../.agents/skills/bug-triage/SKILL.md). | A reproducible failure already has focused root-cause and regression proof. |
| `verify-and-stop` | Replace with [verification-only](../engineering.md#verification-only). | The explicit acceptance checks and stop condition fit a copy-ready task. |

The new templates are original. No unmanaged package is imported or required.

## Managed overlaps worth keeping

- `bug-triage` covers routine reproducible failures; `diagnosing-bugs`
  establishes a feedback loop for ambiguous, flaky or slow behavior.
- `code-review` uses a fixed base, project standards and a spec. The portable
  `staged-diff-review` only reads the index; `staged-change-reviewer` is an
  interface-specific Codex alternative. Select one reviewer for the scope.
- `codebase-design` examines a module seam, `domain-modeling` owns domain
  terminology and ADRs, and `improve-codebase-architecture` surveys broader
  structural opportunities. The architecture prompt owns a bounded design.
- `tdd` owns the behavior-change loop and the regression prompt limits edits
  to tests. `research` saves a repository report; the evidence brief fits a
  conversation or decision artifact. `handoff` summarizes an agent session;
  the technical handover serves a person and the resume prompt consumes
  previously recorded evidence.
- `grilling` is a requirements interview; `grill-with-docs` also captures
  vocabulary and decisions. Framer and its code-component specialization
  have distinct entry points. Keep both pairs available.

## Applied changes and recovery

On 2026-11-26, the approved global instruction update reduced the shared file
from 116 words to 80. Both personal instruction links resolve to the
[canonical file](../../.codex/AGENTS.md). The repo root retains its
self-contained instructions.

Replacement coverage was reviewed before moving all six directories to a
private backup outside skill discovery. The backup contains the prior global
instruction file, an original-to-backup path manifest and a restore script.
Keep those records outside Git. To roll back, review the current instruction
source before restoring the saved copy. The restore script checks that all
original skill destinations are vacant before moving the directories back.
After an approved rollback, check live links and skill discovery in fresh
sessions.
