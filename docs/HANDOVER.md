# Dotfiles implementation handover — 2026-11-14

## Changed files and result

Implemented the authorized repository work for the personal Apple Silicon Mac.
Stow remains the deployment mechanism, and `scripts/agent-skills` remains the
skill-management entry point. No new configuration framework was introduced.

- Shell/Git: repaired quoting, loopback serving, listener selection, option
  boundaries, error statuses, success reporting and atomic completions.
- Recovery: added `install.sh`, required `Brewfile.core`, `scripts/deploy.py`,
  pinned shell-integration sources, conflict backups/restore journals and the
  previously unmanaged global Git ignore contents. Updated optional Brewfile
  sources for FVM/LocalSend and declared direct prompt/search dependencies.
- AI: preserved personal global Codex instructions; added the tracked Claude
  global link to that source; documented selective portable preferences and
  externally owned integrations. No live agent setting was changed.
- Skills: added complete-package imports, pinned repository acquisition,
  deliberate updates, provenance/hashes/patch notes, drift checks and deployment.
  Reviewed vendor fixes prevent the demonstrated publisher/export defects.
- Documentation/tests: updated repository/skill guidance, recorded recovery and
  vendor-patch evidence, and added 23 offline regression tests.

`agents/.codex/AGENTS.md` was already modified before this implementation.
Its bytes were preserved exactly (SHA-256
`9cd7a21ad2d6e8946a105da2ecd11908f21cb59ef585aa81251559d580d1dc0f`).
No files were moved or deleted. One repository symlink was added:
`agents/.claude/CLAUDE.md -> ../.codex/AGENTS.md`. No new live symlink was created.

Existing live Stow links expose edits to shell functions/aliases, the Git abort
alias, skills-maintainer guidance and here-now scripts to subsequent readers.
No live shell was reloaded, and no publishing/export or cleanup helper was run
against real data. This is not a claim that the whole machine was unchanged.

## Finding-by-finding status

| ID | Status | Implementation/evidence | Remaining limit |
| --- | --- | --- | --- |
| DF-01 | Prepared; live routing deferred | `scripts/git-ssh-identity` refuses a missing absolute key before SSH and disables implicit identity/agent fallback; fixture test passes | Choose active versus retired legacy workspace. Existing legacy include/remotes/history remain untouched; missing-key live risk remains until that decision |
| DF-02 | Fixed | `zoxfz` uses fzf's own placeholder quoting; hostile-name fixture does not execute shell substitution | Documented substitution tested, not live fzf UI |
| DF-03 | Fixed | `serve` delegates to `servehere`; ports validated and Python receives `--bind 127.0.0.1` | Server invocation mocked; no listener started |
| DF-04 | Fixed | `killport`/`killportf` select TCP LISTEN only, validate PIDs and distinguish empty results from inspection errors | lsof and signals mocked; no real process killed |
| DF-05 | Fixed | Managed package/hash/link/Claude-subset validation remains strict; extra siblings are classified separately | Unknown siblings require review, never automatic adoption |
| DF-06 | Implemented recovery correction | Required versus optional Brewfiles, direct dependencies, core FVM/LocalSend names, explicit runtime ownership | Homebrew package installation and current remote availability not exercised |
| DF-07 | Fixed for audited cases | Cleanup/clipboard/organizer/restart failures propagate; Git abort selects an actual operation; completion generation validates before replacing | No destructive live workflow executed |
| DF-08 | Fixed | Documentation checks each shell file individually; all seven Zsh files checked separately | Syntax checks do not prove live startup behavior |
| DF-09 | Fixed | `_dotfiles_edit` removes shell lexical quotes without eval and forwards arguments/empty strings | Editor executable mocked |
| DF-10 | Fixed with explicit limits | mkdir/cd/rg option boundaries; archive path normalized; line picker newline and live-grep colon limitations documented | Arbitrary newline/colon filename support was not introduced |
| DF-11 | Implemented recovery correction | HTTPS acquisition, prerequisites, managed ignore file, toolchain/account/data restoration boundaries documented | Real clean-macOS installation remains unproven |
| DF-12 | Fixed for demonstrated exposure | Nested hidden/internal/secret/VCS filtering, symlink exclusion, `.well-known` preserved, protected atomic state; manifest regression | Filter cannot discover secrets embedded in arbitrary web content; publish only reviewed output |
| DF-13 | Fixed | Validated remote paths, no-follow parent traversal, exclusive leaf creation, existing-file refusal, failed-download containment | Use a private destination; concurrent hostile directory renames are outside the guarantee; prior successful pages remain on later failure |

