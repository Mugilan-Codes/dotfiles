# Dotfiles

Personal Apple Silicon macOS developer setup managed with GNU Stow. Homebrew
startup also supports common Intel macOS and Linuxbrew locations.

## Stow packages

| Package | Installs to | Purpose |
| --- | --- | --- |
| `zsh` | `$HOME/.zsh*`, `$HOME/.oh-my-zsh/custom/*` | Shell, PATH, aliases, functions, completions |
| `tmux` | `$HOME/.tmux.conf` | tmux configuration |
| `git` | `$HOME/.gitconfig` | Global Git configuration |
| `starship` | `$HOME/.config/starship.toml` | Prompt configuration |
| `agents` | `$HOME/.agents/skills`, `$HOME/.claude/skills` | Git-vendored local and approved third-party skills |

The `agents` package must always be stowed with `--no-folding`. This keeps
`$HOME/.agents/skills` and `$HOME/.claude/skills` as real directories so
generated and application-owned entries can coexist with Stow-managed files.

`macos/finder` is optional preference automation, not a Stow package. Run it
only when Finder defaults are intentionally being changed.

## Repository layout

```text
dotfiles/
├── AGENTS.md
├── CLAUDE.md -> AGENTS.md
├── CODEX_USAGE.md
├── Brewfile
├── agents/
│   ├── .agents/skills/
│   ├── .claude/skills/
│   ├── licenses/
│   ├── .stow-local-ignore
│   ├── README.md
│   ├── SKILLS_REGISTRY.md
│   ├── THIRD_PARTY.md
│   ├── skills-lock.json
│   └── skills.conf
├── scripts/agent-skills
├── git/
├── macos/finder/
├── starship/
├── tmux/
└── zsh/
```

## New-machine setup

Install Homebrew, Git, and GNU Stow:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install git stow
```

Clone the repository:

```sh
git clone git@github.com:Mugilan-Codes/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
```

Install Oh My Zsh and the plugins enabled by `.zshrc` if needed:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] ||
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] ||
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
```

Back up conflicting real home-directory entries, then simulate and apply:

```sh
stow --target="$HOME" --simulate --verbose zsh tmux git starship
stow --target="$HOME" --simulate --no-folding --verbose agents

stow --target="$HOME" --verbose zsh tmux git starship
stow --target="$HOME" --no-folding --verbose agents
```

Approved skills are reconstructed directly from the committed repository.
Node, npm, the skills CLI, upstream clones, global skill metadata, and network
access are not needed to deploy those committed skills. Node/npm and
project-scoped `skills@latest` are needed only for a future authorized
third-party add or update.

Install Homebrew packages:

```sh
brew bundle --file="$HOME/dotfiles/Brewfile"
```

Validate and start fresh agent sessions:

```sh
scripts/agent-skills status
scripts/agent-skills audit
exec zsh
```

## Agent skill maintenance

Canonical local, forked, and approved third-party contents live under
`agents/.agents/skills`. Relative links under `agents/.claude/skills` expose
the intended subset to Claude Code. Codex reads the Stow-managed
`$HOME/.agents/skills` view; `$HOME/.codex` remains application-managed.

The maintenance wrapper is read-only:

```sh
scripts/agent-skills status
scripts/agent-skills audit
scripts/agent-skills pre-install
scripts/agent-skills post-install
```

To update third-party contents, first run `pre-install`, then work from the
package directory:

```sh
cd "$HOME/dotfiles/agents"
npx skills@latest add mattpocock/skills
npx skills@latest add heredotnow/skill
```

Select project scope, only the allowlisted names in `skills.conf`, Codex, and
Claude Code. Never use `--global` or `--all`. Review every resulting Git diff,
run `post-install` and `audit`, update provenance/licenses when needed, then
simulate Stow before changing runtime links.

The Matt allowlist is a reviewed suite, not an upstream “install all” mirror.
Its setup skill is run separately per application repository when the
issue-tracker/spec/ticket workflow is wanted; it is not part of dotfiles
deployment.

Do not run `skills update --help` to inspect help: the audited CLI handled
that command as an update. Use the task-specific prompt and an isolated
fixture for CLI inspection.

Generated `framer-project-*` skills remain private machine-local real
directories and are never committed. Credentials, sessions, caches,
databases, and broad Codex/Claude application state are also excluded.

Plugins and application-managed skills are intentionally outside dotfiles
ownership. Install and manage them through Codex or Claude Code. This
repository does not inventory, reproduce, or configure their state.

See [agents/README.md](agents/README.md) for the canonical operating-guide
index, including the [skill decision guide](agents/SKILLS_GUIDE.md),
[requirements](agents/REQUIREMENTS.md), and
[troubleshooting](agents/TROUBLESHOOTING.md). Start agent-configuration work
from the reusable
[prompt library](prompts/agent-config/README.md) or its human-facing index in
[CODEX_USAGE.md](CODEX_USAGE.md).

## Verification

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
bash -n scripts/agent-skills
zsh -n zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/.zlogin \
  zsh/.oh-my-zsh/custom/aliases.zsh \
  zsh/.oh-my-zsh/custom/functions.zsh \
  zsh/.oh-my-zsh/custom/completions.zsh
scripts/agent-skills status
scripts/agent-skills audit
stow --target="$HOME" --simulate --verbose zsh tmux git starship
stow --target="$HOME" --simulate --no-folding --verbose agents
brew bundle check --no-upgrade --file=./Brewfile
```

`brewup`, cleanup helpers, Docker volume removal, Git staging/commit helpers,
Stow changes, third-party installer runs, and Finder automation are mutating
operations. Run them intentionally.
