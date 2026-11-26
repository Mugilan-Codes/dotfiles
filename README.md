# Dotfiles

Personal Apple Silicon macOS developer setup managed with GNU Stow. Homebrew
startup also supports common Intel macOS and Linuxbrew locations.

## Stow packages

| Package | Installs to | Purpose |
| --- | --- | --- |
| `zsh` | `$HOME/.zsh*`, `$HOME/.oh-my-zsh/custom/*` | Shell, PATH, aliases, functions, completions |
| `tmux` | `$HOME/.tmux.conf` | tmux configuration |
| `git` | `$HOME/.gitconfig`, `$HOME/.gitignore-global` | Global Git configuration |
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
├── Brewfile, Brewfile.core
├── install.sh, shell-sources.json
├── docs/RECOVERY.md
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
├── scripts/                 # Deployment and skill maintenance
├── tests/test_regressions.py
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
or hook.

## Daily maintenance

- Use `./install.sh --check` to verify the core setup and
  `brewcheck` to compare optional inventory.
- Use `bdump` to preview a replacement of the optional Brewfile.
  `brewadd PACKAGE` and `brewrm PACKAGE` change installed packages first,
  then open that inventory review. Edit `Brewfile.core` separately when a
  shell or recovery dependency changes. Review tap and trust changes before
  saving any dump.
- Leave Node and Java version selection to FNM and SDKMAN. Use project pins
  for Flutter via FVM and isolated Python environments for project libraries.
- The Oh My Zsh Git plugin loads before the personal overrides. Here `ga`
  stages the current tree, `gclean` runs the branch-cleanup helper, and
  `gbcopy` uses the personal clipboard helper.

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

The Apple Silicon GitHub Actions job runs syntax checks, offline regression
fixtures and the skill audit in a hosted runner. For local work, start with
the isolated deployment in [the recovery guide](docs/RECOVERY.md).

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
./install.sh --dry-run
./install.sh --check
scripts/agent-skills check --source-only
```

`brewup`, cleanup helpers, Docker volume removal, Git staging/commit helpers,
Stow changes, third-party installer runs, and Finder automation are mutating
operations. Run them intentionally.