Vendor comparison and patch/license/hash provenance are in `VENDOR-PATCHES.md`.
The current upstream Drive exporter still used uncontained path concatenation;
its publisher's root-state exclusion did not fix nested exposures. Local
patches were applied instead of importing unrelated upstream features.

## Commands

From `/Users/mugilan/dotfiles`:

```sh
./install.sh --dry-run
./install.sh
./install.sh --check

# Isolated link deployment; skips all package/network provisioning:
target=$(mktemp -d /private/tmp/dotfiles-target.XXXXXX)
./install.sh --dry-run --target "$target"
./install.sh --target "$target"
./install.sh --target "$target"
./install.sh --check --target "$target"
scripts/agent-skills check --target "$target"

# Opt-in conflict handling; inspect the dry-run before applying:
./install.sh --dry-run --backup
./install.sh --backup
./install.sh --restore /absolute/path/to/restore.json

scripts/agent-skills list
scripts/agent-skills check
scripts/agent-skills audit
scripts/agent-skills add my-skill --from-dir /reviewed/my-skill \
  --origin 'Accurate local origin' --license 'Accurate license/source note'
scripts/agent-skills add-repo my-skill --repo https://github.com/OWNER/REPO \
  --revision FULL_40_CHARACTER_COMMIT_SHA --subdir path/to/my-skill \
  --license 'Reviewed package license'
scripts/agent-skills import my-skill --from-dir "$HOME/.agents/skills/my-skill" \
  --origin 'Accurate installed-package origin' --license 'Reviewed license'
scripts/agent-skills update my-skill --from-dir /reviewed/new/my-skill \
  --origin 'Accurate updated origin' --license 'Reviewed license'
scripts/agent-skills deploy --dry-run --target "$target"
scripts/agent-skills deploy --target "$target"
```

The add/import/update paths, names, source URLs, revisions and license notes
above are explicit placeholders. Use actual reviewed values. For packages with
local patches, updates additionally require `--reviewed-patches 'Explanation'`.
Manual reviewed edits use `record-patch NAME --origin EVIDENCE --note CHANGE`.
See `../agents/README.md` for dependencies, licensing, collision handling and
complete command semantics. No command auto-commits or pushes.

Clean-Mac acquisition before SSH exists:

```sh
xcode-select --install
# Finish the OS dialog first.
GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
  /usr/bin/git clone https://github.com/Mugilan-Codes/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
./install.sh --dry-run
# If needed, install Homebrew using https://brew.sh, then resume:
./install.sh
./install.sh --check
```

The HTTPS URL is derived from the verified personal origin, not an invented
remote. `RECOVERY.md` covers the manual Node/Java/Flutter/Android/editor/agent
steps and separates configuration restoration from personal data/credentials.

## Global AI destination map

