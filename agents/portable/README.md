# Portable preferences and selective restoration

`codex-preferences.toml` captures reviewed preferences already present in this
Mac's user config. It deliberately contains no model/provider, proxy, hooks,
trust lists, credentials or application-managed feature toggles. Stow ignores
this folder. There is no invented TOML include directive: compare and merge
these four keys once into the real `$CODEX_HOME/config.toml`, preserving
unrelated tables and avoiding duplicate keys. Back up that local file privately
before editing; never commit that backup. Parse it with Python `tomllib` after
merging. Model availability and reasoning support depend on the installed
client/provider; retain the provider's default until separately verified.

Claude's inspected user settings contain plugin enables only. Restore them
through their owner, not by copying a settings/cache snapshot. No invented
Claude preferences were added. Existing user/project/local/managed settings
have separate precedence; managed policy can constrain any personal default.
OpenCode 1.19.5 has a Caveman-owned global AGENTS block and local plugin loader.
Rebuild that integration through Caveman; do not replace it with a second
shared-instruction file. In the absence of its native global rules, OpenCode
can use Claude's global file as a fallback. If native rules are retained and
you also want shared personal preferences, selectively add the reviewed
absolute path of `agents/.codex/AGENTS.md` to OpenCode's supported `instructions`
array after checking it is not already loaded. That remains a user decision.

## Integration recovery order

1. Install Node through FNM and choose a persistent default. Install the desired
   agents through their official installer/application, then authenticate
   separately. Versions observed on this host: Codex 0.168.0, Claude Code
   2.1.62, OpenCode 1.19.5. These are observations, not recovery version pins.
2. Restore personal instructions and vendored skills using Stow. Keep all
   account databases, sessions, caches, MCP registrations and directory trust
   decisions local. Do not transfer current-employer identity to this Mac.
3. Reinstall external plugins selectively from `../external-skills.json`.
   Caveman CLI is observed at 1.3.1. Review `caveman setup` before running it:
   setup can install companion binaries and rewrite integrations. Its local
   proxy, Node adapter and selected agent must all exist before provider/hook
   routing is enabled. Do not copy ephemeral FNM multishell paths.
4. Preserve the existing intentional Caveman provider selection on this Mac.
   On a new Mac, verify local dependency health before separately enabling it.
   This installer neither copies nor enables localhost providers or hooks.
   The observed Codex notify command belongs to the desktop application;
   let the application restore it. No personal custom hook was identified.
5. REA setup and other MCP registrations require separate review. Use the
   recorded dry-run command first; no MCP/agent was started during this work.

These are local Codex/Claude/OpenCode files. ChatGPT Work, Cowork, cloud app
settings, subscriptions, organization policy and connector authorizations are
not reconstructed by Stow. In particular, current Claude Cowork documentation
has restrictions on user instruction symlinks; this deployment targets local
Claude Code, not Cowork.

## Discovery evidence (official docs, checked 2026-11-14)

- [Codex instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md):
  `$CODEX_HOME/AGENTS.override.md` takes priority over `AGENTS.md`; default home
  is `~/.codex`. No override file exists on this host. Project rules remain
  separate. There is no universal `~/.AGENTS.md`.
- [Codex configuration](https://learn.chatgpt.com/docs/config-file/config-basic):
  runtime/CLI and applicable project/managed configuration affect effective
  behavior; user preferences alone do not prove session permissions.
- [Claude instructions](https://code.claude.com/docs/en/memory): user
  `~/.claude/CLAUDE.md` and project `CLAUDE.md`. Direct AGENTS loading is a newer
  feature than installed 2.1.62, so retain the repository CLAUDE symlink.
- [Claude settings](https://code.claude.com/docs/en/settings): preserve supported
  settings layers; install plugin integrations separately.
- [OpenCode V1 rules](https://opencode.ai/v1/docs/rules/): native global rules
  at `~/.config/opencode/AGENTS.md`; Claude global fallback when absent.

Discovery and local TOML/JSON were inspected statically. No agent session,
full client schema validation or permission escalation was used as a test.
