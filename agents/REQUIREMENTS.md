# Tracked skill requirements

Snapshot audited on 2026-07-10. States describe this machine without printing
credential values. Re-run the commands rather than treating this snapshot as
permanent.

## Global requirements

| Requirement | Used by | State | Verify | Setup action (do not run during an audit) |
| --- | --- | --- | --- | --- |
| Git | Repository and review skills | SATISFIED (2.55.0) | `git --version` | `brew install git` |
| GNU Stow | Runtime deployment | SATISFIED (2.4.1) | `stow --version` | `brew install stow` |
| Node/npm/npx | Skill installer and Framer | SATISFIED (Node 24.18.0/npm 11.16.0) | `node --version; npm --version; npx --version` | Install through the preferred Node manager |
| GitHub CLI | GitHub tracker workflows | SATISFIED | `gh --version; gh auth status` | `brew install gh`, then interactive login |
| GitLab CLI | GitLab tracker workflows only | MISSING / OPTIONAL | `command -v glab` | `brew install glab`, then interactive login |
| curl/file/jq | `here-now` scripts | SATISFIED | `command -v curl file jq` | Install the missing binary with the OS package manager |
| Bash/Zsh | Validators and shell package | SATISFIED | `bash --version; zsh --version` | OS/package-manager specific |

`npx skills@latest` needs network access and resolves a mutable CLI version.
It is needed only during an explicitly authorized third-party add/update. The
last audited resolution was 1.5.15; committed skill contents are the
reproducible artifact. Never run `skills update --help` on live state.

## Optional and use-time requirements

| Requirement | Used by | State | Verify / action |
| --- | --- | --- | --- |
| here.now account key | Permanent publishing/account operations | OPTIONAL, not set | `test -n "${HERENOW_API_KEY:-}"` or inspect `~/.herenow/credentials` without printing it; follow the skill’s interactive authorization flow |
| here.now Drive token | Scoped Drive sharing | OPTIONAL, not set | `test -n "${HERENOW_DRIVE_TOKEN:-}"`; obtain a narrowly scoped, short-lived token when needed |
| Browser/Playwright | UI reproduction and previews | OPTIONAL; agent capability available, project package varies | `command -v playwright` and inspect the project package manifest |
| Network | `research`, `framer`, `framer-code-components`, `here-now`, remote tracker flows | REQUIRED AT USE | Perform a harmless service-specific status request when authorized |
| Framer account/project permission | `framer`, `framer-code-components` | ACCOUNT/PROJECT-SPECIFIC | Use the Framer CLI's authenticated project listing when authorized; sign in through Framer |
| GitHub/GitLab authentication | `setup-matt-pocock-skills`, `to-spec`, `to-tickets` remote tracker flows | ACCOUNT-SPECIFIC | `gh auth status` or `glab auth status`; use interactive CLI login |

## Project-specific requirements

These are not globally missing when absent from this dotfiles repository.

| Requirement | Required by | State | Verify | Setup action |
| --- | --- | --- | --- | --- |
| Repository `AGENTS.md`/`CLAUDE.md` | Consistent project policy | PROJECT-SPECIFIC | `find .. -name AGENTS.md -o -name CLAUDE.md` | Create project instructions intentionally |
| `docs/agents/issue-tracker.md` | `code-review`, `to-spec`, `to-tickets` | PROJECT-SPECIFIC | `test -f docs/agents/issue-tracker.md` | Run `setup-matt-pocock-skills` in that repo after review |
| `docs/agents/triage-labels.md` | Tracker publication | PROJECT-SPECIFIC | `test -f docs/agents/triage-labels.md` | Same setup workflow |
| `docs/agents/domain.md` | Planning vocabulary pointer | PROJECT-SPECIFIC | `test -f docs/agents/domain.md` | Same setup workflow |
| `CONTEXT.md` | Domain vocabulary; optional for debugging/TDD | OPTIONAL/PROJECT-SPECIFIC | `find . -name CONTEXT.md -print` | Create lazily when a term is resolved |
| `docs/adr/` | Durable architectural decisions | OPTIONAL/PROJECT-SPECIFIC | `test -d docs/adr` | Create lazily for the first justified ADR |
| Test/build command | TDD, bug diagnosis, prototype | PROJECT-SPECIFIC | Inspect `package.json`, Gradle/Maven files, Flutter config, and project docs | Install project dependencies using its documented manager |
| Writable temporary directory | Harnesses/prototypes | SATISFIED for `/private/tmp` | `test -w /private/tmp` | Fix permissions or choose a project-approved temp path |

## Agent capabilities

Parallel/background agents are required by `code-review` and strongly used by
`research` and optional design exploration. They are available in the current
Codex environment; support in Claude Code or another host is version and
policy dependent. Browser, image, terminal, and network capabilities are also
host-dependent and should be reported as `UNKNOWN` until exercised in the
actual session.

## Standard checks

```sh
scripts/agent-skills status
scripts/agent-skills audit
command -v git gh glab node npm npx curl file jq stow
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Absence of optional, project-specific, account-specific, or agent-capability
requirements does not block general tracked-skill validation. The validator
intentionally does not fail for optional credentials, project-specific files,
external services, or agent features. That keeps it offline, portable, and
truthful.