| Source | Destination | Behavior |
| --- | --- | --- |
| `agents/.codex/AGENTS.md` | Actual `$CODEX_HOME/AGENTS.md`; currently `~/.codex/AGENTS.md` | Existing personal instruction source preserved; override file currently absent |
| `agents/.claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Tracked relative link to the same source; live deployment pending |
| Root `AGENTS.md` and `CLAUDE.md -> AGENTS.md` | This repository | Project policy stays separate; no circular/global re-import |
| `agents/.agents/skills/*` | `~/.agents/skills/*` | Directory symlinks for 27 managed skills |
| `agents/.claude/skills/*` | `~/.claude/skills/*` | 26 compatibility links; staged-change-reviewer stays Codex-only |
| `agents/portable/codex-preferences.toml` | Selective review/merge into Codex config | Not automatically loaded; excludes providers, hooks, trust and account state |
| External Caveman integration | OpenCode native global rules/plugin and local Codex/Claude integration | Restore through owning installer; existing routing remains unchanged |

Installed metadata identifies Codex 0.168.0, Claude Code 2.1.62 and OpenCode
1.19.5. Official discovery/precedence docs were checked; no agent session was
launched. No universal `~/.AGENTS.md`, unsupported include directive or broad
Codex state package was added. Nondefault CODEX_HOME is refused by default
live deployment; use the documented selective procedure. Cloud ChatGPT Work/
Cowork settings are not reconstructed by these local files.

## Skill inventory and decisions

- Managed: **27**, unchanged inventory (6 local, 3 forks, 18 vendored); hashes,
  source/revision limitations, agents, dependencies and local patches recorded.
- Previously untracked siblings: **15 externally owned** (14 Caveman/cavecrew,
  one REA); sources, observed versions, scope, pinning limits and recovery
  commands recorded in `agents/external-skills.json`.
- **6 unresolved**: investigate-first, lean-build, migration, safe-refactor,
  surgical-patch, verify-and-stop. Contents reviewed; adequate original
  authorship/license/installer provenance was not established. Preserved,
  not claimed as personal authored content or silently adopted.
- Generated Framer project state and application plugin caches stay outside
  the managed inventory. Claude Caveman/Vercel plugins are recorded through
  their owners; Codex application plugins require selective UI restoration.

An arbitrary external install command does **not** capture a skill in dotfiles.
Use explicit reviewed import or its recorded plugin owner. The remaining
choices are legacy-work status, provenance/ownership of the six workflow
skills, optional applications, project runtime versions and whether OpenCode
should additionally load shared preferences beside its native Caveman rules.

## Validation and limits

| Check | Result |
| --- | --- |
| `python3 -B tests/test_regressions.py` | 23 tests passed; real Stow in temporary targets, mocked package/network/agent boundaries |
| Shell regressions | Quoting/no-eval, empty/spaced/option-like arguments, port bounds, listener-only selectors, failure statuses and atomic completion preservation passed |
| Vendor regressions | Nested exclusions/.well-known, traversal, parent/leaf symlinks, existing files, dry-run nonmutation, failed downloads and full-script wiring passed |
| Skills regressions | Add/import/update, source/provenance validation, collisions, local drift, patch review, external-owner refusal, missing links, unmanaged preservation and pinned acquisition passed |
| Installer regressions | Fresh/second install, paths with spaces, no-argument Bash bootstrap, nonmutating dry/check, missing dependency behavior, backups/restore and changed-destination refusal passed |
| Individual syntax/parsing | Seven Zsh startup/custom files, Bash scripts individually, POSIX wrapper, Python AST, JSON and portable TOML passed |
| `scripts/agent-skills check` / `audit` | Passed on current managed sources/live skill topology; unmanaged siblings reported |
| `git diff --check` / `git diff --cached --check` | Passed; nothing staged |
| Live `./install.sh --dry-run --backup` | Read-only preflight succeeds; identifies global-ignore conflict and missing managed jq/Starship receipts |
| Live `./install.sh --check` | Expected nonzero: Homebrew opt receipts for jq and Starship absent; does not imply standalone/bundled executables are absent |
| Live Stow simulation, agents | Passed; would add only the new global Claude instruction link |
| Live Stow simulation, core | Expected refusal for existing real `~/.gitignore-global`; no changes applied |
| Existing personal-instruction hash | Exact baseline bytes preserved |

The final six skill regression cases were repeated after correcting generated
registry-row placement/columns. No package was installed/upgraded, no actual
Git/SSH operation contacted an employer, and no hooks, MCP servers, agent
sessions, publishing or export service was started. No full client schema or
fresh interactive-shell startup test is claimed. OS prompts, real package
installs, upstream acquisition and clean-macOS restoration were simulated or
left manual; pinned remote availability and exact historical versions are not
proven. Live checks read local files/metadata only.

Sanitized test/static/simulation logs remain at:
`/private/tmp/dotfiles-implementation-_w9vka45/`.
Regression fixture directories and their backups were automatically removed.
The previous audit directory was read, not replaced. No live backup was
created; real deployment will print its restore-record path.

## Pending live deployment and next action

1. Review the Git diff, vendor patch notes, required packages and new global
   instruction link. The live global ignore file is byte-equivalent to the new
   managed source but remains a conflict intentionally; it must be preserved
   by explicit backup-and-replace if adopted.
2. If approved in a separate operation, use `./install.sh --dry-run --backup`,
   then `./install.sh --backup`. This would install missing required packages
   and apply the new links; it has **not** been run here.
3. Run `./install.sh --check`, `scripts/agent-skills check` and `audit`, then
   verify a fresh interactive shell and local agents manually. Preserve the
   printed restore journal. Enable any recovered provider/hook only after
   its dependencies and intended account are separately verified.
4. Resolve DF-01 without substituting another identity. Review the six skills'
   ownership before adopting any. Keep historical work repositories intact.
5. Separately authorize staging/commit/push after review. **Local uncommitted
   or unpushed changes are not disaster-recovery protection.**

## Commit and second-review brief

Branch remains `main`, HEAD remains
`eb87c5f32e73645e645d56e96ec991d77ed63ed8`. Nothing was staged, committed or pushed.
Suggested future commit message: `fix: harden dotfiles and add reproducible Mac recovery`.
The pre-existing Codex instruction edit must remain distinguishable during any
future staging review. See the appended final status for changed/new paths.

Paste into a second review:

> Review the uncommitted dotfiles implementation at main/eb87c5f. It repairs
> DF-02–13 in source and prepares DF-01's missing-key failure wrapper while
> leaving legacy-work identity routing unchanged pending active/retired status.
> Check install.sh + deploy.py for bootstrap nonmutation, conflict/backup/restore
> safety and Stow topology; skill-store.py for explicit imports, hashes,
> provenance/patch preservation and external-owner boundaries; and here-now's
> safe-files.py + shell wiring for nested publication exclusions and contained
> exclusive export. 23 offline tests pass, with real isolated Stow and mocked
> package/network boundaries. A real clean Mac is not proven. No live package,
> new link, identity/provider/trust change, publish, commit or push occurred.
> Existing Stow-linked source edits are visible to later readers. Preserve the
> pre-existing agents/.codex/AGENTS.md edit. There remain 27 managed skills,
> 15 externally owned siblings and six unresolved-provenance siblings. Review
> docs/RECOVERY.md, docs/VENDOR-PATCHES.md and agents/README.md for exact commands,
> source/destination mapping and limits. Do not implement unrelated changes or
> deploy without authorization.

## Final Git status

Working tree (includes the preserved pre-existing Codex instruction edit):

```text
 M .gitignore
 M AGENTS.md
 M Brewfile
 M README.md
 M agents/.agents/skills/here-now/scripts/drive.sh
 M agents/.agents/skills/here-now/scripts/publish.sh
 M agents/.agents/skills/skills-maintainer/SKILL.md
 M agents/.codex/AGENTS.md
 M agents/.stow-local-ignore
 M agents/README.md
 M agents/SKILLS_REGISTRY.md
 M agents/THIRD_PARTY.md
 M agents/skills-lock.json
 M git/.gitconfig
 M scripts/agent-skills
 M zsh/.oh-my-zsh/custom/aliases.zsh
 M zsh/.oh-my-zsh/custom/functions.zsh
?? Brewfile.core
?? agents/.agents/skills/here-now/scripts/safe-files.py
?? agents/.claude/CLAUDE.md
?? agents/external-skills.json
?? agents/portable/README.md
?? agents/portable/codex-preferences.toml
?? agents/skills-manifest.json
?? docs/HANDOVER.md
?? docs/IMPLEMENTATION.md
?? docs/RECOVERY.md
?? docs/VENDOR-PATCHES.md
?? git/.gitignore-global
?? install.sh
?? scripts/deploy.py
?? scripts/git-ssh-identity
?? scripts/skill-store.py
?? shell-sources.json
?? tests/test_regressions.py
```

Tracked-file diff summary (new untracked files are listed above, not counted here):

```text
 .gitignore                                        |   4 +
 AGENTS.md                                         |  42 +-
 Brewfile                                          |  13 +-
 README.md                                         | 145 ++----
 agents/.agents/skills/here-now/scripts/drive.sh   |  22 +-
 agents/.agents/skills/here-now/scripts/publish.sh |  49 +-
 agents/.agents/skills/skills-maintainer/SKILL.md  |  68 ++-
 agents/.codex/AGENTS.md                           |   4 +
 agents/.stow-local-ignore                         |   2 +
 agents/README.md                                  | 519 ++++++----------------
 agents/SKILLS_REGISTRY.md                         |  13 +-
 agents/THIRD_PARTY.md                             |  13 +-
 agents/skills-lock.json                           |   2 +-
 git/.gitconfig                                    |   7 +-
 scripts/agent-skills                              |  41 +-
 zsh/.oh-my-zsh/custom/aliases.zsh                 |   2 +-
 zsh/.oh-my-zsh/custom/functions.zsh               | 171 ++++---
 17 files changed, 412 insertions(+), 705 deletions(-)
```
