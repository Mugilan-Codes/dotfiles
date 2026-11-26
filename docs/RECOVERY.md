# Personal Mac installation and recovery

This workflow targets Apple Silicon macOS. Intel and Linux installation are
explicitly unsupported; existing platform guards in the shell do not make this
an Ubuntu work-machine installer. Do not deploy this personal Git identity,
agent provider configuration or application inventory to an employer machine.

## Clean Mac sequence

1. Install Xcode Command Line Tools with `xcode-select --install`, complete the
   macOS dialog, and rerun if it was interrupted. Full Xcode and its licenses
   are separate requirements for iOS development.
2. Obtain the repository over HTTPS before SSH keys exist. The verified origin
   is `git@github.com:Mugilan-Codes/dotfiles.git`; its HTTPS form is below. On a
   machine with existing URL rewrites, disable the existing Git configuration
   only for this clone. If GitHub requires access, authenticate separately;
   never embed a credential in the URL.

   ```sh
   GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
     /usr/bin/git clone https://github.com/Mugilan-Codes/dotfiles.git "$HOME/dotfiles"
   cd "$HOME/dotfiles"
   ./install.sh --dry-run
   ```

3. If Homebrew is missing, install it using the official instructions at
   https://brew.sh. The installer deliberately pauses for this privileged
   bootstrap/OS step rather than piping a remote script into your shell.
   Resume with the same command; no configured aliases or Node/Python are
   needed to reach this prerequisite message.
4. Review conflicts and required dependencies, then install:

   ```sh
   ./install.sh
   ./install.sh --check
   scripts/agent-skills check
   ```

`install.sh` uses macOS Bash and fixed system/Homebrew paths. Once prerequisites
exist it installs only missing formulae from `Brewfile.core`, provisions absent
OMZ/plugins at the revisions in `shell-sources.json`, simulates Stow, and applies
links. Each new integration is checked out in a temporary sibling directory
and moved into place after its entry file is verified. Existing complete
integrations and their update policy are preserved. Review an incomplete
integration before retrying. A conflicting Oh My Zsh parent needs manual
resolution because moving it could also displace the installed integration.
GitHub resolved all three shell commit pins on 2026-11-26. Download and
checkout on a clean Mac remain unverified.

`--check` verifies required package receipts by opt paths, shell integration
entry files, instruction destinations and managed Stow links; it exits nonzero
for missing/wrong state. It does not contact Homebrew or assess package
freshness. `scripts/agent-skills check` additionally verifies package contents,
provenance and skill links. Unmanaged siblings are reported without failure.
Checks do not prove authentication, model availability or live shell startup.

`--dry-run` creates no directories, cache, downloads, backups or links. With
missing initial prerequisites it describes the next manual prerequisite and
stops successfully. With available dependencies it performs preflight and a
Stow simulation when the target already exists and has no conflicts.
Deployment uses the configuration paths in `scripts/deploy.py` and the skill
manifest as its allowlist. The installer ignores personal Stow defaults.

## Conflicts and rollback

Default installation refuses conflicting destination files. After examining
those files and resolved links, opt into backup-and-replace:

```sh
./install.sh --dry-run --backup
./install.sh --backup
# Use the exact RESTORE RECORD printed by the installer:
./install.sh --restore /absolute/path/to/.dotfiles-backups/deploy-ID/restore.json
```

Each changed deployment keeps a restore journal and displaced entries under
`TARGET/.dotfiles-backups/deploy-ID/`. The backup root must be owned by your
account and inaccessible to group and others. Keep the journal in its original
directory. Restore checks the full plan for changed links, new content in
created directories and redirected parent directories before moving anything.
A complete repeat install skips link work and creates no journal.

If Stow or a backup move fails after `RESTORE RECORD` appears, use that
record to roll back before retrying deployment. New journals record planned
links and backup identities so restore can distinguish unfinished moves from
missing backups. Restore covers configuration links and displaced files.
Handle packages and shell integrations separately. Use only journals you
created locally and keep them out of Git. Run one deployment or restore at
a time and leave the destinations untouched until it finishes.

Real `.agents/skills`, `.claude/skills` and `.codex` parents are preserved.
Managed skill children are directory symlinks.

## Isolated deployment

```sh
target=$(mktemp -d /private/tmp/dotfiles-target.XXXXXX)
./install.sh --dry-run --target "$target"
./install.sh --target "$target"
./install.sh --target "$target"       # idempotence
./install.sh --check --target "$target"
scripts/agent-skills check --target "$target"
```

`--target` deploys files only; package installation and shell downloads are
skipped. It never treats a different HOME as isolation for macOS tools. Use
canonical real paths (`/private/tmp`, not symlinked `/tmp`); symlinked target
ancestors are refused. An isolated target is not a bootable developer home.
The regression suite uses real Stow, fake credentials and mocked network/
package boundaries. No clean-macOS reinstall is claimed.

## Manual toolchain and application setup

