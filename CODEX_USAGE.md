# Codex usage

Practical guidance and the primary index for reusable agent-configuration
prompts in this repository.

Detailed operations live in [agents/README.md](agents/README.md): use
[SKILLS_GUIDE.md](agents/SKILLS_GUIDE.md) to choose a skill,
[REQUIREMENTS.md](agents/REQUIREMENTS.md) to verify prerequisites,
[PLUGINS_GUIDE.md](agents/PLUGINS_GUIDE.md) for host-supported plugin
management, and [TROUBLESHOOTING.md](agents/TROUBLESHOOTING.md) for recovery.

## Instruction and skill discovery

`AGENTS.md` is canonical repository policy. `CLAUDE.md` is a relative symlink
to it so Codex and Claude Code receive the same durable repository-level
instructions. Codex discovers applicable `AGENTS.md` files from the repository
hierarchy; always read the one governing the paths being changed.

All repository-owned and approved third-party skill contents are Git-tracked
under `agents/.agents/skills`. GNU Stow exposes them under
`$HOME/.agents/skills`; static relative links under
`agents/.claude/skills` expose the intended subset to Claude Code.

Do not duplicate these skills under `$HOME/.codex/skills`. `$HOME/.codex`
remains application-managed except when a specifically reviewed local skill
is being migrated into the canonical Stow package.

The `agents` package must use `stow --no-folding`. This keeps
`$HOME/.agents/skills` and `$HOME/.claude/skills` as real directories while
Stow exposes tracked content through file-level links. Generated
`framer-project-*` entries remain private runtime-only state.

## Authority boundaries

Treat these as independent permissions:

- audit or report
- edit repository files
- run a third-party installer
- apply or remove Stow links
- stage
- commit
- push
- deploy or publish

Editing files does not authorize installation, Stow, staging, commits, or
external publication. Preserve unrelated worktree changes.

## Start a new session safely

1. Begin in the repository and let Codex read `AGENTS.md`.
2. Inspect branch, HEAD, upstream, and
   `git status --short --untracked-files=all`.
3. State whether the request is audit-only, permits repository edits, permits
   an installer, permits runtime/Stow changes, or permits staging/commit.
4. Paste the complete task prompt from
   [`prompts/agent-config`](prompts/agent-config/README.md). A disconnected
   session may not have enough context if only a filename is referenced.
5. Supply a valid YAML handoff when continuing work so completed audits are
   not repeated.

## Agent-skill audit

Use the read-only validator:

```sh
scripts/agent-skills status
scripts/agent-skills audit
```

`status` validates repository ownership and the deployed Stow runtime without
Node, npm, or network access. `audit` adds project-lock, license, provenance,
and deeper consistency checks.

## Local skill changes

Add or edit local source only under:

```text
agents/.agents/skills/<name>
```

Update `agents/skills.conf`, `agents/SKILLS_REGISTRY.md`, and, for a fork,
`agents/THIRD_PARTY.md` plus the relevant license record. Create a relative
Claude link only when the skill is intentionally Claude-compatible.

Run repository validation and Stow simulation before applying runtime
changes:

```sh
scripts/agent-skills audit
stow --target="$HOME" --simulate --no-folding --verbose agents
```

## Third-party add or update

First inspect the current worktree and preflight:

```sh
scripts/agent-skills pre-install
```

Then run the official installer from exactly the package directory:

```sh
cd "$HOME/dotfiles/agents"
npx skills@latest add mattpocock/skills
npx skills@latest add heredotnow/skill
```

Requirements:

- use project scope
- never use `--global` or `-g`
- select only names allowlisted in `skills.conf`
- select Codex and Claude Code
- do not select all skills
- protect local/forked names from overwrite
- record the resolved CLI version in the update report

Do not run `skills update --help`; the audited CLI treated it as an update.
Inspect CLI behavior in an isolated fixture and use `skills@latest` only for
an authorized add/update from `dotfiles/agents`.

Committed skill contents and `skills-lock.json`, not the mutable
`skills@latest` resolution, are the reproducible artifacts.

After each source:

```sh
git status --short --untracked-files=all
git diff --summary
scripts/agent-skills post-install
scripts/agent-skills audit
```

Review additions, deletions, mode changes, lock changes, relative references,
source metadata, attribution, and licenses. The installer may recreate an
existing vendored directory. Its remove command may leave a stale project
lock entry, which must be reviewed and reconciled explicitly.

## Runtime cutover or restow

The real parent directories must remain in place. Generated
`framer-project-*` directories and their runtime Claude links are not Stow
package contents.

```sh
stow --target="$HOME" --simulate --no-folding --verbose agents
stow --target="$HOME" --no-folding --verbose agents
scripts/agent-skills status
```

With GNU Stow 2.4.1 and `--no-folding`, runtime skill directories are real
directories containing file-level links into the repository. Never use
`--adopt`.

## Copy-paste prompt index

| Task | Prompt |
| --- | --- |
| Audit tracked and runtime agent configuration | [01 — audit agent configuration](prompts/agent-config/01-audit-agent-configuration.md) |
| Install selected third-party skills | [02 — install third-party skills](prompts/agent-config/02-install-third-party-skills.md) |
| Audit and update the configured Matt Pocock suite | [03 — update Matt Pocock skills](prompts/agent-config/03-update-matt-pocock-skills.md) |
| Update `here-now` | [04 — update here-now](prompts/agent-config/04-update-here-now.md) |
| Add a locally authored skill | [05 — add a local skill](prompts/agent-config/05-add-local-skill.md) |
| Make a deliberate local fork | [06 — fork a third-party skill](prompts/agent-config/06-fork-third-party-skill.md) |
| Remove one skill and reconcile references | [07 — remove a skill safely](prompts/agent-config/07-remove-skill-safely.md) |
| Reconcile skills, metadata, and docs | [08 — maintain skills and docs](prompts/agent-config/08-maintain-skills-and-docs.md) |
| Reassess safely trackable `.codex` config | [09 — audit Codex trackable config](prompts/agent-config/09-audit-codex-trackable-config.md) |
| Test a disposable clean-machine bootstrap | [10 — validate a new machine](prompts/agent-config/10-validate-new-machine.md) |
| Perform final review, staging, and one commit | [11 — review and commit](prompts/agent-config/11-review-and-commit.md) |
| Diagnose a failed installer without destructive rollback | [12 — recover a failed install](prompts/agent-config/12-recover-failed-install.md) |

Common choices:

- Add an upstream skill with prompt 02.
- Audit upstream changes, selection, and update the Matt suite with prompt 03.
- Track a skill you wrote with prompt 05.
- Diagnose a failed update with prompt 12.
- Stage and commit only with prompt 11.

## Recommended workflow

1. Audit or preflight with prompt 01 and the wrapper.
2. Make one scoped change with prompts 02–07.
3. Reconcile metadata and docs with prompt 08.
4. Validate clean-machine reproduction with prompt 10 when topology changes.
5. Use prompt 11 for the final diff review and separately authorized commit.

No prompt authorizes an automatic push. Never install globally, run the
installer outside `dotfiles/agents`, track generated Framer state, or Stow all
of `.codex`.
