# Agent skills Stow package

The `agents` directory is a GNU Stow package and the source of truth for
global Codex instructions, locally owned skills, intentional forks, and
approved vendored third-party skills.

## Operating-guide index

- [SKILLS_GUIDE.md](SKILLS_GUIDE.md): per-skill selection, invocation,
  requirements, writes, and risk.
- [REQUIREMENTS.md](REQUIREMENTS.md): global, optional, project-specific, and
  agent-capability checks.
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md): discovery, Stow, lock, and
  recovery procedures.
- [SKILLS_REGISTRY.md](SKILLS_REGISTRY.md) and
  [THIRD_PARTY.md](THIRD_PARTY.md): exact inventory and provenance.

Plugins and application-managed skills are intentionally outside dotfiles
ownership. Install and manage them through Codex or Claude Code. This
repository does not inventory, reproduce, or configure their state. Portable
custom user skills belong under `agents/.agents/skills`; do not copy
application-managed skill directories into this repository.

## Package tree

```text
agents/
├── .codex/
│   └── AGENTS.md
├── .agents/
│   └── skills/
│       └── <tracked-skill>/
├── .claude/
│   └── skills/
│       └── <tracked relative symlink>
├── licenses/
├── .stow-local-ignore
├── README.md
├── SKILLS_REGISTRY.md
├── THIRD_PARTY.md
├── skills-lock.json
└── skills.conf
```

Stow ignores the package documentation, configuration, lock, licenses, and
temporary metadata. It deploys only `.agents/skills` and `.claude/skills`.

## Ownership categories

| Category | Source of truth | Update method |
| --- | --- | --- |
| Local | `agents/.agents/skills/<name>` | Edit locally |
| Intentional fork | Tracked skill plus registry/provenance/license records | Manual upstream review |
| Approved third-party | Tracked skill plus `skills.conf` and `skills-lock.json` | Project-scoped `skills@latest add` |
| Codex-only local | Tracked canonical skill with no static Claude link | Edit locally |
| Generated Framer | Real `$HOME/.agents/skills/framer-project-*` directory | Regenerate through an authorized Framer workflow |

Both local and approved third-party contents are committed. A new machine
reconstructs the reviewed baseline from Git and Stow without contacting an
upstream installer.

## New-machine bootstrap

After cloning the repository, create no per-skill runtime state manually.
Simulate first, then apply:

```sh
stow --target="$HOME" --simulate --verbose zsh tmux git starship
stow --target="$HOME" --simulate --no-folding --verbose agents
stow --target="$HOME" --verbose zsh tmux git starship
stow --target="$HOME" --no-folding --verbose agents
scripts/agent-skills status
scripts/agent-skills audit
```

Committed skills require no Node, npm, network, upstream clone, skills CLI, or
global skills metadata. Codex/Claude application state is not restored, and
generated Framer project skills are regenerated separately.

## Stow behavior

The runtime parents must be real directories:

```text
$HOME/.agents/skills
$HOME/.claude/skills
```

`$HOME/.codex` also remains a real application-owned directory; Stow manages
only its `AGENTS.md` file.

Always use:

```sh
stow --target="$HOME" --simulate --no-folding --verbose agents
stow --target="$HOME" --no-folding --verbose agents
```

With GNU Stow 2.4.1, `--no-folding` creates real runtime skill directories
and links their files individually into the tracked package. Static Claude
entries are themselves tracked relative symlinks. Do not use `--adopt`, and
do not replace either runtime parent with a whole-directory link.

Generated Framer directories and their Claude runtime links coexist with the
Stow package and must survive every restow.

## Configuration and validation

`skills.conf` is data-only shell configuration. It declares:

- `skills@latest`
- package and tracked roots
- required Stow mode
- installer targets
- explicit Matt Pocock and here-now allowlists
- local, forked, and Codex-only names
- executable paths
- the generated runtime exclusion

The wrapper is read-only:

```sh
scripts/agent-skills status
scripts/agent-skills audit
scripts/agent-skills pre-install
scripts/agent-skills post-install
```

`status` requires no Node, npm, or network. It validates configured
directories, frontmatter, references, executable modes, static Claude links,
private-state exclusions, registry consistency, deployed Stow file targets,
generated state, and independent Codex collisions.

`audit` adds project-lock hashes/sources, licenses, provenance, and deeper
runtime observation. Before cutover it can validate repository state while
reporting that runtime deployment is pending.

`pre-install` prints the exact package directory, sources, selections, targets,
worktree state, and backup guidance. `post-install` reports Git-visible
changes and validates the resulting package without rewriting it.

## Third-party add/update lifecycle

1. Audit the source, selected names, dependencies, license, and upstream
   revision.
2. Create an external backup when existing state is ambiguous.
3. Run `scripts/agent-skills pre-install`.
4. Change to the package directory:

   ```sh
   cd "$HOME/dotfiles/agents"
   ```

5. Run the official source flow:

   ```sh
   npx skills@latest add mattpocock/skills
   npx skills@latest add heredotnow/skill
   ```

6. Select project scope, only the configured allowlist, Codex, and Claude
   Code. Never use `--global`, `-g`, or `--all`.
7. After each source, inspect status, added/deleted files, mode changes,
   relative Claude links, and `skills-lock.json`.
8. Run `scripts/agent-skills post-install` and `audit`.
9. Update registry, provenance, and licenses. Record the resolved CLI version
   and the observed upstream revision without claiming an unverified
   immutable pin.
10. Simulate Stow before applying runtime changes.

The CLI recreates installed directories, so upstream deletions become visible
as Git deletions. Its remove operation may leave stale project-lock entries;
review and reconcile those entries explicitly.

The approved Matt suite includes user-invoked orchestration
(`grill-with-docs`, `handoff`, `improve-codebase-architecture`,
`setup-matt-pocock-skills`, `teach`, `to-spec`, `to-tickets`, and
`writing-great-skills`) plus model-invoked disciplines (`code-review`,
`codebase-design`, `diagnosing-bugs`, `domain-modeling`, `grilling`,
`prototype`, `research`, and `tdd`). The authoritative operational list is
always `MATT_SKILLS` in `skills.conf`.

This is intentionally a practical subset. It omits the full-suite router,
standalone grilling alias, commit-driving implementation wrapper, issue/PR
triage state machine, and large-project wayfinding map. Use ordinary Codex
tasks to implement tickets produced by `to-tickets`.

Run `setup-matt-pocock-skills` once per application repository that will use
the issue-tracker planning flow. It may create `docs/agents/issue-tracker.md`,
`docs/agents/triage-labels.md`, and `docs/agents/domain.md`, and update an
existing `AGENTS.md` or `CLAUDE.md` with pointers. Review that proposed edit
carefully in policy-heavy repositories; installing the suite does not
authorize running setup.

Do not run `skills update --help` merely to inspect help. The audited CLI
handled that command as an update. Use an isolated fixture for CLI inspection.

## Self-service workflows

Edit an existing skill only at its canonical source:

```sh
$EDITOR "$HOME/dotfiles/agents/.agents/skills/<skill>/SKILL.md"
scripts/agent-skills status
scripts/agent-skills audit
```

Editing an already-linked file is immediately visible through Stow. Adding a
new support file may require a simulated and separately authorized restow
because `--no-folding` deploys file-level links.

Use prompts 05, 02, 03, 04, 07, 08, 11, and 12 respectively to add a local
skill, install selected third-party skills, update the Matt allowlist, update
`here-now`, remove a skill, maintain documentation, review and commit, or
recover a failed installer. The linked prompt index below is authoritative.