| Owner | Restore deliberately |
| --- | --- |
| FNM | Required formula; after install, run `eval "$(fnm env)"`, `fnm install --lts`, `fnm default lts-latest`; projects should carry `.node-version`/`.nvmrc`. Existing installed Node 24.20.0 is an observation, not a new global pin. Choose project-required Node versions before global CLI installation. |
| pnpm/Yarn/Bun | Choose the project's package manager/version; don't install a competing global manager just to match every historical receipt. Optional Brewfile lists previous choices. |
| Python | Homebrew provides the `python3` used by recovery. Use a project-required interpreter and a virtual environment for project dependencies. Keep any optional versioned formula only where needed. |
| SDKMAN / Java | SDKMAN is not supplied by Stow/Homebrew core setup. Follow https://sdkman.io/install, review its shell edits, then install a project-required JDK and choose `sdk default java VERSION`. SDKMAN init remains conditional. No old Java identity/config copied. |
| FVM / Flutter | Optional core formula `brew install fvm`, then `fvm install VERSION` and `fvm global VERSION` if a global default is wanted. Prefer project `.fvmrc`. Flutter SDKs and fallback `~/flutter` are not backed up by dotfiles. Existing SSH Flutter URL may require GitHub credentials; choose HTTPS explicitly if cloning without SSH. |
| Android | Install Android Studio/SDK tools separately; accept licenses and download required SDKs. Shell uses `~/Library/Android/sdk` and current `cmdline-tools/10.0/bin` when present. Match that version or review the PATH before changing it. `adb` is already owned by SDK platform-tools on this Mac; the optional cask is not required. |
| Editor / terminals | VS Code CLI `code` must be installed separately (default editor uses `code --wait`). Select desired terminal/editor apps. Terminal profiles, fonts, extensions and licenses may require separate restoration. |
| Docker / OrbStack | Optional application and service; open/initialize it, then choose the Docker context deliberately. No daemon started by install.sh. |
| neatCLI / completions | Optional `fognil/tap/neatcli`; review/install separately, then `neatcomp`. Tabtab/Bun/Dart/Mole completion hooks remain conditional. |
| AI agents / Caveman / REA | See `agents/portable/README.md` and `agents/external-skills.json`. Node, agent installation and authentication precede integrations. No proxy/hook is enabled by installation. |
| SSH/Git identity | Provision personal credentials privately, check ownership/modes and deliberate account routing. Do not restore the missing legacy-work key from a personal/current-employer key. See below. |

`Brewfile.core` owns direct shell/recovery dependencies including Starship,
ripgrep and Python. The large `Brewfile` is optional application inventory, not
a mandatory restoration command. It retains ambiguous optional apps
(android-platform-tools, boring-notch, hiddenbar) for review; none was installed
or removed. FVM and LocalSend now use official core formula/cask names:
https://formulae.brew.sh/formula/fvm and https://formulae.brew.sh/cask/localsend.
No package metadata update or upgrade was run. Historical standalone Starship
can coexist until you separately review its removal; installation prefers
Homebrew's PATH. Homebrew may install dependency versions required by a missing
formula even with auto-update/install-upgrade/cleanup disabled; it is not an
exact-version snapshot of an old machine.

## Legacy-work identity decision (DF-01)

On 2026-11-26, the active personal Git config still contained the legacy
directory-scoped include, and the personal shell still defined `cdw` and
`cdapp` shortcuts into that tree. The previously recorded key path was
absent. The effective route remains unverified without inspecting the legacy
workspace or its include. Recommend retiring the route and shortcuts after
confirming remote access is no longer required. If access is still authorized,
provision a dedicated identity through its owner. Preserve historical commits
and remotes either way.

`scripts/git-ssh-identity` is prepared but not enabled. It refuses a missing
absolute key before SSH, disables implicit SSH config and agent fallback, and
selects only that key. After deciding the workspace's status and provisioning
its own authorized key, review a workspace-local include like:

```gitconfig
[core]
    sshCommand = '/absolute/path/to/dotfiles/scripts/git-ssh-identity' '/absolute/path/to/authorized-legacy-key'
```

This wrapper intentionally bypasses SSH config; proxy/jump-host/account
exceptions must be reviewed before adoption. Do not apply it to unknown work
hosts. Commit identity (`user.name`/`user.email`) is separate from SSH account
routing: retain the existing legacy identity, never substitute a guessed one.
For a retired tree, keep it offline and document that remote access is disabled
rather than deleting historical repositories. The wrapper's missing-key test
uses a fixture and never initiates SSH.

## Nondefault Codex home

Actual current home is `~/.codex`. The installer refuses nondefault CODEX_HOME
for a live install rather than writing instructions to an unused location.
After reviewing actual destinations, selective deployment is possible:

```sh
stow --target="$HOME" --simulate --ignore='^\.codex$' agents
# Only after review: apply the same command without --simulate.
# Then create a real "$CODEX_HOME" parent and link its AGENTS.md to
# "$HOME/dotfiles/agents/.codex/AGENTS.md", preserving conflicts first.
```

Claude's tracked global link resolves to the canonical repository instruction
file through the deployed link itself; it does not require the runtime default
Codex directory. Inspect `AGENTS.override.md` in the actual home before use.

## What this restores

Committed repository content reconstructs intended configuration, vetted skills
and a current compatible package/toolchain setup. It does not restore personal
data, unpublished Git work, SSH keys, tokens, paid software, account state,
model access, exact historical package versions or cloud application settings.
Keep a separate encrypted data/credential backup. **Uncommitted or unpushed
changes on this Mac are not disaster-recovery protection.**
