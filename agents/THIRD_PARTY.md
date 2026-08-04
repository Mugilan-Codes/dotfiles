# Third-party skills and attribution

Audited: 2026-08-04

Approved third-party skill contents are vendored under
`agents/.agents/skills`. Future installer results must remain project-scoped,
produce a visible Git diff, and record the resolved `skills@latest` version
in the maintenance report.

Resolved installer version: `1.5.21`

## `mattpocock/skills`

- Source: <https://github.com/mattpocock/skills>
- License: MIT
- License copy: `licenses/mattpocock-skills-LICENSE.txt`
- Copyright notice: Copyright (c) 2026 Matt Pocock
- Ownership here: exact reviewed vendored copies
- Update: project-scoped `npx skills@latest add mattpocock/skills` from
  `dotfiles/agents`
- Targets: Codex and Claude Code
- Observed upstream HEAD during this project-scoped refresh:
  `2ab958093e83e0ec752e6c1c5932da465bf23e0c`

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

### Refresh review

The project-scoped refresh retained the configured 16-skill subset and added
the upstream `agents/openai.yaml` interface metadata to each selected skill.
Reviewed content changes include broader decision-oriented grilling, recent
hot-spot-first architecture exploration, prototype capture on throwaway
branches, conditional triage setup, and one-ticket-per-file local publishing.
The documented local `to-tickets` handoff adaptation was reapplied after the
upstream update.

Known CLI caveat: `skills update --help` behaved as an update rather than help
during audit. Do not use it for help inspection; use an isolated fixture.

The 2026-08-04 refresh was project-scoped and did not add upstream names,
overwrite local skills/forks, or apply Stow. The `skills@latest` lock records
the resulting content hashes; the observed HEAD is provenance evidence, not
an immutable pin.

## `heredotnow/skill`

- Source: <https://github.com/heredotnow/skill>
- Selected name: `here-now`
- Ownership here: reviewed vendored copy with a local installation-policy note
- Update: project-scoped `npx skills@latest add heredotnow/skill` from
  `dotfiles/agents`
- Targets: Codex and Claude Code
- Observed upstream HEAD during this project-scoped refresh:
  `c9fad058b8f1258061a2ff8766e257a384ae97ed`

The repository README declares MIT, but the audited source still lacks a top-level
license file. Retain this caveat until upstream publishes the license text.
The installer result includes upstream `scripts/publish.sh` and
`scripts/drive.sh`; both remain executable. The only local content correction
is the `SKILL.md` install note, which replaces upstream global-install wording
with this repository's project-scoped workflow. Reapply that policy note after
future installer updates if upstream still recommends `--global` or `-g`.

The observed HEAD is not an immutable installer pin because
`skills-lock.json` records content hashes without a revision.

## `Leonxlnx/taste-skill`

- Source: <https://github.com/Leonxlnx/taste-skill>
- Selected name: `design-taste-frontend`
- License: MIT
- License copy: `licenses/leonxlnx-taste-skill-LICENSE.txt`
- Copyright notice: Copyright (c) 2026 Leonxlnx
- Ownership here: reviewed vendored copy
- Update: project-scoped `npx skills@latest add Leonxlnx/taste-skill` from
  `dotfiles/agents`
- Targets: Codex and Claude Code
- Observed upstream HEAD during this project-scoped install:
  `e988add20dab0fa97d7a76781c48961c8184288e`

The selected skill is the upstream v2 experimental default. It is intended
for landing pages, portfolios, and redesigns. It is contextual Markdown
guidance with no scripts, hooks, watcher, or background process; it is
considered when the task matches its description or the user invokes it. The
document itself says its design rules are contextual rather than universal.
It is not a fit for dashboards, data tables, multi-step forms, code editors,
native mobile, or realtime collaboration UIs. The repository also publishes
other Taste skills, including image-generation and legacy-v1 variants; they
were inspected but not selected.

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
- Current upstream HEAD checked during the 2026-08-04 audit:
  `75966cbd572a4185064971c9fe5e9c52e8f8456d`

The observed HEAD is not claimed as the fork base. The tracked fork includes
OpenAI metadata and workflow references and is excluded from automatic
third-party updates.

## Generated Framer project skills

`framer-project-*` directories are generated machine-local state, not
redistributed third-party source. They remain real directories outside Git
under `$HOME/.agents/skills` and may contain private project metadata. Their
Claude links remain runtime-only.
