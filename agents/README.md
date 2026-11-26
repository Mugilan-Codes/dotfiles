# Personal AI instructions and skills

Stow deploys approved source; applications own credentials, sessions, caches,
trust, plugins and generated project state. `scripts/agent-skills` is the single
maintenance entry point. Python 3 and Git are needed for maintenance; Stow for
deployment. No external skill script runs during import.

## Instruction map

| Repository source | Global destination | Scope/status |
| --- | --- | --- |
| `agents/.codex/AGENTS.md` | `$CODEX_HOME/AGENTS.md` (normally `~/.codex/AGENTS.md`) | Existing personal preferences preserved; default-home link already deployed |
| `agents/.claude/CLAUDE.md` → `../.codex/AGENTS.md` | `~/.claude/CLAUDE.md` | Shared preferences through the Claude Code instruction path |
| `AGENTS.md` | Repository only | Dotfiles-specific commands/authority |
| `CLAUDE.md` → `AGENTS.md` | Repository only | Local Claude Code project discovery; no global import cycle |
| `agents/portable/codex-preferences.toml` | Selectively merge into actual Codex `config.toml` | Not Stow-deployed; preserve host-managed provider/trust/state |
| No native OpenCode file copied | `~/.config/opencode/AGENTS.md` | Existing Caveman-owned block remains local; restore through owner |

No `~/.AGENTS.md` convention is invented. Global preferences and repository
rules are separate, so they are not duplicated through imports. Claude's
compatibility links expose the intended subset of skills; `staged-change-reviewer`
remains Codex-only. See `portable/README.md` for version/docs evidence and settings.

## Check and list

From the repository root:

```sh
scripts/agent-skills list
scripts/agent-skills check                  # sources + managed live links
scripts/agent-skills check --source-only    # no runtime requirement
scripts/agent-skills status                 # legacy topology detail
scripts/agent-skills audit                  # legacy license/lock/reference audit
scripts/agent-skills check --target /absolute/isolated/target
```

Managed names are strict: content hashes, frontmatter, metadata, directory
links, Claude subset and duplicate Codex placements are validated. Other
runtime siblings are listed separately; checks never adopt/delete them.
`skills.conf` retains the established ownership allowlists. `skills-manifest.json`
adds provenance/dependencies/patches and explicit imported entries; the wrapper
includes those imports in its legacy checks. `skills-lock.json` retains the
upstream installer's third-party subset and hash algorithm. Existing observed
upstream HEADs are recorded separately from exact pinned import revisions.

## Add a complete local package

Review all scripts, references, assets and license information first. Use the
frontmatter name, which must match the destination name. Be honest about origin:

```sh
scripts/agent-skills add my-skill \
  --from-dir /absolute/reviewed/my-skill \
  --origin 'Personally authored local package; no upstream revision' \
  --license 'Personal source; no third-party material' \
  --agents codex,claude-code --dependency 'python3'
```

Do not claim personal authorship unless it is established. `--license` records
an accurate license/path/caveat; `--license-file /path/to/upstream/LICENSE`
copies a root license that sits outside the selected package as
`LICENSE.imported`. Complete source contents are copied. Caches, private state,
secret patterns, special files and all symlinks are refused. For packages with
legitimate internal symlinks, prepare and review a self-contained regular-file
staging directory first. Arbitrary code/content still needs human review;
filename and token-pattern checks cannot detect every secret.

## Add from a pinned repository

Supported acquisition is a public, credential-free GitHub HTTPS repository,
full commit and explicit package subdirectory. It uses bare Git + archive,
without checkout hooks, submodules, installers or downloaded code execution.

```sh
scripts/agent-skills add-repo my-skill \
  --repo https://github.com/OWNER/REPOSITORY \
  --revision FULL_40_CHARACTER_COMMIT_SHA \
  --subdir path/to/my-skill \
  --license 'MIT; license included in package' --agents codex,claude-code
```

Replace the illustrative URL/revision/path with verified values. If the license
is only at repository root, separately review it and supply `--license-file`.
Other hosts/authenticated sources are not implicitly supported: review a local
staging directory and use `add` with truthful source/revision limitations.

## Import an installed skill

```sh
scripts/agent-skills import my-skill \
  --from-dir "$HOME/.agents/skills/my-skill" \
  --origin 'Reviewed local installation; original revision unknown' \
  --license 'LICENSE in package; verify applicable terms'
```

This explicit operation preserves the installed real directory. Later deploy
will refuse that conflict unless you deliberately choose backup-and-replace.
Plugin/cache/system skills and known external-owner names cannot be imported;
restore their plugin/installer instead. Generated `framer-project-*` names are
reserved and never imported. Unrelated runtime siblings remain untouched.

## Update one skill and retain local work

```sh
scripts/agent-skills update my-skill \
  --from-dir /absolute/reviewed/new-version/my-skill \
  --origin 'Reviewed new local revision; see package provenance' \
  --license 'LICENSE in package'
# The same update command accepts --repo, --revision and --subdir.
```

