# CODEX_USAGE.md

How to use Codex with this dotfiles repository.

## Baseline Workflow

Start most sessions with:

```text
Onboard me to this dotfiles repo. Identify the Stow packages, key commands, current Git status, and any risks before changing files.
```

Useful command to ask Codex to run:

```sh
git status --short --untracked-files=all
```

## Common Prompts

Repo onboarding:

```text
Use repo-onboarding to explain this repo's structure, Stow packages, verification commands, and maintenance risks.
```

Staged diff review:

```text
Use staged-diff-review to review only my staged changes before I commit.
```

Skills maintenance:

```text
Use skills-maintainer to audit $HOME/.agents/skills, update SKILLS_GUIDE.md and SKILLS_REGISTRY.md, and report broken references.
```

Adding a new Stow package:

```text
Help me add a new GNU Stow package. Inspect the target home path first, create the package structure, run a Stow simulation, and do not apply or stage changes until I ask.
```

Updating existing dotfiles:

```text
Update my zsh/tmux/git/starship config for this specific change. Keep the edit scoped, preserve comments, and run the relevant syntax and Stow simulation checks.
```

Updating Codex skills:

```text
I changed local Codex skills. Run skills-maintainer, update the guide and registry, replace hard-coded machine paths with $HOME where portable, and run Stow simulation for agents.
```

## Stow Commands

Preview the skills package:

```sh
stow --simulate --verbose agents
```

Apply the skills package:

```sh
stow --verbose agents
```

Preview all Stow packages:

```sh
stow --simulate --verbose zsh tmux git starship agents
```

Check Git state:

```sh
git status --short --untracked-files=all
```

## Recommended Skills Update Flow

After changing skills under `agents/.agents/skills`:

1. Run `skills-maintainer`.
2. Update `agents/.agents/skills/SKILLS_GUIDE.md`.
3. Update `agents/.agents/skills/SKILLS_REGISTRY.md`.
4. Run `stow --simulate --verbose agents`.
5. Review staged changes with `staged-diff-review` if anything is staged.
6. Commit with a focused message after reviewing the diff.

Do not include `.DS_Store`, `.env`, keys, tokens, generated junk, or machine-only files in commits.

## Good Defaults For Codex

- Ask Codex to inspect before editing.
- Ask for small, package-scoped changes.
- Ask Codex to show changed files and validation results.
- Tell Codex whether it may stage, commit, push, or apply real Stow operations.
- Prefer `$HOME` in reusable docs and absolute paths only for machine-specific examples.
