# Dotfiles

Personal Apple Silicon macOS developer setup managed with GNU Stow plus a
separate agent-skill manager.

The shell and application configuration is primarily macOS-oriented.
Homebrew startup also detects common Intel macOS and Linuxbrew locations.

## Stow Packages

| Package | Installs To | Purpose |
| --- | --- | --- |
| `zsh` | `$HOME/.zshrc`, `$HOME/.zprofile`, `$HOME/.zshenv`, `$HOME/.zlogin`, `$HOME/.oh-my-zsh/custom/*` | Shell, PATH, aliases, functions, completions |
| `tmux` | `$HOME/.tmux.conf` | tmux configuration |
| `git` | `$HOME/.gitconfig` | Global Git configuration |
| `starship` | `$HOME/.config/starship.toml` | Prompt configuration |

`agents` is not a Stow package. Local skills, third-party skill declarations,
and their manager live in `agents/` and `scripts/agent-skills`.

`macos/finder` is optional preference automation. It is not a Stow package
and should run only when Finder defaults are intentionally being changed.

## Repository Layout

```text
dotfiles/
├── AGENTS.md
├── CLAUDE.md -> AGENTS.md
├── CODEX_USAGE.md
├── Brewfile
├── agents/
│   ├── README.md
│   ├── SKILLS_REGISTRY.md
│   ├── THIRD_PARTY.md
│   ├── skills.conf
│   └── skills/
├── scripts/
│   └── agent-skills
├── git/
├── macos/finder/
├── starship/
├── tmux/
└── zsh/
```

## New Machine Setup

Install Homebrew, Git, GNU Stow, and Node.js/npm. The `skills` CLI runs
through pinned `npx`; it is not globally installed.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install git stow fnm
fnm install --lts
fnm default lts-latest
```

Clone the repository:

```sh
git clone git@github.com:Mugilan-Codes/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
```

Install Oh My Zsh and the plugins enabled by `.zshrc` if they are not already
present:

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

Back up any existing real shell/config files, then preview and apply Stow:

```sh
stow --simulate --verbose zsh tmux git starship
stow --verbose zsh tmux git starship
```

Install Homebrew packages:

```sh
brew bundle --file="$HOME/dotfiles/Brewfile"
```

Install agent skills only after reviewing the read-only plan:

```sh
scripts/agent-skills plan
scripts/agent-skills install
scripts/agent-skills status
```

A local clone of `mattpocock/skills` is not required. Restart the shell and
start fresh Codex/Claude Code sessions after the initial skill installation:

```sh
exec zsh
```

## Agent Skill Management

The manager pins `skills@1.5.14`, uses global scope and symlink mode, and
targets Codex plus Claude Code. It installs only the allowlists in
`agents/skills.conf`.

```sh
scripts/agent-skills plan
scripts/agent-skills install
scripts/agent-skills status
scripts/agent-skills update
scripts/agent-skills unlink-local
```

- `plan` is read-only and shows missing items, collisions, stale/broken links,
  and proposed changes.
- `install` reconciles missing allowlisted third-party skills and individual
  local links without overwriting collisions.
- `status` validates CLI source records, content hashes, frontmatter,
  references, links, and discovery paths.
- `update` explicitly updates only configured third-party names.
- `unlink-local` removes only manifest-owned local symlinks.

Do not use `@latest` or `--all` in repository-managed commands.

### Add a local skill

1. Create `agents/skills/<name>/SKILL.md`.
2. Add the name to `LOCAL_SKILLS` in `agents/skills.conf`.
3. Record ownership and provenance in `agents/SKILLS_REGISTRY.md`; add
   attribution to `agents/THIRD_PARTY.md` if it is a fork.
4. Run `scripts/agent-skills plan`, then `install` when authorized.

### Add a third-party skill

1. Verify the repository license and selectable skill name with the pinned
   CLI's `add <source> --list` operation.
2. Add the source and explicit name to `agents/skills.conf`.
3. Update `agents/SKILLS_REGISTRY.md` and `agents/THIRD_PARTY.md`.
4. Run `plan`, then `install`. Never replace an explicit allowlist with
   `--all`.

### Update third-party skills

```sh
scripts/agent-skills update
```

The wrapper protects local skills and checks for locally modified CLI-managed
contents before update.

### Resolve collisions

If `plan` reports a real directory, regular file, unexpected symlink, or
source mismatch:

1. Stop; do not force installation.
2. Inspect the entry type, resolved target, source record, and contents.
3. Preserve ambiguous state outside the repository.
4. Remove or relocate only the proven obsolete entry.
5. Rerun `plan`.

### Generated Framer project skills

Generated `framer-project-*` skills are private machine-local runtime
directories under `$HOME/.agents/skills`. They are never committed. The
wrapper creates Claude Code compatibility links when needed.

### Bump the pinned CLI deliberately

1. Review the target CLI release and help for `add`, `list`, `remove`, and
   `update`.
2. Change only `SKILLS_CLI_VERSION` in `agents/skills.conf`.
3. Run `scripts/agent-skills plan` and the full validation suite.
4. Update docs if flags or behavior changed.

## Stow Usage

Run Stow from the repository root:

```sh
stow --simulate --verbose zsh tmux git starship
stow --restow --verbose zsh tmux git starship
```

For rollback:

```sh
stow --delete --verbose zsh tmux git starship
```

Stow does not manage agent skills. Do not use `--adopt` unless existing
home-directory files are intentionally being imported into this repository.

## Verification

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
zsh -n zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/.zlogin \
  zsh/.oh-my-zsh/custom/aliases.zsh \
  zsh/.oh-my-zsh/custom/functions.zsh \
  zsh/.oh-my-zsh/custom/completions.zsh
stow --simulate --verbose zsh tmux git starship
scripts/agent-skills plan
scripts/agent-skills status
brew bundle check --no-upgrade --file=./Brewfile
```

Useful loaded-shell diagnostics:

```sh
dotdoctor
dotlinks
namecheck newname
usedcount existingname
```

## Daily Maintenance and Safety

```sh
bdump
brewcheck
brewtrustcheck
brewoutdated
dotstow
gmsg
gcai
reload
rz
rzl
```

`brewup`, cleanup helpers, Docker volume removal, Git staging/commit helpers,
Stow changes, skill installs/updates, and Finder automation are mutating
operations. Run them intentionally. Keep `.DS_Store`, `.env`, keys, tokens,
temporary files, and machine-only state out of Git.