Current contents must match the recorded hash; local drift stops replacement.
Local/fork skills or a package with recorded patches additionally require
`--reviewed-patches 'Explain how this candidate retains/supersedes each patch'`.
A locked vendor cannot silently switch repository URL. Complete candidate
validation precedes source writes; caught failures restore the touched files.
Do not run concurrent manager operations. Keep a private backup for recovery
from process termination/disk failure during a source replacement.

For a manually reviewed local edit (including applying a vendor safety patch):

```sh
scripts/agent-skills record-patch my-skill \
  --origin 'docs/review-of-change.md or reviewed upstream URL' \
  --note 'Concrete change and why it is needed'
scripts/agent-skills check --source-only
scripts/agent-skills audit
git diff -- agents scripts/agent-skills
```

`record-patch` explicitly records review evidence and recomputes the named
package hash/installer lock entry; it is never automatic and does not substitute
for diff review. Preserve licenses and update `THIRD_PARTY.md` for provenance
changes. Source edits may already affect live Stow-linked skill readers.
Nothing is committed, pushed or linked by add/import/update/record-patch.

## Deployment

```sh
scripts/agent-skills deploy --dry-run --target /absolute/isolated/target
scripts/agent-skills deploy --target /absolute/isolated/target
# After review, live deployment is separately authorized:
scripts/agent-skills deploy --dry-run
scripts/agent-skills deploy
# Explicit conflict backups when required:
scripts/agent-skills deploy --backup
```

Uses the same Stow/backup logic as `install.sh`, but only the agents package.
Deployment links only manifest-managed skills and the two instruction files.
Real runtime parents and directory skill links are mandatory; never `--adopt`
or `--no-folding`. `install.sh --restore RECORD` restores its deployment record.
A nondefault CODEX_HOME requires the selective workflow in `docs/RECOVERY.md`.

## External installers and the 21 extra skills

**An arbitrary external install command does not guarantee dotfiles capture.**
If an installer supports an explicit destination, install into an isolated
staging directory, review the complete result, then use `add`. If it does not,
install separately, review its actual installed source, then explicitly import
only a portable package you own. Plugin-owned skills stay with their owner.

The existing project-scoped `npx skills@latest add SOURCE --skill NAME ...`
workflow remains available behind `pre-install`/`post-install` review, but it
can overwrite source. Never run it globally or with `--all`. For a pinned,
single-package acquisition prefer `add-repo`/`update`. After legacy installation,
inspect every diff and record each reviewed package change before audit.
The installer CLI version is not the reproducible artifact: committed contents
and their metadata are.

Classification (all runtime entries preserved):

| Count | Ownership | Recovery |
| --- | --- | --- |
| 27 | Existing managed inventory: 6 local, 3 forks, 18 vendors | Commit source/metadata, deploy Stow links |
| 14 | Caveman/cavecrew family | Caveman CLI/plugin; see `external-skills.json` |
| 1 | `reverse-engineer-anything` | REA installer; pinned dry-run recovery command recorded |
| 6 | `investigate-first`, `lean-build`, `migration`, `safe-refactor`, `surgical-patch`, `verify-and-stop` | Portable content reviewed, origin/license unclear; retain locally pending provenance decision |
| Separate | Generated Framer project skill | Private runtime state; never vendor automatically |

`external-skills.json` records owners, sources, observed versions, pinning
limitations, scope, supported agents and restoration commands. Codex and
Claude application plugins are separately owned, not duplicate vendored
inventory. No new unmanaged package was adopted without adequate provenance.

### Prompt library candidates

On 2026-11-26, all six were real directories under
`~/.agents/skills/<name>/`, each containing `SKILL.md` and
`agents/openai.yaml`. No same-name Claude or Codex-specific copy and no
byte-identical tracked `SKILL.md` were found. The package metadata describes
usage. Authorship, license, upstream source and an update owner are unverified
for each skill. Keep the runtime copies pending review.

| Skill | Purpose and overlap | Recommended disposition |
| --- | --- | --- |
| `investigate-first` | Rank hypotheses before editing. Overlaps tracked `diagnosing-bugs`. | Replace with `diagnosing-bugs`. |
| `lean-build` | Reuse existing code and constrain feature scope. Overlaps the external Ponytail skill. | Replace with Ponytail plus explicit acceptance criteria in the task prompt. |
| `migration` | Plan compatibility, reversible transitions and rollback proof. Tracked `tdd` covers testing only. | Retain as a distinct workflow candidate. Review provenance before importing. |
| `safe-refactor` | Preserve behavior by verifying before and after structural edits. Overlaps `tdd` and `code-review`. | Retain as a focused refactoring workflow candidate. Review provenance before importing. |
| `surgical-patch` | Fix a bug at its owning layer with narrow regression proof. Overlaps tracked `bug-triage`. | Replace with `bug-triage`. |
| `verify-and-stop` | Check acceptance criteria without expanding scope. Overlaps the validation portion of `code-review`. | Retain the use case as an original verification-only prompt in the library. |

Future portable preferences, personal instructions, hooks you actually own,
and reviewed skill changes must be reflected in canonical repository source,
metadata and these recovery notes. Keep account/trust/runtime state local.
