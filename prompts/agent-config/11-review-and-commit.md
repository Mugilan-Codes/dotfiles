# Final review and commit

## Objective and input

Review the complete intended dotfiles change, validate it, stage only its
paths, perform a staged-diff review, and create exactly one forward commit.

- Optional commit message: `<COMMIT_MESSAGE>`

If no message is supplied, derive one from the actual complete scope. For the
agent-vendoring project, `feat(agents): vendor skills through Stow` is a
candidate, not a mandatory message.

Use a valid phase handoff as authoritative and reconfirm mutable state; do not
repeat completed audits merely to regain context.

## Authority and safety

- This prompt authorizes staging intended paths and creating exactly one commit
  after all checks pass. It does not authorize an installer, real Stow/runtime
  change, amend/rebase/history rewrite, push, pull, fetch, deployment, or
  branch creation/switching.
- Preserve pre-existing and unrelated changes and leave them unstaged. Stop if
  intended and unrelated changes cannot be separated safely.
- Do not reset, restore, checkout, clean, broadly delete, or use destructive
  cleanup.
- Never use global skill installation. This final review does not run
  `skills@latest`; any installer work must already have been separately
  authorized and project-scoped from `dotfiles/agents`.
- Do not expose or stage secrets, credentials, `.env`, databases, logs,
  caches, sessions, private generated data, migration backups, or broad
  `.codex`/Claude application state.

## Discovery and canonical model

Find the Git root, read applicable `AGENTS.md`, inspect branch, HEAD, upstream,
ahead/behind counts, status including ignored relevant files, and the complete
staged, unstaged, untracked diff from HEAD. Read supplied handoffs and all
changed documentation/configuration.

For agents, canonical source is `agents/.agents/skills`, static Claude links
are `agents/.claude/skills`, and the package requires
`stow --no-folding` with real runtime parents. Confirm all names are correctly
classified as local, local fork, approved vendored third party, generated
runtime, or application managed. Generated `framer-project-*` and broad
`.codex` state must not be committed.

## Review and validation

1. Map every changed path to the intended task. Preserve and exclude unrelated
   work. Review file additions, modifications, moves, deletions, symlink
   targets, and executable modes.
2. Review all skill contents, frontmatter, relative links, ownership,
   dependencies, allowlists, lock hashes/sources, licences, provenance,
   Codex-only classification, generated exclusions, and documentation.
3. Inspect all unstaged and already staged content before changing the index.
4. Run:

   ```sh
   git status --short --untracked-files=all
   git diff --check
   git diff --cached --check
   git diff --summary
   git diff --cached --summary
   bash -n scripts/agent-skills
   zsh -n zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/.zlogin \
     zsh/.oh-my-zsh/custom/aliases.zsh \
     zsh/.oh-my-zsh/custom/functions.zsh \
     zsh/.oh-my-zsh/custom/completions.zsh
   scripts/agent-skills status
   scripts/agent-skills audit
   scripts/agent-skills pre-install
   scripts/agent-skills post-install
   stow --target="$HOME" --simulate --verbose zsh tmux git starship
   stow --target="$HOME" --simulate --no-folding --verbose agents
   ```

   Run `brew bundle check --file=./Brewfile` when Brewfile scope or repository
   policy requires it. Verify prompt Markdown links/fences and obsolete
   instruction searches when prompts changed.
5. Stage only enumerated intended paths. Never use a broad staging shortcut
   until its exact expansion is proven safe.
6. Recheck status, `git diff --cached --check`, full staged diff, symlink modes
   (`120000`), executable modes (`100755` where expected), and absence of
   sensitive/generated files.
7. Invoke/follow the staged-diff or staged-change reviewer and resolve every
   blocking finding before committing.
8. Create exactly one non-amended commit with the reviewed message. Do not
   push.

## Report and handoff

Report reviewed scope, excluded changes, every validation, staged paths,
symlink/mode results, staged-review findings, commit SHA/message, post-commit
clean/dirty and ahead/behind state, and skipped checks.

```yaml
operation: review-and-commit
repository:
  path:
  branch:
  head_before:
  head_after:
  tracking:
  ahead:
  behind:
intended_paths: []
preserved_unrelated_paths: []
validation:
  passed: []
  failed: []
symlink_and_mode_review:
staged_diff_review:
commit:
  sha:
  message:
  count: 1
installer_ran: false
runtime_changed: false
pushed: false
post_commit_working_tree:
unresolved_blockers: []
```
