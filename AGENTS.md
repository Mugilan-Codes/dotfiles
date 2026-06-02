# AGENTS.md

## 1. Repository purpose

This is a personal dotfiles repository for a macOS/Linux developer terminal setup. It manages shell, Git, tmux, Starship prompt, Homebrew packages, and daily CLI workflows.

The repo uses GNU Stow to symlink dotfile packages into `$HOME`. Homebrew packages, casks, taps, and VS Code extensions are tracked in `Brewfile`.

## 2. Repository layout

- `README.md`: setup guide, daily workflow cheatsheet, safety notes, and maintenance commands.
- `Brewfile`: Homebrew bundle state.
- `zsh/`: stowed zsh files: `.zshrc`, `.zprofile`, `.zshenv`, `.zlogin`, and Oh My Zsh custom files.
- `zsh/.oh-my-zsh/custom/aliases.zsh`: short command aliases grouped by topic.
- `zsh/.oh-my-zsh/custom/functions.zsh`: workflows that need arguments, checks, branching, confirmations, or multiple commands.
- `zsh/.oh-my-zsh/custom/completions.zsh`: custom completion sources.
- `tmux/.tmux.conf`: tmux prefix, panes, navigation, resizing, reload binding, and status bar.
- `git/.gitconfig`: global Git settings, include rules, and Git aliases.
- `starship/.config/starship.toml`: prompt symbols and module settings.
- `macos/finder/`: optional macOS Finder preference automation; this is not a Stow package.

There is no single tracked bootstrap script. `macos/finder/setup-finder.sh` is a scoped macOS preference script and should not be run automatically unless explicitly requested.

## 3. Setup and common commands

New setup is documented in `README.md`:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install git
git clone git@github.com:Mugilan-Codes/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew install stow
stow zsh
stow tmux
stow git
stow starship
brew bundle --file=~/dotfiles/Brewfile
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
exec zsh
```

Common maintenance commands from the repo:

```sh
brew bundle --file=~/dotfiles/Brewfile
brewcheck
brewoutdated
bdump
dotdoctor
dotlinks
dotstow
reload
rz
rzl
namecheck newname
usedcount existingname
```

There is no single tracked repo bootstrap script. Core setup is currently a sequence of README commands plus zsh helper functions after the dotfiles are loaded. Finder setup is optional under `macos/finder`.

## 4. Editing rules

- Preserve existing style, comments, grouping, and explanatory warnings.
- Prefer small, focused changes over broad rewrites.
- Keep aliases in `aliases.zsh` and logic-heavy helpers in `functions.zsh`.
- Before adding a new alias or function, check for conflicts with `namecheck <name>` when available.
- Use `usedcount <name>` before removing or renaming established shortcuts when available.
- Do not remove comments unless they are wrong or outdated.
- Keep Homebrew changes in `Brewfile`; use existing helpers such as `bdump`, `brewadd`, and `brewrm` when working from an installed shell.

## 5. Shell/zsh conventions

- `.zshenv` is minimal and only for universal environment variables.
- `.zprofile` is for login-shell PATH and toolchain setup.
- `.zshrc` is for interactive shell behavior, Oh My Zsh, plugins, prompt, fzf, zoxide, aliases, functions, and completions.
- `.zlogin` is intentionally empty.
- Aliases are organized with section headers and short comments. Use aliases for direct shortcuts only.
- Functions include usage comments and validation for missing arguments or missing commands where useful.
- PATH changes should be added intentionally, with comments explaining why and with `typeset -U path PATH` preserved.
- Completions belong in `zsh/.oh-my-zsh/custom/completions.zsh` or the configured completion paths noted in `.zshrc`.

## 6. Dotfile safety rules

- Be careful with Stow symlinks. Do not overwrite real user files blindly.
- If a Stow target already exists and is not a symlink, stop and report it instead of replacing it.
- Do not hardcode machine-specific paths unless the repo already does so intentionally and the comment explains the intent.
- Do not commit secrets, API keys, tokens, SSH keys, private credentials, `.env` files, or private machine-only config.
- Do not add destructive commands without clear warnings and confirmation prompts.
- Treat cleanup helpers, Docker volume removal, branch deletion, `git add .` workflows, and Homebrew upgrades as potentially risky.
- Treat `macos/finder` as macOS preference automation: keep backups first, make changes idempotent, and do not run it automatically.

## 7. Validation checklist

Run relevant checks after changes:

```sh
zsh -n zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/.zlogin zsh/.oh-my-zsh/custom/aliases.zsh zsh/.oh-my-zsh/custom/functions.zsh zsh/.oh-my-zsh/custom/completions.zsh
stow --simulate --verbose zsh tmux git starship
brew bundle check --file=./Brewfile
git diff -- README.md Brewfile zsh tmux git starship AGENTS.md
```

Known caveat: the working tree may contain untracked macOS `.DS_Store` files inside stowed directories. If a Stow dry run reports `.DS_Store` conflicts, inspect or remove those metadata files intentionally; do not use `--adopt` blindly.

If working in a shell where these dotfiles are loaded, also run:

```sh
dotdoctor
dotlinks
namecheck newname
```

Potentially destructive or broad commands: `dotstow` changes home-directory symlinks after confirmation, `brewup` upgrades installed packages, `gcommit` stages all changes and pushes, and Docker cleanup helpers may remove local data. Do not auto-run those unless explicitly requested.

## 8. Git workflow expectations

- Show changed files with `git diff` before summarizing work.
- Do not commit automatically unless explicitly asked.
- If asked to commit, keep commits focused and avoid mixing unrelated dotfile changes.
- Explain what changed and why after editing.
- Do not revert unrelated user changes in the working tree.

## 9. Response style for future Codex tasks

- Be concise and practical.
- Mention files changed.
- Mention validation performed.
- Mention anything skipped, uncertain, or blocked.
- Prefer repo-specific observations over generic agent advice.
