# How to Use tmux

This guide documents the tmux setup in this repo, based on `tmux/.tmux.conf`
and the zsh helpers in `zsh/.oh-my-zsh/custom/functions.zsh`.

The important difference from default tmux: this setup uses `Ctrl-Space` as the
prefix key, not `Ctrl-b`.

---

## What tmux is

tmux is a terminal workspace manager. It lets one terminal window hold multiple
long-running shell workspaces.

- A session is a named workspace that keeps running after you detach.
- A window is a tab inside a session.
- A pane is a split inside a window.
- Detach means leave tmux without stopping the commands inside it.
- Attach means reconnect to a running tmux session later.

For development, tmux is useful because you can keep an editor, dev server,
git shell, logs, database console, and scratch terminal together in one named
project session. If the terminal app closes, the tmux session can still be
reattached.

---

## Prefix key

Your prefix key is:

```text
Ctrl-Space
```

In this guide, `<prefix>` means press `Ctrl-Space`, release it, then press the
next key.

Examples:

```text
<prefix> c
<prefix> |
<prefix> r
```

Default tmux uses `Ctrl-b`. This config intentionally unbinds `Ctrl-b` and uses
`Ctrl-Space` instead.

---

## Starting tmux

Start tmux with an unnamed session:

```bash
tmux
```

Start a named session:

```bash
tmux new -s <session-name>
```

List sessions:

```bash
tmux ls
```

Attach to a named session:

```bash
tmux attach -t <session-name>
```

Kill a named session:

```bash
tmux kill-session -t <session-name>
```

Use short, project-based names:

```bash
tmux new -s dotfiles
tmux new -s api
tmux new -s mobile
```

---

## Repo helpers

These helpers are loaded by the zsh setup in this repo.

| Helper | What it does |
| --- | --- |
| `tm` | Opens an fzf picker for existing tmux sessions, with a `[new]` option. |
| `tmuxx` | The function behind `tm`. |
| `sessionize` | Picks a project from zoxide history with fzf, then opens or creates a tmux session named after that folder. |
| `tmuxdev` | Picks a zoxide project, creates a named session, and starts a quick 3-pane layout. |

Typical project flow:

```bash
sessionize
```

Pick a project, then tmux opens a session in that project directory. If a
session already exists for that project name, it attaches instead of creating a
duplicate.

For a quick 3-pane project layout:

```bash
tmuxdev
```

---

## Daily workflow

Start by creating or attaching to a named session:

```bash
tmux new -s dotfiles
```

or use the repo helper:

```bash
tm
```

Inside the session, create windows for project areas:

```text
1:editor
2:server
3:git
4:logs
5:database
```

Use panes when commands are related and should stay visible together. For
example, in a `server` window:

- left pane: run the dev server
- right pane: run tests
- bottom pane: tail logs or run one-off commands

Detach when you are done for now:

```text
<prefix> d
```

Later, reattach:

```bash
tmux attach -t dotfiles
```

or use:

```bash
tm
```

---

## Keybindings

All bindings in this table come from `tmux/.tmux.conf` unless marked as default
tmux behavior.

| Action | Keybinding | Notes |
| --- | --- | --- |
| Reload config | `<prefix> r` | Sources `~/.tmux.conf` and shows a reload message. |
| Detach | `<prefix> d` | Leaves the session running. |
| New window | `<prefix> c` | Opens in the current pane's working directory. |
| Kill pane | `<prefix> x` | Kills the active pane immediately. |
| Kill window | `<prefix> &` | Prompts before killing the current window. |
| Split left/right | `<prefix> \|` | tmux horizontal split: new pane opens beside the current pane. |
| Split top/bottom | `<prefix> -` | tmux vertical split: new pane opens below the current pane. |
| Move pane left | `<prefix> h` | Vim-style pane navigation. |
| Move pane down | `<prefix> j` | Vim-style pane navigation. |
| Move pane up | `<prefix> k` | Vim-style pane navigation. |
| Move pane right | `<prefix> l` | Vim-style pane navigation. |
| Move pane with arrows | `Alt-Left/Down/Up/Right` | No prefix required. May depend on terminal Option/Alt settings. |
| Resize pane left | `<prefix> H` | Repeatable; resizes by 5 cells. |
| Resize pane down | `<prefix> J` | Repeatable; resizes by 5 cells. |
| Resize pane up | `<prefix> K` | Repeatable; resizes by 5 cells. |
| Resize pane right | `<prefix> L` | Repeatable; resizes by 5 cells. |
| Previous window | `<prefix> Ctrl-h` | Repeatable. |
| Next window | `<prefix> Ctrl-l` | Repeatable. |
| Previous window, no prefix | `Shift-Left` | Terminal support may vary. |
| Next window, no prefix | `Shift-Right` | Terminal support may vary. |
| Enter copy mode | `<prefix> [` | Default tmux binding; movement is vi-style in this config. |
| Quit copy mode | `q` | Used after entering copy mode. |

