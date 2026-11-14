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
| `agents` | `$HOME/.agents/skills`, `$HOME/.claude/skills`, `$HOME/.codex/AGENTS.md` | Agent instructions and Git-vendored skills |

Before stowing `agents`, keep `$HOME/.agents/skills`,
`$HOME/.claude/skills`, and `$HOME/.codex` as real directories. Ordinary Stow
then links each managed skill directory while generated and application-owned
entries remain siblings outside Stow ownership. Never use `--no-folding` for
the `agents` package because Codex does not discover file-level `SKILL.md`
links inside real skill directories.

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
│   ├── .codex/AGENTS.md
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

## Installation and recovery

```sh
./install.sh --dry-run
./install.sh
./install.sh --check
```

Read [the clean-Mac recovery guide](docs/RECOVERY.md) first for HTTPS cloning
before SSH credentials, CLT/Homebrew prerequisites, conflict backups, rollback,
isolated targets and manual toolchain setup. `Brewfile.core` is required;
`Brewfile` is optional application inventory. This installer targets Apple
Silicon macOS, not the Ubuntu work environment. It never enables an AI proxy
or hook. Do not run the live installer while merely reviewing these changes.

## Agent instructions and skills

[Agent maintenance](agents/README.md) documents the implemented `list`, `check`,
`add`, `add-repo`, `import`, `update`, `record-patch` and `deploy` commands.
The existing Stow/skills structure remains canonical. Personal global
instructions are shared between Codex and Claude through a tracked link;
repository instructions remain scoped here. Portable settings are selectively
restored, while providers, credentials, trust and application state remain local.

```sh
scripts/agent-skills list
scripts/agent-skills check
scripts/agent-skills audit
```

An external skill installer does not automatically capture its result in
Git. Review and explicitly import portable source, or record its external
plugin owner. Uncommitted/unpushed work is not recovery protection.

## Verification

```sh
git status --short --untracked-files=all
git diff --check
git diff --cached --check
python3 -B tests/test_regressions.py
bash -n scripts/agent-skills
bash -n install.sh
(for file in zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/.zlogin \
  zsh/.oh-my-zsh/custom/aliases.zsh \
  zsh/.oh-my-zsh/custom/functions.zsh \
  zsh/.oh-my-zsh/custom/completions.zsh; do
  zsh -f -n "$file" || exit 1
done)
scripts/agent-skills status
scripts/agent-skills audit
stow --target="$HOME" --simulate --verbose zsh tmux git starship
stow --target="$HOME" --simulate --verbose agents
./install.sh --check
scripts/agent-skills check --source-only
```

`brewup`, cleanup helpers, Docker volume removal, Git staging/commit helpers,
Stow changes, third-party installer runs, and Finder automation are mutating
operations. Run them intentionally.
