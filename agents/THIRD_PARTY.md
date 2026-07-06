# Third-party Skills and Attribution

Audited: 2026-07-06

This file records provenance for CLI-managed skills and tracked intentional
forks. Installed CLI-managed contents under `$HOME/.agents/skills` are runtime
artifacts and are not tracked in dotfiles.

## `mattpocock/skills`

- Source: <https://github.com/mattpocock/skills>
- License: MIT
- Copyright notice observed: Copyright (c) 2026 Matt Pocock
- Installation: pinned `skills@1.5.14`, global scope, symlink mode
- Targets: Codex and Claude Code
- Update: `scripts/agent-skills update`
- Local clone required: no

Selected names:

- `code-review`
- `codebase-design`
- `domain-modeling`
- `grill-with-docs`
- `grilling`
- `handoff`
- `improve-codebase-architecture`
- `setup-matt-pocock-skills`
- `tdd`
- `teach`

The exact names were verified with the pinned CLI list operation on the audit
date. `grilling` is retained because `grill-with-docs` invokes it.

### Retired vendored snapshot

Before this migration, dotfiles tracked copies of the selected Matt skills.
A comparison with the installed CLI-managed replacements and the clean local
upstream clone at `66f92b61f5b1434a1c7422f6fbd8efc5ee0c0214` found the skill contents
equal except for these snapshot-only files:

- `grill-with-docs`: `ADR-FORMAT.md`, `CONTEXT-FORMAT.md`
- `improve-codebase-architecture`: `ADR-FORMAT.md`, `CONTEXT-FORMAT.md`,
  `DEEPENING.md`, `INTERFACE-DESIGN.md`, `LANGUAGE.md`
- `tdd`: `deep-modules.md`, `interface-design.md`, `refactoring.md`

Other support files that still exist upstream remain available in the
CLI-managed runtime installation. The snapshot-only files were not independent
local work and were removed after the pinned CLI installation supplied and
validated the current upstream skill directories.

## `heredotnow/skill`

- Source: <https://github.com/heredotnow/skill>
- Selected name: `here-now`
- License: repository README declares MIT
- Installation: pinned `skills@1.5.14`, global scope, symlink mode
- Targets: Codex and Claude Code
- Update: `scripts/agent-skills update`

The selectable name and README license declaration were verified on the audit
date. The repository did not expose a top-level `LICENSE` file at the audited
`main` URL, so retain this README-based license note until upstream publishes
the complete license text.

The retired vendored copy included `scripts/publish.sh` and
`scripts/drive.sh`. They are upstream support files, not local extensions, so
they are removed only after the CLI-managed `here-now` installation is
present and its support files validate.

## Framer-derived local forks

The tracked `framer` and `framer-code-components` skills are intentional local
forks of Framer agent-generated skill material. Their original generated
copies did not include a license or stable source-revision record. Keep this
provenance limitation visible and do not redistribute them as upstream
Framer-owned artifacts without confirming the applicable terms.

Known local changes:

- `framer`
  - narrows triggering to explicit Framer context
  - removes an unconditional pre-load setup requirement
  - requires normal environment permission handling
  - states that setup does not authorize publishing or deletion
  - marks generated project metadata as private runtime-only state
- `framer-code-components`
  - corrects the TypeScript interfaces table-of-contents anchor to
    `framer-property-control-types`

These dotfiles versions are authoritative. Do not replace them with older
copies from `$HOME/.claude/skills`.

## `Forward-Future/loopy`

- Source: <https://github.com/Forward-Future/loopy>
- License: MIT
- Ownership here: intentional local fork
- Local source: `agents/skills/loopy`
- Installation: individual dotfiles-owned links, not the third-party CLI
- Update: manual upstream review

The local skill includes tracked OpenAI metadata and workflow references.
Automatic third-party update is intentionally disabled so local ownership
cannot be overwritten.

## Generated Framer project skills

`framer-project-*` directories are generated machine-local state, not
redistributed third-party source. They remain outside Git under
`$HOME/.agents/skills` and may contain private project metadata.