---

## Split behavior

Splits open in the current pane's working directory:

```tmux
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
```

This matters in project folders. If you are in `~/dotfiles` and split a pane,
the new pane also starts in `~/dotfiles`.

Example:

```bash
cd ~/dotfiles
tmux new -s dotfiles
```

Then:

```text
<prefix> |
```

The new pane opens in `~/dotfiles`, so you can immediately run:

```bash
git status
stow --simulate --verbose zsh tmux git starship
zsh -n zsh/.zshrc
```

New windows also open in the current pane's working directory:

```text
<prefix> c
```

---

## Panes vs windows

Use windows for separate project areas. Use panes for related commands that
belong on the same screen.

Good window examples:

- `editor`
- `server`
- `git`
- `logs`
- `database`

Good pane examples:

- server plus test runner
- git status plus git diff
- app logs plus a scratch shell
- database console plus migration commands

---

## Pane navigation

Use prefix navigation when you want reliable keyboard movement:

| Direction | Key |
| --- | --- |
| Left | `<prefix> h` |
| Down | `<prefix> j` |
| Up | `<prefix> k` |
| Right | `<prefix> l` |

No-prefix pane navigation is also configured:

| Direction | Key |
| --- | --- |
| Left | `Alt-Left` |
| Down | `Alt-Down` |
| Up | `Alt-Up` |
| Right | `Alt-Right` |

On macOS terminals, `Alt` usually means the Option key. Some terminal apps use
Option-arrow for word movement or do not send it as tmux expects. If Alt-arrow
does not work, use `<prefix> h/j/k/l` first, then check the terminal's keyboard
settings.

---

## Window navigation

Windows are like tabs inside a tmux session. Panes are splits inside one window.

Use these when moving between windows:

| Action | Key |
| --- | --- |
| Previous window | `<prefix> Ctrl-h` |
| Next window | `<prefix> Ctrl-l` |
| Previous window, no prefix | `Shift-Left` |
| Next window, no prefix | `Shift-Right` |

The config starts window numbering at `1` and renumbers windows after one is
closed, so the status bar stays compact.

---

## Copy mode

Copy mode lets you scroll through pane history, search output, and copy text
into tmux's own buffer.

Enter copy mode:

```text
<prefix> [
```

That entry key is default tmux behavior. Once inside copy mode, this config uses
vi-style movement:

| Action | Key |
| --- | --- |
| Move | `h`, `j`, `k`, `l` |
| Start selection | `v` |
| Toggle rectangle selection | `Ctrl-v` |
| Copy selection and exit | `y` |
| Search | `/` |
| Quit copy mode | `q` |

Basic copy flow:

```text
<prefix> [
v
move to extend the selection
y
```

Rectangle copy flow:

```text
<prefix> [
Ctrl-v
move to extend the rectangle
y
```

Search flow:

```text
<prefix> [
/
type search text
Enter
```

The `v`, `Ctrl-v`, and `y` copy-mode bindings are explicitly configured in
`tmux/.tmux.conf`. This config does not set up system clipboard integration, so
assume copies go to tmux's buffer unless your terminal or operating system adds
clipboard behavior separately.

---

## Mouse usage

Mouse support is enabled:

```tmux
set -g mouse on
```

You can:

- click a pane to focus it
- click a window in the status bar to switch to it
- drag pane borders to resize
- scroll with the mouse wheel to enter and move through copy history

The mouse is useful for quick inspection. For daily speed, prefer the keyboard
bindings for pane and window movement.

---

## Status bar

The status bar is at the bottom.

Left side:

```text
 #S
```

This shows the current session name.

Middle:

```text
 #I:#W
```

This shows the window list as window index plus window name. The current window
is bold.

Right side:

```text
 %Y-%m-%d %H:%M
```

This shows date and time, for example:

```text
 2026-06-01 10:30
```

The config uses a simple black/green status bar.

---

## Troubleshooting

### Prefix not working

Check that you are pressing `Ctrl-Space`, not `Ctrl-b`.

Inside tmux, check the configured prefix:

```bash
tmux show -g prefix
```

