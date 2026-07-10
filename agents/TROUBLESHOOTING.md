# Agent skill and plugin troubleshooting

## A tracked skill is not discovered

Run `scripts/agent-skills status`, inspect the runtime entry with `stat`,
`readlink`, and `realpath`, then simulate:

```sh
stow --target="$HOME" --simulate --no-folding --verbose agents
```

Apply Stow only with separate runtime authority. Start a fresh application
session because skill discovery may be session-scoped.

## Claude link missing or broken

The canonical source is `agents/.agents/skills/<name>`. A Claude-compatible
tracked link must be relative and resolve to `../../.agents/skills/<name>`.
`staged-change-reviewer` is intentionally Codex-only. Generated
`framer-project-*` Claude links are runtime-only and must not be added to Git.

## A new support file is not visible

`--no-folding` exposes files individually. Re-run Stow simulation after adding
the file, review the proposed link, then restow with separate authority and
start a fresh task.

## Stow conflict or broken symlink

Stop before `--adopt`. Inspect the real home entry and resolved target. Back
up only the conflicting entry under `/private/tmp`, decide its ownership, and
repeat simulation. Never delete an entire runtime parent; it must remain a
real directory so generated/application entries can coexist.

## Installer changed unexpected files or the lock mismatches

Do not restow, stage, or commit. Run:

```sh
git status --short --untracked-files=all
git diff --summary
scripts/agent-skills post-install
scripts/agent-skills audit
```

Compare every added/deleted file, executable mode, source, hash, Claude link,
licence, and local adaptation. An installer removal can leave stale lock
entries; reconcile the named entry explicitly. Restore from the scoped backup
or a known Git blob—never use broad `git reset --hard` or delete unrelated
work.

## A requirement is missing

Use [REQUIREMENTS.md](REQUIREMENTS.md). Optional credentials, project files,
and unavailable agent features should not be treated as repository failure.
Set up only the chosen project/host requirement, then re-run its exact verify
command without printing secrets.

## Plugin not visible or command unavailable

Run `codex plugin list` or `claude plugin list`. Use the exact host commands in
[PLUGINS_GUIDE.md](PLUGINS_GUIDE.md); Codex does not currently implement
`plugin update/enable/disable`. Do not copy or edit caches. Restart the host
(mandatory after Claude update) and open a fresh task. Connector login and
permissions require the application’s interactive account UI.

## Generated Framer state

Never move, delete, copy, or track `$HOME/.agents/skills/framer-project-*` or
its runtime Claude link during routine maintenance. If a Stow operation would
touch one, stop and resolve the collision before proceeding.

## Failed install/update recovery

Keep the preflight backup until review and runtime validation are complete.
Use [prompt 12](../prompts/agent-config/12-recover-failed-install.md) to
inventory the partial result. Restore only proven affected paths, re-run
`audit`, and simulate Stow. An interrupted mutation does not authorize another
installer run, runtime cleanup, staging, or commit.