For third-party installation, run `pre-install`, change to
`$HOME/dotfiles/agents`, and invoke `npx skills@latest add <SOURCE>`. Use
project scope, explicit skills, and explicit Codex/Claude targets; never use
`--global` or `--all`. Inspect every Git and lock change, scripts, executable
modes, registry/provenance/licence updates, then run `post-install`, `status`,
and `audit`. Simulate Stow before any separately authorized application.

Matt updates are limited to `MATT_SKILLS` in `skills.conf`; adding another
upstream name requires explicit approval. Preserve and reapply the documented
`to-tickets` adaptation. There is no install-all workflow.

## Local and fork protection

Third-party selections must never overlap `LOCAL_SKILLS` or
`LOCAL_FORK_SKILLS`. Do not use the installer to manage a local name. A fork
requires attribution and a record of local changes before it is treated as
authoritative repository source.

`staged-change-reviewer` is Codex-only because its package includes
Codex-specific OpenAI interface metadata. It intentionally has no tracked
Claude compatibility link.

## Generated and application-managed boundary

Never copy or track generated `framer-project-*` state, runtime lock/state
files, credentials, sessions, logs, caches, databases, or application-managed
skill directories. Do not inspect or reproduce application-managed skill or
plugin inventories as part of dotfiles maintenance.

The only normal runtime paths managed by this package are `.codex/AGENTS.md`
and the approved skill views under `.agents/skills` and `.claude/skills`.

## Troubleshooting and recovery

If Stow reports a conflict:

1. Stop before applying.
2. Inspect the entry with `stat`, `readlink`, and `realpath`.
3. Compare it with the repository and `skills-lock.json`.
4. Preserve ambiguous state under `/private/tmp` outside the repository.
5. Remove only a proven obsolete approved entry; never clear an entire
   runtime parent.
6. Repeat simulation.

If a generated Framer entry is affected, stop. It is not an approved package
target.

For rollback, keep any scoped backup from an add/update operation until its
diff, validation, commit, and runtime review are complete. Unstow only the
`agents` package with the same `--no-folding` mode, then restore scoped runtime
entries from the backup if required. GNU Stow may retain empty skill
directories after removing their managed links; do not broadly delete them. A
later restow safely reuses them.

## Everyday workflow prompts

Complete prompts live under
[`prompts/agent-config`](../prompts/agent-config/README.md). Paste a prompt's
full contents into a disconnected Codex session.

| Workflow | Prompt |
| --- | --- |
| Read-only status/topology audit | [01 — audit configuration](../prompts/agent-config/01-audit-agent-configuration.md) |
| Install selected third-party skills | [02 — install selected skills](../prompts/agent-config/02-install-third-party-skills.md) |
| Update the configured Matt allowlist | [03 — update Matt skills](../prompts/agent-config/03-update-matt-pocock-skills.md) |
| Update `here-now` and review scripts/modes | [04 — update here-now](../prompts/agent-config/04-update-here-now.md) |
| Add a locally authored skill | [05 — add local skill](../prompts/agent-config/05-add-local-skill.md) |
| Record and protect an intentional fork | [06 — fork a skill](../prompts/agent-config/06-fork-third-party-skill.md) |
| Remove a skill and stale lock references | [07 — remove safely](../prompts/agent-config/07-remove-skill-safely.md) |
| Reconcile registry, provenance, licence, links, and modes | [08 — maintain skills and docs](../prompts/agent-config/08-maintain-skills-and-docs.md) |
| Recover from an installer failure | [12 — recover failed install](../prompts/agent-config/12-recover-failed-install.md) |

For a runtime restow, always simulate the exact package first, preserve real
parent directories and generated entries, then apply only with separate
runtime authority:

```sh
stow --target="$HOME" --simulate --no-folding --verbose agents
stow --target="$HOME" --no-folding --verbose agents
scripts/agent-skills status
```

Only [prompt 11](../prompts/agent-config/11-review-and-commit.md) authorizes
routine staging and one commit. No lifecycle prompt authorizes an automatic
push.
