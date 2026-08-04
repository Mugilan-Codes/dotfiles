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
mkdir -p "$HOME/.agents/skills" "$HOME/.claude/skills" "$HOME/.codex"
stow --target="$HOME" --simulate --verbose zsh tmux git starship
stow --target="$HOME" --simulate --verbose agents
stow --target="$HOME" --verbose zsh tmux git starship
stow --target="$HOME" --verbose agents
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

After confirming the runtime parents above are real directories, use:

```sh
stow --target="$HOME" --simulate --verbose agents
stow --target="$HOME" --verbose agents
```

Ordinary Stow folds each direct managed skill child into a directory symlink.
Static Claude entries are themselves tracked relative symlinks. Do not use
`--no-folding` or `--adopt`, and do not replace either runtime parent with a
whole-directory link.

Generated Framer directories and their Claude runtime links coexist with the
Stow package and must survive every restow.

## Configuration and validation

`skills.conf` is data-only shell configuration. It declares:

- `skills@latest`
- package and tracked roots
- required Stow mode
- installer targets
- explicit Matt Pocock, here-now, and Taste allowlists
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
private-state exclusions, registry consistency, deployed directory targets,
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
   npx skills@latest add Leonxlnx/taste-skill
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

`design-taste-frontend` is a separate contextual frontend skill for landing
pages, portfolios, and redesigns. After a fresh agent session discovers it,
the model may load it when the task matches that description or when the user
invokes it. It has no watcher, hook, executable, or background process, and
its design rules do not apply to every task.

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

### Use an installed skill

Invoke the current installed copy by name, for example:

```text
$design-taste-frontend
```

Invocation does not install or update anything. Likewise, invoking a name
that is not installed, such as `$new-skill-name`, does not install it.

### Check for upstream updates

The currently recorded `skills` CLI 1.5.21 has no `check` command. Do not run
`npx skills check` or use the mutating `update` command as a read-only check.
Use `$skills-maintainer` to inspect configured upstream sources and compare
their available revisions with `skills.conf`, `skills-lock.json`, and the
vendored copies. Validate current local state separately:

```sh
cd "$HOME/dotfiles"
scripts/agent-skills status
scripts/agent-skills audit
```

The repository-native commands validate the committed inventory, provenance,
hashes, links, and runtime topology without checking the network. Upstream
comparison must include locally authored skills and intentional forks as
separate ownership classes; no installer command covers `loopy`, `framer`, or
`framer-code-components`.

### Update existing third-party skills

Prefer this high-level request:

```text
$skills-maintainer

Check all managed skills for upstream updates. Show the source, current
version/hash, available version/hash and meaningful diff before changing
anything. Preserve local forks. Update canonical repository copies, licences,
registry and lock records, validate directory-level deployment, and do not
commit until the diff has been reviewed.
```

For entries managed by the current project lock, the installer command is:

```sh
cd "$HOME/dotfiles/agents"
npx skills update
```

Run it only after `scripts/agent-skills pre-install` and explicit installer
authorization. It updates installer-managed lock entries only; it does not
supersede local-fork protection, licence/provenance maintenance, complete Git
diff review, or `scripts/agent-skills post-install`, `status`, and `audit`.

To update Taste only, use the upstream source and explicit name from the
canonical package directory:

```sh
scripts/agent-skills pre-install
cd "$HOME/dotfiles/agents"
npx skills add \
  https://github.com/Leonxlnx/taste-skill \
  --skill design-taste-frontend
cd ..
scripts/agent-skills post-install
scripts/agent-skills audit
```

Do not run this merely to invoke Taste. `pre-install` prints the canonical
installer directory and approved selection; project scope writes the reviewed
copy under `agents/.agents/skills`, and `post-install` rejects a lock/source
mismatch. Runtime discovery continues to use Stow's directory link to that
canonical copy.

Update an intentional local fork manually: inspect its documented upstream,
compare revisions and meaningful content changes, preserve the recorded local
delta, then update its licence, provenance, registry, and validation results.
Never pass `loopy` or another fork to `npx skills update` or `add`.

### Add a new third-party skill

Prefer this request:

```text
$skills-maintainer

Install the following third-party skill into my dotfiles-managed skill system:

<repository URL>

Requirements:
- inspect the source before installation;
- identify the exact skill name;
- review instructions, scripts and referenced resources for unsafe behavior;
- record source, version/hash and licence;
- install into the canonical repository;
- preserve directory-level runtime symlinks;
- update registry, lock files and documentation;
- validate Codex and Claude discovery where applicable;
- show the complete diff before committing;
- do not overwrite local forks or unmanaged skills.
```

Use [prompt 02](../prompts/agent-config/02-install-third-party-skills.md) when
a reusable, source-specific installation procedure is needed. Run the
installer only from `dotfiles/agents`, in project scope, with the exact skill
name and agents. Review the full result before any commit.

### Remove or rediscover a skill

Use [prompt 07](../prompts/agent-config/07-remove-skill-safely.md) to remove a
skill. It reconciles the allowlist, lock, licence, provenance, registry,
tracked Claude link, and runtime simulation without touching unmanaged
siblings. After any add, update, or removal, validate the directory links and
start a fresh Codex or Claude Code session; an existing session may retain its
prior discovery snapshot.

Edit an existing skill only at its canonical source:

```sh
$EDITOR "$HOME/dotfiles/agents/.agents/skills/<skill>/SKILL.md"
scripts/agent-skills status
scripts/agent-skills audit
```

Editing or adding files under a tracked skill is immediately visible through
its directory symlink; no per-file restow is required.

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
`agents` package, then restore scoped runtime entries from the backup if
required. Never broadly delete either runtime parent or any generated entry.

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
| Full audit and refresh | [13 — full dotfiles audit and refresh](../prompts/agent-config/13-full-dotfiles-audit-and-refresh.md) |
| Recover from an installer failure | [12 — recover failed install](../prompts/agent-config/12-recover-failed-install.md) |

For a runtime restow, always simulate the exact package first, preserve real
parent directories and generated entries, then apply only with separate
runtime authority:

```sh
mkdir -p "$HOME/.agents/skills" "$HOME/.claude/skills" "$HOME/.codex"
stow --target="$HOME" --simulate --verbose agents
stow --target="$HOME" --verbose agents
scripts/agent-skills status
```

Only [prompt 11](../prompts/agent-config/11-review-and-commit.md) authorizes
routine staging and one commit. No lifecycle prompt authorizes an automatic
push.
