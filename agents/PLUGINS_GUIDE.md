# Application-managed plugins

Plugins extend an application with skills, commands, hooks, connectors, or
tools. They are not the Git-vendored skills in this Stow package. Plugin
caches and configuration may contain sessions, credentials, absolute paths,
databases, and generated metadata; never copy them into dotfiles.

Snapshot audited from safe CLI list output on 2026-07-10. Re-run the list
commands because application-managed versions and enabled state can change.

## Installed inventory

| Plugin | Host / source / version | Purpose and when to use | Requirements/state | Restart | Reproducible from dotfiles |
| --- | --- | --- | --- | --- | --- |
| `vercel-plugin@plugins-cli` | Codex; shared marketplace; 0.44.0; enabled | Vercel/Next.js/deployment skills and hooks | Node/network/account per operation; PARTIAL/account-specific | Start a fresh task after change | No; app config/cache |
| `documents@openai-primary-runtime` | Codex runtime; 26.630.12135; enabled | Create/edit Word documents | Bundled runtime: SATISFIED | Fresh task recommended | No; runtime-managed |
| `pdf@openai-primary-runtime` | Codex runtime; 26.630.12135; enabled | Read/create/render PDFs | Bundled runtime: SATISFIED | Fresh task recommended | No |
| `spreadsheets@openai-primary-runtime` | Codex runtime; 26.630.12135; enabled | Analyze/create spreadsheet files | Bundled runtime: SATISFIED | Fresh task recommended | No |
| `presentations@openai-primary-runtime` | Codex runtime; 26.630.12135; enabled | Create/edit slide decks | Bundled runtime: SATISFIED | Fresh task recommended | No |
| `template-creator@openai-primary-runtime` | Codex runtime; 26.630.12135; enabled | Create reusable artifact templates | Bundled runtime: SATISFIED | Fresh task recommended | No |
| `sites@openai-bundled` | Codex bundled; 0.1.27; enabled | Build/host Sites artifacts | App/network for hosting; PARTIAL at use | Fresh task recommended | No |
| `browser@openai-bundled` | Codex bundled; 26.707.31428; enabled | Control the in-app browser | Desktop browser capability: SATISFIED | Fresh task recommended | No |
| `computer-use@openai-bundled` | Codex bundled; 1.0.1000366; disabled | General computer interaction when explicitly selected | Installed but DISABLED | Fresh task required after state change | No |
| `visualize@openai-bundled` | Codex bundled; 1.0.11; enabled | Interactive diagrams, labs, and simulations | Codex desktop: SATISFIED | Fresh task recommended | No |
| `ponytail@ponytail` | Codex Git marketplace; 4.8.4; enabled | Minimal-solution implementation/review modes | Git/network for marketplace refresh; SATISFIED/optional at use | Fresh task recommended | Partially: marketplace source could be documented, cache should not be |
| `github@openai-curated` | Codex curated; `bd2122cb`; enabled | GitHub PR/issue/CI workflows | Connected GitHub account/permissions: ACCOUNT-SPECIFIC | Fresh task recommended | No; account/app-managed |
| `gmail@openai-curated` | Codex curated; `bd2122cb`; enabled | Search/triage/draft Gmail | Connected Google account/permissions: ACCOUNT-SPECIFIC | Fresh task recommended | No |
| `google-drive@openai-curated` | Codex curated; `bd2122cb`; enabled | Drive/Docs/Sheets/Slides connector workflows | Connected Google account/permissions: ACCOUNT-SPECIFIC | Fresh task recommended | No |
| `codex-security@openai-curated` | Codex curated; `bd2122cb`; enabled | Security scans, validation, fixing, and write-ups | Repository access; tracker/network only for external actions | Fresh task recommended | No |
| `vercel-plugin@vercel` | Claude Code marketplace; 0.44.0; user scope; enabled | Vercel platform and Next.js workflows in Claude | Node/network/account per operation: ACCOUNT-SPECIFIC | **Yes** after update; fresh session after other state changes | No; Claude user state |

`$HOME/.agents/plugins/marketplace.json` is a shared marketplace descriptor,
not an installed plugin. Codex lists many additional marketplace entries as
“not installed”; availability is not installation.

## Codex supported workflow (CLI 0.144.1)

Read-only discovery:

```sh
codex plugin list
codex plugin marketplace list
codex plugin add --help
codex plugin remove --help
```

Mutation examples (replace placeholders and run only with explicit plugin
authority and network access):

```sh
codex plugin add <plugin>@<marketplace>
codex plugin remove <plugin>@<marketplace>
codex plugin marketplace upgrade <marketplace>
```

This CLI has no `plugin update`, `enable`, or `disable` subcommand. Refresh a
Git marketplace with `marketplace upgrade`; then inspect `plugin list` and use
the Codex desktop plugin UI for supported enabled-state changes or reinstall
only when the application directs it. Bundled, primary-runtime, and curated
plugins are application-managed; do not manually rewrite their cache. Start a
fresh Codex task after a change and verify the skill/tool appears.

## Claude Code supported workflow (2.1.62)

```sh
claude plugin list
claude plugin install <plugin>@<marketplace> --scope user
claude plugin update <plugin>@<marketplace> --scope user
claude plugin disable <plugin>@<marketplace> --scope user
claude plugin enable <plugin>@<marketplace> --scope user
claude plugin uninstall <plugin>@<marketplace> --scope user
claude plugin validate <path>
claude plugin marketplace list
claude plugin marketplace update <marketplace>
```

Choose `user`, `project`, or `local` scope intentionally. Claude explicitly
requires a restart after `plugin update`; restart after install/removal or
enabled-state changes as well, then run `claude plugin list`.

## Shared agent/plugin tooling

There is no generic shared plugin install/update/remove command. The shared
`$HOME/.agents/plugins/marketplace.json` is consumed by a host (currently the
Codex `plugins-cli` marketplace), so manage the plugin through that host’s
supported command/UI. Never edit marketplace caches to simulate installation.

Plugin authentication and connector permissions are interactive manual
checks. List output proves installation/enabled state, not that an account is
currently authorized for every operation.

## Application-managed Codex skills

`$HOME/.codex/skills` currently contains 11 top-level skill packages. None
duplicates a tracked skill in `agents/.agents/skills`.

| Class | Current names | Maintenance |
| --- | --- | --- |
| Codex system | `.system/imagegen`, `.system/openai-docs`, `.system/plugin-creator`, `.system/skill-creator`, `.system/skill-installer` | Shipped/updated by Codex; manual edits discouraged |
| Standalone installed | `pdf`, `playwright`, `playwright-interactive`, `security-best-practices`, `security-ownership-map`, `security-threat-model`, `vercel-deploy` | Keep outside dotfiles; inspect each `SKILL.md`/metadata and use the supported skill installer or its recorded source for updates |
| Plugin-provided | None at this path | Plugin skills currently resolve from plugin cache and are maintained with the plugin |
| Portable user-authored stranded copies | None | New portable custom skills belong in `agents/.agents/skills` |

Discover the current set and safe metadata with:

```sh
find "$HOME/.codex/skills" -mindepth 1 -maxdepth 2 -type d -print
find "$HOME/.codex/skills" -name SKILL.md -maxdepth 3 -print
```

These directories remain application-managed because system updates,
installer metadata, and host-specific behavior are not reproducible Stow
content. Discover versions from plugin/installer metadata where present; a
skill without version metadata has no safe version claim. Do not manually
copy, overwrite, or remove it merely to match the tracked inventory.
