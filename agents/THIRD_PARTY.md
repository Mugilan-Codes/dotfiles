# Third-party skills and attribution

Audited: 2026-07-10

Approved third-party skill contents are vendored under
`agents/.agents/skills`. Future installer results must remain project-scoped,
produce a visible Git diff, and record the resolved `skills@latest` version
in the maintenance report.

Resolved installer version: `1.5.15`

## `mattpocock/skills`

- Source: <https://github.com/mattpocock/skills>
- License: MIT
- License copy: `licenses/mattpocock-skills-LICENSE.txt`
- Copyright notice: Copyright (c) 2026 Matt Pocock
- Ownership here: exact reviewed vendored copies
- Update: project-scoped `npx skills@latest add mattpocock/skills` from
  `dotfiles/agents`
- Targets: Codex and Claude Code
- Observed upstream HEAD after the last project-scoped install:
  `d574778f94cf620fcc8ce741584093bc650a61d3`

Approved names:

- `code-review`
- `codebase-design`
- `diagnosing-bugs`
- `domain-modeling`
- `grill-with-docs`
- `grilling`
- `handoff`
- `improve-codebase-architecture`
- `prototype`
- `research`
- `setup-matt-pocock-skills`
- `tdd`
- `teach`
- `to-spec`
- `to-tickets`
- `writing-great-skills`

`grilling` is required by `grill-with-docs` and architecture workflows.
`grill-with-docs` also uses `domain-modeling`.
`improve-codebase-architecture` uses `codebase-design`, `domain-modeling`,
and `grilling`.

Release `v1.1.0` consolidates the planning flow around `to-spec` and
`to-tickets`; the superseded upstream names `to-prd`, `to-plan`, and
`to-issues` were not previously vendored here. This repository intentionally
keeps a practical subset rather than the full upstream workflow: ordinary
Codex tasks implement the output of `to-tickets`, while the issue-queue router,
triage, and large-project decision-map layers are omitted.

Local integration adaptation:

- `to-tickets`: the final `/implement` handoff is replaced with a fresh Codex
  task that uses the retained `tdd` and `code-review` skills and treats commit
  authority separately. Reapply this one-line workflow adaptation after a
  future project-scoped upstream update.

The retained upstream `setup-matt-pocock-skills` templates still describe
optional triage and wayfinding configuration. Those sections do not imply the
corresponding skills are installed; the practical planning pair consumes only
the tracker, label, and domain-document configuration.

The project lock records per-skill content hashes but does not record an
immutable source revision. The observed HEAD is provenance evidence from the
installation window, not a claim that the CLI pinned that commit.

### Baseline comparison

The imported runtime baseline matched the prior Git snapshot where one
existed, except for snapshot-only support files already retired before the
current steady-state package:

- `grill-with-docs`: `ADR-FORMAT.md`, `CONTEXT-FORMAT.md`
- `improve-codebase-architecture`: `ADR-FORMAT.md`, `CONTEXT-FORMAT.md`,
  `DEEPENING.md`, `INTERFACE-DESIGN.md`, `LANGUAGE.md`
- `tdd`: `deep-modules.md`, `interface-design.md`, `refactoring.md`

Those retired files were upstream snapshot material, not local extensions.
The project-scoped installer produced contents byte-equal to the imported
baseline for all ten selected skills.

Known CLI caveat: `skills update --help` behaved as an update rather than help
during audit. Do not use it for help inspection; use an isolated fixture.

The 2026-07-10 update changed the vendored `handoff` terminology from PRDs to
specs and updated `setup-matt-pocock-skills` to name `to-spec` and
`to-tickets`. The other eight previously selected skill trees already matched
the `v1.1.0` upstream contents at the observed revision.

## `heredotnow/skill`

- Source: <https://github.com/heredotnow/skill>
- Selected name: `here-now`
- Ownership here: reviewed vendored copy with a local installation-policy note
- Update: project-scoped `npx skills@latest add heredotnow/skill` from
  `dotfiles/agents`
- Targets: Codex and Claude Code
- Observed upstream HEAD after the last project-scoped install:
  `f6e7ddb92f51bed76ff4dc8f99457c14b83577e6`

The repository README declares MIT, but the audited source still lacks a top-level
license file. Retain this caveat until upstream publishes the license text.
The installer result includes upstream `scripts/publish.sh` and
`scripts/drive.sh`; both remain executable. The only local content correction
is the `SKILL.md` install note, which replaces upstream global-install wording
with this repository's project-scoped workflow. Reapply that policy note after
future installer updates if upstream still recommends `--global` or `-g`.

The observed HEAD is not an immutable installer pin because
`skills-lock.json` records content hashes without a revision.

## Framer-derived local forks

The tracked `framer` and `framer-code-components` skills are intentional local
forks of Framer agent-generated material. Their original generated copies did
not include a license or stable source revision. Keep that provenance
limitation visible and do not redistribute them as upstream Framer artifacts
without confirming applicable terms.

Known local changes:

- `framer`
  - narrows triggering to explicit Framer context
  - removes unconditional pre-load setup
  - requires normal environment permission handling
  - does not treat setup as publishing/deletion authority
  - marks generated project metadata as private runtime-only state
- `framer-code-components`
  - corrects the TypeScript interfaces table-of-contents anchor to
    `framer-property-control-types`

These tracked versions are authoritative and must never be overwritten by a
third-party installer.

## `Forward-Future/loopy`

- Source: <https://github.com/Forward-Future/loopy>
- License: MIT
- License copy: `licenses/loopy-LICENSE.txt`
- Copyright notice: Copyright (c) 2026 Forward Future
- Ownership here: intentional local fork
- Update: manual upstream review only
- Upstream HEAD observed during provenance review:
  `b88213d0d8252bb46a43f8cb7889ae40ed1c1187`

The observed HEAD is not claimed as the fork base. The tracked fork includes
OpenAI metadata and workflow references and is excluded from automatic
third-party updates.

## Generated Framer project skills

`framer-project-*` directories are generated machine-local state, not
redistributed third-party source. They remain real directories outside Git
under `$HOME/.agents/skills` and may contain private project metadata. Their
Claude links remain runtime-only.