Expected:

```text
prefix C-Space
```

If your terminal or keyboard layout does not send `Ctrl-Space` reliably, the
comment in `.tmux.conf` notes `C-a` as a possible fallback. Do not change it
casually if muscle memory already depends on `Ctrl-Space`.

### Alt-arrow not working

Use the prefix bindings first:

```text
<prefix> h
<prefix> j
<prefix> k
<prefix> l
```

Then check your terminal settings. On macOS, Option-arrow may be configured for
word movement instead of sending `Alt-Arrow` to tmux.

### Colors or theme looking wrong

This config sets:

```tmux
set -g default-terminal "tmux-256color"
```

and enables RGB/truecolor support for common terminal names.

Check `$TERM`:

```bash
echo $TERM
```

Inside tmux, expected:

```text
tmux-256color
```

Outside tmux, your terminal usually reports something like:

```text
xterm-256color
```

or a terminal-specific value.

### `tmux-256color` on remote SSH servers

Some remote servers do not have `tmux-256color` installed in their terminfo
database. Symptoms include color issues, broken full-screen programs, or errors
about an unknown terminal type after SSH.

Check on the remote server:

```bash
echo $TERM
infocmp tmux-256color
```

If `infocmp` fails, practical options are:

- install or copy the `tmux-256color` terminfo entry on the remote server
- use a more widely available TERM value for that remote session
- start tmux on the remote server only after confirming its terminfo support

### Reloading config

After editing `~/.tmux.conf`, reload inside tmux:

```text
<prefix> r
```

Or run:

```bash
tmux source-file ~/.tmux.conf
```

Because this repo uses Stow, `tmux/.tmux.conf` should be linked to
`~/.tmux.conf` after:

```bash
stow tmux
```

### Start from a clean tmux server

If tmux state is badly confused, list sessions first:

```bash
tmux ls
```

Kill one session:

```bash
tmux kill-session -t <session-name>
```

Only if you are sure no running tmux work matters, kill the whole tmux server:

```bash
tmux kill-server
```

That stops every tmux session.

---

## Recommended daily practice

| Day | Practice |
| --- | --- |
| 1 | Create `tmux new -s practice`, detach with `<prefix> d`, reattach with `tmux attach -t practice`. |
| 2 | Create windows with `<prefix> c`; keep separate windows for editor, server, git, and logs. |
| 3 | Split panes with `<prefix> \|` and `<prefix> -`; run related commands side by side. |
| 4 | Move with `<prefix> h/j/k/l`; resize with `<prefix> H/J/K/L`; try Alt-arrow if your terminal supports it. |
| 5 | Enter copy mode with `<prefix> [`; search with `/`; select with `v`; copy with `y`; quit with `q`. |
| 6 | Use `sessionize` or `tmuxdev` to open a real project from zoxide history. |
| 7 | Do a normal coding session using only named sessions, project windows, pane splits, detach, and reattach. |

---

## Common commands cheat sheet

### Shell commands

| Command | Use |
| --- | --- |
| `tmux` | Start tmux. |
| `tmux new -s <session-name>` | Start a named session. |
| `tmux ls` | List sessions. |
| `tmux attach -t <session-name>` | Attach to a session. |
| `tmux kill-session -t <session-name>` | Kill one session. |
| `tmux source-file ~/.tmux.conf` | Reload config from the shell. |
| `tm` | fzf session picker from this dotfiles setup. |
| `sessionize` | Pick a zoxide project and open it as a tmux session. |
| `tmuxdev` | Create or attach to a 3-pane project session. |

### Keys

| Key | Use |
| --- | --- |
| `<prefix> r` | Reload config. |
| `<prefix> d` | Detach. |
| `<prefix> c` | New window in current directory. |
| `<prefix> \|` | Split left/right in current directory. |
| `<prefix> -` | Split top/bottom in current directory. |
| `<prefix> h/j/k/l` | Move between panes. |
| `Alt-Arrow` | Move between panes without prefix, if terminal supports it. |
| `<prefix> H/J/K/L` | Resize panes. |
| `<prefix> Ctrl-h/Ctrl-l` | Previous/next window. |
| `Shift-Left/Shift-Right` | Previous/next window without prefix, if terminal supports it. |
| `<prefix> x` | Kill pane. |
| `<prefix> &` | Kill window after confirmation. |
| `<prefix> [` | Enter copy mode. |
| `v`, `Ctrl-v`, `y`, `/`, `q` | Copy-mode select, rectangle, copy, search, quit. |
