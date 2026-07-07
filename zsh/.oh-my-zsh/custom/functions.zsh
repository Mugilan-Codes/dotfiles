# ~/.oh-my-zsh/custom/functions.zsh
# Put anything here that needs logic, arguments, checks, or multiple commands.
# Aliases are for shortcuts. Functions are for workflows.

# Open files using VISUAL/EDITOR without treating a value such as
# `code --wait` as one executable name.
_dotfiles_edit() {
  emulate -L zsh

  local editor_spec="${VISUAL:-${EDITOR:-}}"
  local -a editor_cmd

  if [[ -n "$editor_spec" ]]; then
    editor_cmd=(${(z)editor_spec})
  elif command -v code >/dev/null 2>&1; then
    editor_cmd=(code --wait)
  elif command -v vim >/dev/null 2>&1; then
    editor_cmd=(vim)
  else
    echo "No editor found. Set VISUAL or EDITOR." >&2
    return 1
  fi

  command "${editor_cmd[@]}" "$@"
}

# ─────────────────────────────
# ⚙️ Utility Functions
# ─────────────────────────────

# Kill all processes listening on a given TCP port.
# Use when a local dev server is stuck on a port.
# Usage:
#   killport 3000
killport() {
  if [[ -z "$1" ]]; then
    echo "Usage: killport <port>"
    return 1
  fi

  local pids
  pids=$(lsof -ti tcp:"$1")

  if [[ -z "$pids" ]]; then
    echo "No processes found on port $1"
    return 0
  fi

  echo "Killing processes on port $1: $pids"
  echo "$pids" | xargs kill
}

# Force-kill all processes listening on a given TCP port.
# Sends SIGKILL; use only if normal killport does not work.
# Usage:
#   killportf 3000
killportf() {
  if [[ -z "$1" ]]; then
    echo "Usage: killportf <port>"
    return 1
  fi

  local pids
  pids=$(lsof -ti tcp:"$1")

  if [[ -z "$pids" ]]; then
    echo "No processes found on port $1"
    return 0
  fi

  echo "Force-killing processes on port $1: $pids"
  echo "$pids" | xargs kill -9
}

# Create a directory and immediately cd into it.
# Usage:
#   mkcd my-folder
mkcd() {
  if [[ -z "$1" ]]; then
    echo "Usage: mkcd <directory>"
    return 1
  fi

  mkdir -p "$1" && cd "$1"
}

# Extract common archive formats.
# Usage:
#   extract file.zip
#   extract archive.tar.gz
extract() {
  if [[ -z "$1" ]]; then
    echo "Usage: extract <archive_file>"
    return 1
  fi

  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "File not found: $file"
    return 1
  fi

  case "$file" in
    *.tar.bz2) tar xjf "$file" ;;
    *.tar.gz)  tar xzf "$file" ;;
    *.tar.xz)  tar xJf "$file" ;;
    *.tar)     tar xf "$file" ;;
    *.tbz2)    tar xjf "$file" ;;
    *.tgz)     tar xzf "$file" ;;
    *.zip)     unzip "$file" ;;
    *.rar)     unrar x "$file" ;;
    *.7z)      7z x "$file" ;;
    *)         echo "Don't know how to extract: $file"; return 1 ;;
  esac
}

# Serve the current directory over HTTP.
# Usage:
#   servehere
#   servehere 9090
servehere() {
  local port=${1:-8080}
  echo "Starting HTTP server at http://localhost:$port"
  python3 -m http.server "$port"
}

# Restart macOS Core Audio daemon.
# Useful if audio gets stuck or devices behave oddly.
# Requires sudo and kills the Core Audio daemon so macOS can restart it.
# Usage:
#   fixaudio
fixaudio() {
  echo "Restarting Core Audio..."
  sudo pkill coreaudiod
}

# Fix npm global permissions only for an FNM-managed prefix under $HOME.
# Refuses system, Homebrew, and broad user-directory prefixes.
# Usage:
#   fixperm
fixperm() {
  emulate -L zsh

  command -v npm >/dev/null 2>&1 || {
    echo "npm not found"
    return 1
  }

  local prefix
  prefix="$(npm config get prefix 2>/dev/null)"
  prefix="${prefix:A}"

  if [[ -z "$prefix" || ! -d "$prefix" ]]; then
    echo "Invalid npm prefix: $prefix"
    return 1
  fi

  if [[ "$prefix" != "$HOME/"* || "$prefix" != *"/fnm/"* ]]; then
    echo "Refusing unsafe npm prefix: $prefix"
    echo "fixperm only supports an FNM-managed prefix below \$HOME."
    return 1
  fi

  local -a targets
  local target
  for target in "$prefix/lib/node_modules" "$prefix/bin" "$prefix/share"; do
    [[ -e "$target" ]] && targets+=("$target")
  done

  if (( ${#targets[@]} == 0 )); then
    echo "No npm global directories found under: $prefix"
    return 0
  fi

  echo "This will recursively change ownership only for:"
  printf '  %s\n' "${targets[@]}"
  echo
  read "confirm?Type FIXPERM to continue: "

  if [[ "$confirm" != "FIXPERM" ]]; then
    echo "Cancelled."
    return 1
  fi

  sudo chown -R "$(id -un):$(id -gn)" "${targets[@]}"
}

# Find files/directories using the real `fd` binary.
# Includes hidden files and skips .git by default.
# This uses the real fd command directly.
# Usage:
#   fdf
#   fdf package
#   fdf -t f
#   fdf -t d
fdf() {
  command fd --hidden --exclude .git "$@"
}

# Aggressively reset a React Native project after confirmation.
#
# Warning:
#   Deletes node_modules, reinstalls dependencies, and resets Metro cache.
#
# Usage:
#   rnreset
rnreset() {
  echo "WARNING: This will reset the current React Native project."
  echo "It will delete node_modules, reinstall dependencies, and reset Metro cache."
  echo

  read "confirm?Type RNRESET to continue: "

  if [[ "$confirm" != "RNRESET" ]]; then
    echo "Cancelled."
    return 1
  fi

  watchman watch-del-all &&
  rm -rf node_modules &&
  npm install &&
  npm start -- --reset-cache
}

# Fuzzy-pick a directory under the current path and cd into it.
# Usage:
#   cdf
cdf() {
  local dir
  dir=$(command fd --type d --hidden --exclude .git . 2>/dev/null | fzf)
  [[ -n "$dir" ]] && cd "$dir"
}

# Quick tldr lookup with fuzzy selection.
# Usage:
#   cheat
cheat() {
  local cmd
  cmd=$(tldr --list | fzf)
  [[ -n "$cmd" ]] && tldr "$cmd"
}

# Create and jump into a temporary working directory.
# Usage:
#   tmpd
tmpd() {
  local dir
  dir=$(mktemp -d "${TMPDIR:-/tmp}/work.XXXXXX")
  cd "$dir" || return
  echo "Entered $dir"
}

# Copy the current working directory to the clipboard.
# Use when you need to paste the current path into Finder, an editor, or a note.
# Usage:
#   cpwd
cpwd() {
  command -v pbcopy >/dev/null 2>&1 || {
    echo "pbcopy not found"
    return 1
  }

  pwd | pbcopy
  echo "Copied: $(pwd)"
}

# Open the current Finder directory in terminal
# Usage:
#   finder
finder() {
  local dir
  dir=$(osascript -e 'tell application "Finder" to POSIX path of (target of front window as alias)')
  cd "$dir" || return
  echo "Moved to: $dir"
}

# Open the current directory in Finder.
# Use when you are working in terminal and want to inspect the same folder visually.
# Usage:
#   finderopen
finderopen() {
  command -v open >/dev/null 2>&1 || {
    echo "open not found"
    return 1
  }

  open .
}

# Show duplicate entries in PATH without changing PATH.
# Use when command resolution looks wrong or `showpath` looks noisy.
# Usage:
#   pathdups
pathdups() {
  emulate -L zsh

  local -A seen duplicates
  local entry display
  local found=0
  local path_entries=("${(@s/:/)PATH}")

  for entry in "${path_entries[@]}"; do
    display="$entry"
    [[ -z "$display" ]] && display="<empty>"

    if [[ -n "${seen[$display]}" ]]; then
      duplicates[$display]=1
    else
      seen[$display]=1
    fi
  done

  for entry in "${(@k)duplicates}"; do
    echo "$entry"
    found=1
  done

  if (( found == 0 )); then
    echo "No duplicate PATH entries found."
  fi
}

# Refuse automated Brewfile commits while unrelated files are staged.
_brewfile_refuse_unrelated_staged() {
  local repo="$1"
  local unrelated

  unrelated=$(git -C "$repo" diff --cached --name-only -- . ':(exclude)Brewfile')
  if [[ -n "$unrelated" ]]; then
    echo "Refusing: unrelated staged files exist:"
    print -r -- "$unrelated"
    echo "Commit or unstage them before using brewsave/brewpush."
    return 1
  fi
}

# Preview current Homebrew package, tap, and trust state before replacing Brewfile.
# Homebrew 6 serializes local `brew trust` entries as `trusted:` options.
# Usage:
#   brewdump
brewdump() {
  emulate -L zsh

  local repo="$HOME/dotfiles"
  local file="$repo/Brewfile"
  local dump_file
  local confirm

  command -v brew >/dev/null 2>&1 || {
    echo "brew not found"
    return 1
  }

  [[ -f "$file" ]] || {
    echo "Brewfile not found: $file"
    return 1
  }

  dump_file=$(mktemp "${TMPDIR:-/tmp}/Brewfile.XXXXXX") || return 1
  {
    echo "Generating a temporary Brewfile from local Homebrew state..."
    brew bundle dump --file="$dump_file" --force || return 1

    if cmp -s "$file" "$dump_file"; then
      echo "Brewfile already matches local Homebrew state."
      return 0
    fi

    echo
    echo "Proposed Brewfile changes:"
    command diff -u "$file" "$dump_file" || true
    echo
    echo "Review package, tap, and trusted: changes carefully."
    read "confirm?Type REPLACE to update $file: "

    if [[ "$confirm" != "REPLACE" ]]; then
      echo "Brewfile left unchanged."
      return 1
    fi

    command cp "$dump_file" "$file" || return 1
    echo "Updated: $file"
    echo "Review with: git -C \"$repo\" diff -- Brewfile"
  } always {
    command rm -f "$dump_file"
  }
}

# Install a Homebrew formula, then refresh Brewfile if install succeeds.
# Usage:
#   brewadd jq
#   brewadd --cask iterm2
brewadd() {
  [[ $# -eq 0 ]] && { echo "Usage: brewadd <brew install args>"; return 1; }
  brew install "$@" && brewdump
}

# Uninstall a Homebrew formula/cask, then refresh Brewfile if uninstall succeeds.
# Usage:
#   brewrm jq
#   brewrm --cask iterm2
brewrm() {
  [[ $# -eq 0 ]] && { echo "Usage: brewrm <brew uninstall args>"; return 1; }
  brew uninstall "$@" && brewdump
}

# Tap a Homebrew repo, then refresh Brewfile.
# Usage:
#   brewtap hashicorp/tap
brewtap() {
  [[ $# -eq 0 ]] && { echo "Usage: brewtap <tap>"; return 1; }
  brew tap "$@" && brewdump
}

# Untap a Homebrew repo, then refresh Brewfile.
# Usage:
#   brewuntap hashicorp/tap
brewuntap() {
  [[ $# -eq 0 ]] && { echo "Usage: brewuntap <tap>"; return 1; }
  brew untap "$@" && brewdump
}

# Preview/update Brewfile and commit only that file after confirmation.
# Refuses to run while unrelated files are staged.
# Usage:
#   brewsave
#   brewsave "Update Brewfile after installing jq"
brewsave() {
  emulate -L zsh

  local repo="$HOME/dotfiles"
  local msg="${1:-Update Brewfile}"
  local confirm

  [[ -d "$repo/.git" ]] || { echo "Not a git repo: $repo"; return 1; }
  _brewfile_refuse_unrelated_staged "$repo" || return 1
  brewdump || return 1

  if git -C "$repo" diff --quiet -- Brewfile &&
     git -C "$repo" diff --cached --quiet -- Brewfile; then
    echo "No Brewfile changes to commit."
    return 0
  fi

  _brewfile_refuse_unrelated_staged "$repo" || return 1
  echo "Commit message: $msg"
  read "confirm?Type BREWCOMMIT to stage and commit only Brewfile: "

  if [[ "$confirm" != "BREWCOMMIT" ]]; then
    echo "Commit cancelled. Brewfile changes remain uncommitted."
    return 1
  fi

  git -C "$repo" add -- Brewfile || return 1
  _brewfile_refuse_unrelated_staged "$repo" || return 1
  git -C "$repo" commit --only -m "$msg" -- Brewfile
}

# Prepare a Brewfile-only commit, then print manual push guidance.
# This function never pushes automatically.
# Usage:
#   brewpush
#   brewpush "Update Brewfile after installing jq"
brewpush() {
  emulate -L zsh

  local repo="$HOME/dotfiles"
  local msg="${1:-Update Brewfile}"

  [[ -d "$repo/.git" ]] || { echo "Not a git repo: $repo"; return 1; }
  _brewfile_refuse_unrelated_staged "$repo" || return 1
  brewsave "$msg" || return 1

  echo
  echo "No push was performed."
  echo "Review the commit, then push manually with:"
  echo "  git -C \"$repo\" push"
}

# Check whether installed Homebrew packages match the tracked Brewfile.
# This checks package presence, not Homebrew tap trust warnings.
# Use before or after setup to verify this Mac is reproducible from Brewfile.
# Usage:
#   brewcheck
brewcheck() {
  local file="$HOME/dotfiles/Brewfile"

  command -v brew >/dev/null 2>&1 || { echo "brew not found"; return 1; }

  if [[ ! -f "$file" ]]; then
    echo "Brewfile not found: $file"
    return 1
  fi

  brew bundle check --no-upgrade --file="$file"
}

# Show Homebrew tap trust state and doctor warnings without changing anything.
# Usage:
#   brewtrustcheck
brewtrustcheck() {
  command -v brew >/dev/null 2>&1 || { echo "brew not found"; return 1; }

  echo "== Trusted Homebrew entries =="
  brew trust

  echo
  echo "== Untrusted Homebrew entries =="
  brew untrust

  echo
  echo "== Homebrew doctor =="
  brew doctor
}

# Show outdated Homebrew formulae and casks without upgrading anything.
# Use before brewup when you want to preview what would change.
# Usage:
#   brewoutdated
brewoutdated() {
  command -v brew >/dev/null 2>&1 || { echo "brew not found"; return 1; }
  brew outdated --greedy
}

# Simulate and then re-stow this dotfiles repo after confirmation.
#
# Warning:
#   The confirmed step updates managed symlinks in your home directory.
#
# Usage:
#   dotstow
dotstow() {
  emulate -L zsh

  local repo="$HOME/dotfiles"
  local packages=(zsh tmux git starship)
  local agent_package=agents
  local confirm

  command -v stow >/dev/null 2>&1 || { echo "stow not found"; return 1; }

  if [[ ! -d "$repo" ]]; then
    echo "Dotfiles repo not found: $repo"
    return 1
  fi

  echo "Previewing Stow changes from: $repo"
  echo "Packages: ${packages[*]} $agent_package"
  echo

  (cd "$repo" && stow --simulate --verbose "${packages[@]}") || {
    echo "Stow simulation failed. Nothing was changed."
    return 1
  }
  (cd "$repo" && stow --simulate --no-folding --verbose "$agent_package") || {
    echo "Agent-package Stow simulation failed. Nothing was changed."
    return 1
  }

  echo
  echo "Simulation passed. Review the output above before continuing."
  read "confirm?Type STOW to continue: "

  if [[ "$confirm" != "STOW" ]]; then
    echo "Cancelled."
    return 1
  fi

  (cd "$repo" && stow --restow --verbose "${packages[@]}") &&
    (cd "$repo" && stow --restow --no-folding --verbose "$agent_package")
}

# Check only the symlinks managed by this dotfiles repo.
# Avoids scanning runtime/cache trees such as FNM multishell state.
# Usage:
#   dotlinks
dotlinks() {
  emulate -L zsh

  local -a links=(
    "$HOME/.zshrc"
    "$HOME/.zprofile"
    "$HOME/.zshenv"
    "$HOME/.zlogin"
    "$HOME/.oh-my-zsh/custom/aliases.zsh"
    "$HOME/.oh-my-zsh/custom/functions.zsh"
    "$HOME/.oh-my-zsh/custom/completions.zsh"
    "$HOME/.tmux.conf"
    "$HOME/.gitconfig"
    "$HOME/.config/starship.toml"
  )
  local link
  local failures=0

  for link in "${links[@]}"; do
    if [[ -L "$link" && -e "$link" ]]; then
      echo "ok: $link -> $(readlink "$link")"
    elif [[ -L "$link" ]]; then
      echo "broken: $link -> $(readlink "$link")"
      (( failures++ ))
    elif [[ -e "$link" ]]; then
      echo "not a symlink: $link"
      (( failures++ ))
    else
      echo "missing: $link"
      (( failures++ ))
    fi
  done

  echo
  if (( failures == 0 )); then
    echo "All ${#links[@]} managed symlinks are healthy."
    return 0
  fi

  echo "$failures managed symlink check(s) failed."
  return 1
}

# Run a fast, read-only check of core tools, managed links, and local toolchains.
# Does not start daemons, install packages, or apply Stow changes.
# Usage:
#   dotdoctor
dotdoctor() {
  emulate -L zsh

  local repo="$HOME/dotfiles"
  local -a packages=(zsh tmux git starship)
  local agent_package=agents
  local -a links=(
    "$HOME/.zshrc"
    "$HOME/.zprofile"
    "$HOME/.zshenv"
    "$HOME/.zlogin"
    "$HOME/.oh-my-zsh/custom/aliases.zsh"
    "$HOME/.oh-my-zsh/custom/functions.zsh"
    "$HOME/.oh-my-zsh/custom/completions.zsh"
    "$HOME/.tmux.conf"
    "$HOME/.gitconfig"
    "$HOME/.config/starship.toml"
  )
  local -a expected=(
    "$repo/zsh/.zshrc"
    "$repo/zsh/.zprofile"
    "$repo/zsh/.zshenv"
    "$repo/zsh/.zlogin"
    "$repo/zsh/.oh-my-zsh/custom/aliases.zsh"
    "$repo/zsh/.oh-my-zsh/custom/functions.zsh"
    "$repo/zsh/.oh-my-zsh/custom/completions.zsh"
    "$repo/tmux/.tmux.conf"
    "$repo/git/.gitconfig"
    "$repo/starship/.config/starship.toml"
  )
  local failures=0
  local warnings=0
  local cmd
  local i
  local link
  local target
  local git_status
  local required=(brew stow git zsh tmux starship fzf fd rg zoxide)
  local optional=(fnm node npm eza code fvm adb docker orb)

  echo "== Required commands =="
  for cmd in "${required[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      echo "ok: $cmd"
    else
      echo "missing: $cmd"
      (( failures++ ))
    fi
  done

  echo
  echo "== Optional commands =="
  for cmd in "${optional[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      echo "ok: $cmd"
    else
      echo "optional missing: $cmd"
      (( warnings++ ))
    fi
  done

  echo
  echo "== Repository =="
  if [[ -d "$repo/.git" ]]; then
    echo "ok: $repo"
    git_status=$(git -C "$repo" status --short --untracked-files=all 2>/dev/null)
    if [[ -n "$git_status" ]]; then
      echo "warning: repository has staged or unstaged changes"
      (( warnings++ ))
    else
      echo "ok: working tree clean"
    fi
  else
    echo "missing: $repo"
    (( failures++ ))
  fi

  echo
  echo "== Managed symlinks =="
  for (( i = 1; i <= ${#links[@]}; i++ )); do
    link="${links[$i]}"
    target="${expected[$i]}"

    if [[ -L "$link" && ! -e "$link" ]]; then
      echo "broken: $link -> $(readlink "$link")"
      (( failures++ ))
    elif [[ -L "$link" && "${link:A}" == "${target:A}" ]]; then
      echo "ok: $link"
    elif [[ -L "$link" ]]; then
      echo "wrong target: $link -> $(readlink "$link")"
      (( failures++ ))
    elif [[ -e "$link" ]]; then
      echo "not symlink: $link"
      (( failures++ ))
    else
      echo "missing: $link"
      (( failures++ ))
    fi
  done

  echo
  echo "== Stow simulation =="
  if command -v stow >/dev/null 2>&1 && [[ -d "$repo" ]]; then
    if (cd "$repo" &&
      stow --simulate --verbose "${packages[@]}" >/dev/null 2>&1 &&
      stow --simulate --no-folding --verbose "$agent_package" >/dev/null 2>&1); then
      echo "ok: ${packages[*]} $agent_package (--no-folding)"
    else
      echo "failed: simulate ${packages[*]} and $agent_package with --no-folding"
      (( failures++ ))
    fi
  else
    echo "skipped: stow or repository unavailable"
    (( warnings++ ))
  fi

  echo
  echo "== Agent skills =="
  if [[ -x "$repo/scripts/agent-skills" ]]; then
    if "$repo/scripts/agent-skills" status; then
      echo "ok: agent skills"
    else
      echo "failed: run $repo/scripts/agent-skills status for details"
      (( failures++ ))
    fi
  else
    echo "missing: $repo/scripts/agent-skills"
    (( failures++ ))
  fi

  echo
  echo "== Toolchains =="
  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew: $(command -v brew)"
  fi
  if command -v node >/dev/null 2>&1; then
    echo "Node: $(node --version 2>/dev/null)"
  fi
  if command -v npm >/dev/null 2>&1; then
    echo "npm: $(npm --version 2>/dev/null)"
  fi

  local fvm_default="$HOME/fvm/default"
  if [[ -e "$fvm_default/bin/flutter" ]]; then
    echo "ok: FVM default -> ${fvm_default:A}"
  else
    echo "optional missing: FVM default Flutter SDK"
    (( warnings++ ))
  fi

  local android_home="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
  if [[ -d "$android_home" ]]; then
    echo "ok: Android SDK at $android_home"
  else
    echo "optional missing: Android SDK at $android_home"
    (( warnings++ ))
  fi

  if command -v docker >/dev/null 2>&1; then
    local docker_context
    docker_context=$(docker context show 2>/dev/null)
    echo "Docker context: ${docker_context:-unavailable}"
    if [[ "$docker_context" == "orbstack" && ! -S "$HOME/.orbstack/run/docker.sock" ]]; then
      echo "warning: OrbStack Docker socket is not running"
      (( warnings++ ))
    fi
  fi

  echo
  echo "== Summary =="
  if (( failures == 0 )); then
    echo "Passed with $warnings warning(s)."
    return 0
  fi

  echo "Failed: $failures check(s), $warnings warning(s)."
  return 1
}

# ─────────────────────────────
# 🌐 Network Helpers
# ─────────────────────────────

# Show the current Wi-Fi interface and network name.
# Use when local networking is odd and you need to confirm the active Wi-Fi.
# Usage:
#   wifiinfo
wifiinfo() {
  command -v networksetup >/dev/null 2>&1 || {
    echo "networksetup not found"
    return 1
  }

  local iface
  local default_iface
  local ip_addr
  local ssid
  local networksetup_ssid

  iface=$(
    networksetup -listallhardwareports 2>/dev/null \
      | awk '/Hardware Port: Wi-Fi|Hardware Port: AirPort/ { getline; print $2; exit }'
  )

  if [[ -z "$iface" ]]; then
    echo "Wi-Fi interface not found."
    return 1
  fi

  default_iface=$(route -n get default 2>/dev/null | awk '/interface:/ { print $2; exit }')
  ip_addr=$(ipconfig getifaddr "$iface" 2>/dev/null)
  ssid=$(
    ipconfig getsummary "$iface" 2>/dev/null \
      | awk -F ' : ' '/^[[:space:]]*SSID[[:space:]]:/ { print $2; exit }'
  )

  if [[ -z "$ssid" ]]; then
    networksetup_ssid=$(networksetup -getairportnetwork "$iface" 2>/dev/null)
    case "$networksetup_ssid" in
      "Current Wi-Fi Network: "*)
        ssid="${networksetup_ssid#Current Wi-Fi Network: }"
        ;;
    esac
  fi

  echo "Wi-Fi Interface: $iface"
  echo "Default Interface: ${default_iface:-unknown}"
  echo "IP Address: ${ip_addr:-unavailable}"
  case "$ssid" in
    "Current Wi-Fi Network: "*)
      echo "SSID: ${ssid#Current Wi-Fi Network: }"
      ;;
    *"not associated"*)
      echo "SSID: not connected or unavailable"
      ;;
    "")
      echo "SSID: not connected or unavailable"
      ;;
    *)
      echo "SSID: $ssid"
      ;;
  esac
}

# Run a quick network health check.
# Use when you want to confirm internet reachability, DNS, and public IP quickly.
# Usage:
#   nettest
nettest() {
  emulate -L zsh

  echo "Internet:"
  if ping -c 1 -W 1000 1.1.1.1 >/dev/null 2>&1; then
    echo "  ok: reached 1.1.1.1"
  else
    echo "  fail: could not reach 1.1.1.1"
  fi

  echo "DNS:"
  if command -v dscacheutil >/dev/null 2>&1; then
    if dscacheutil -q host -a name example.com >/dev/null 2>&1; then
      echo "  ok: resolved example.com"
    else
      echo "  fail: could not resolve example.com"
    fi
  elif command -v dig >/dev/null 2>&1; then
    if dig +time=2 +tries=1 example.com >/dev/null 2>&1; then
      echo "  ok: resolved example.com"
    else
      echo "  fail: could not resolve example.com"
    fi
  else
    echo "  skipped: no DNS lookup command found"
  fi

  echo "Public IP:"
  if (( ${+aliases[publicip]} )); then
    local ip
    ip=$(eval "${aliases[publicip]}" 2>/dev/null)
    if [[ -n "$ip" ]]; then
      echo "  $ip"
    else
      echo "  unavailable"
    fi
  elif command -v curl >/dev/null 2>&1; then
    local ip
    ip=$(curl --connect-timeout 2 -fsSL ifconfig.me 2>/dev/null)
    if [[ -n "$ip" ]]; then
      echo "  $ip"
    else
      echo "  unavailable"
    fi
  else
    echo "  skipped: publicip alias and curl unavailable"
  fi
}

# ─────────────────────────────
# 🔧 Git Helpers
# ─────────────────────────────

# Add, commit, and push current HEAD quickly.
# Warning: runs `git add .`, commits, and pushes the current branch.
# Usage:
#   gcommit "feat: add login validation"
gcommit() {
  if [[ -z "$1" ]]; then
    echo 'Usage: gcommit "your message here"'
    return 1
  fi

  git add . && git commit -m "$1" && git push origin HEAD
}

# Create and switch to a new branch.
# Usage:
#   gcreate feature/my-branch
gcreate() {
  if [[ -z "$1" ]]; then
    echo "Usage: gcreate <branch-name>"
    return 1
  fi

  git checkout -b "$1"
}

# Generate a Conventional Commit message from staged Git changes.
# Uses Codex in read-only mode and prints only the message on success.
# Usage:
#   git add <files>
#   gmsg
gmsg() {
  emulate -L zsh

  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "Not inside a git repo" >&2
    return 1
  }

  git diff --cached --quiet --exit-code && {
    echo "No staged changes found. Stage files first with: git add <files>" >&2
    return 1
  }

  command -v codex >/dev/null 2>&1 || {
    echo "codex CLI not found" >&2
    return 1
  }

  local repo_root
  local msg_file
  local message
  local prompt

  repo_root=$(git rev-parse --show-toplevel) || return 1
  msg_file=$(mktemp "${TMPDIR:-/tmp}/gmsg.XXXXXX") || return 1

  prompt='Generate a Git commit message for the staged changes only.

Requirements:
- Inspect only staged changes. Use `git diff --cached` and related staged-only commands.
- Do not inspect unstaged changes.
- Do not modify files.
- Follow Conventional Commits.
- Keep the summary line at 72 characters or fewer.
- Add a body only if it is useful.
- Return only the commit message text.
- Do not wrap the message in Markdown fences or quotes.'

  {
    codex exec --sandbox read-only --ephemeral --cd "$repo_root" --output-last-message "$msg_file" "$prompt" >/dev/null || {
      echo "Failed to generate commit message with codex" >&2
      return 1
    }

    message=$(awk '
      NF { seen = 1 }
      seen { lines[++n] = $0 }
      END {
        while (n && lines[n] == "") n--
        for (i = 1; i <= n; i++) print lines[i]
      }
    ' "$msg_file")

    if [[ -z "$message" ]]; then
      echo "Generated commit message was empty." >&2
      return 1
    fi

    print -r -- "$message"
  } always {
    rm -f "$msg_file"
  }
}

# Generate a commit message with gmsg, show it, and commit only after confirmation.
# Uses `git commit -F` so multi-line messages are preserved.
# Usage:
#   git add <files>
#   gci
gci() {
  emulate -L zsh

  local msg_file
  local reply

  msg_file=$(mktemp "${TMPDIR:-/tmp}/gci.XXXXXX") || return 1
  {
    gmsg > "$msg_file" || return 1

    if [[ ! -s "$msg_file" ]]; then
      echo "Generated commit message was empty." >&2
      return 1
    fi

    echo "Generated commit message:"
    echo
    cat "$msg_file"
    echo

    read "reply?Commit with this message? [y/N] "
    case "$reply" in
      [yY]|[yY][eE][sS])
        git commit -F "$msg_file"
        return $?
        ;;
      *)
        echo "Commit cancelled."
        return 0
        ;;
    esac
  } always {
    rm -f "$msg_file"
  }
}

# Interactively delete merged local Git branches.
#
# Use when:
#   - You have many old local feature branches
#   - Branches have already been merged
#   - You want to clean local branches safely using fzf
#
# What it does:
#   - Verifies you are inside a Git repo
#   - Fetches and prunes remote-tracking branches
#   - Lists only merged local branches
#   - Excludes main/master/develop/dev
#   - Excludes the currently checked-out branch
#   - Lets you multi-select branches with fzf
#   - Deletes selected branches using safe `git branch -d`
#
# Notes:
#   - `git branch -d` refuses to delete unmerged branches.
#   - This does not delete remote branches.
#
# Usage:
#   gclean
#   git-clean-branches
git-clean-branches() {
  emulate -L zsh

  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "Not inside a git repo"
    return 1
  }

  echo "Fetching remote..."
  git fetch -p || return 1

  local current_branch
  current_branch=$(git branch --show-current)

  local branches
  branches=$(
    git branch --merged \
      | sed 's/^[*[:space:]]*//' \
      | grep -Ev '^(main|master|develop|dev)$' \
      | grep -vx "$current_branch" \
      | grep -v '^$'
  )

  if [[ -z "$branches" ]]; then
    echo "No merged branches to clean."
    return 0
  fi

  local selected
  selected=$(
    print -r -- "$branches" \
      | fzf -m --preview 'git log --oneline --decorate --graph --color=always -- {}'
  )

  [[ -z "$selected" ]] && {
    echo "Cancelled."
    return 0
  }

  print -r -- "$selected" | while IFS= read -r branch; do
    git branch -d -- "$branch"
  done
}

# Create a Git worktree for a branch under ../<repo>-<branch>.
# Use when you need to work on another branch without disturbing this checkout.
# Usage:
#   gwtc feature/login
#   gwtc feature/login ../login-work
gwtc() {
  emulate -L zsh

  if [[ -z "$1" ]]; then
    echo "Usage: gwtc <branch> [path]"
    return 1
  fi

  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "Not inside a git repo"
    return 1
  }

  local branch="$1"
  local repo_name
  local safe_branch
  local path

  repo_name=$(basename "$(git rev-parse --show-toplevel)")
  safe_branch="${branch//\//-}"
  path="${2:-../${repo_name}-${safe_branch}}"

  if [[ -e "$path" ]]; then
    echo "Worktree path already exists: $path"
    return 1
  fi

  git worktree add "$path" "$branch" && echo "Worktree created: $path"
}

# List Git worktrees with paths, branches, and HEAD commits.
# Use before switching context or cleaning old worktrees.
# Usage:
#   gwtl
gwtl() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "Not inside a git repo"
    return 1
  }

  git worktree list
}

# Copy the current Git branch name to the clipboard.
# Use when you need to paste a branch name into a PR, ticket, or message.
# Usage:
#   gbcopy
gbcopy() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "Not inside a git repo"
    return 1
  }

  local branch
  branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)

  if [[ -z "$branch" ]]; then
    echo "Detached HEAD; no branch name to copy."
    return 1
  fi

  if command -v pbcopy >/dev/null 2>&1; then
    print -r -- "$branch" | pbcopy
    echo "Copied: $branch"
  else
    echo "pbcopy not found. Branch: $branch"
    return 1
  fi
}

# Copy the latest commit short hash to the clipboard.
# Use when you need a commit reference for CI, deploy notes, or debugging.
# Usage:
#   ghash
ghash() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "Not inside a git repo"
    return 1
  }

  local hash
  hash=$(git rev-parse --short HEAD 2>/dev/null) || return 1

  if command -v pbcopy >/dev/null 2>&1; then
    print -r -- "$hash" | pbcopy
    echo "Copied: $hash"
  else
    echo "pbcopy not found. Hash: $hash"
    return 1
  fi
}

# ─────────────────────────────
# ⚡ Fuzzy Helpers
# ─────────────────────────────

# Open a file selected via fd + fzf.
# Much faster than scanning blindly with plain fzf.
# Usage:
#   fo
fzf-open() {
  command -v fd >/dev/null 2>&1 || { echo "fd not found"; return 1; }
  command -v fzf >/dev/null 2>&1 || { echo "fzf not found"; return 1; }

  local preview_cmd
  if command -v bat >/dev/null 2>&1; then
    preview_cmd='bat --style=numbers --color=always {} | head -100'
  else
    preview_cmd='sed -n "1,100p" {}'
  fi

  local file
  file=$(command fd --type f --hidden --exclude .git . 2>/dev/null | fzf --preview="$preview_cmd" --height=40%)

  [[ -n "$file" ]] && _dotfiles_edit "$file"
}

# Search file contents using ripgrep, then open a selected file.
# Usage:
#   searchf login
#   fzf-content "FormEntryScreen"
fzf-content() {
  if [[ -z "$1" ]]; then
    echo "Usage: fzf-content <search-term>"
    return 1
  fi

  command -v rg >/dev/null 2>&1 || { echo "rg not found"; return 1; }
  command -v fzf >/dev/null 2>&1 || { echo "fzf not found"; return 1; }

  local preview_cmd
  if command -v bat >/dev/null 2>&1; then
    preview_cmd='bat --style=numbers --color=always {} | head -100'
  else
    preview_cmd='sed -n "1,100p" {}'
  fi

  local file
  file=$(rg --files-with-matches "$1" . 2>/dev/null | fzf --preview="$preview_cmd")

  [[ -n "$file" ]] && _dotfiles_edit "$file"
}

# Interactive live grep using ripgrep + fzf.
#
# Use when:
#   - You want to search inside files interactively
#   - You do not know the exact file name
#   - You want preview + line-number based opening in VS Code
#
# How it works:
#   - Opens fzf first
#   - Type your search query inside fzf
#   - ripgrep reloads matches live
#   - Selecting a result opens the file at the matched line
#
# Notes:
#   - Alias is `fgl`, not `fg`, because `fg` is reserved for shell job control.
#   - Requires `rg` and `fzf`.
#   - Uses `bat` for preview if available.
#
# Usage:
#   fgl
#   fglive
fglive() {
  command -v rg >/dev/null 2>&1 || { echo "rg not found"; return 1; }
  command -v fzf >/dev/null 2>&1 || { echo "fzf not found"; return 1; }

  local preview_cmd

  if command -v bat >/dev/null 2>&1; then
    preview_cmd='bat --style=numbers --color=always {1} --highlight-line {2}'
  else
    preview_cmd='sed -n "1,120p" {1}'
  fi

  local result
  result=$(
    fzf --ansi \
        --disabled \
        --delimiter ':' \
        --preview "$preview_cmd" \
        --bind 'change:reload:rg --line-number --no-heading --color=always {q} . 2>/dev/null || true'
  )

  [[ -z "$result" ]] && return

  local file line
  file=$(echo "$result" | cut -d: -f1)
  line=$(echo "$result" | cut -d: -f2)

  if command -v code >/dev/null 2>&1; then
    code -g "$file:$line"
  else
    _dotfiles_edit "$file"
  fi
}

# ─────────────────────────────
# 📔 Daily Worklog Template
# ─────────────────────────────

# Create or open today's markdown work log.
# Usage:
#   journal
#   dailylog
dailylog() {
  local today="$HOME/Projects/logs/$(date +%Y-%m-%d).md"
  mkdir -p "$(dirname "$today")"

  if [[ ! -f "$today" ]]; then
    cat <<EOF > "$today"
# 🗓️ Work Log — $(date '+%A, %B %d, %Y')

## ✅ Done
- 

## 🔧 In Progress
- 

## ⏭️ Next Up
- 

## 🧠 Notes / Learnings
- 

## 🤔 Blockers
- 

EOF
  fi

  _dotfiles_edit "$today"
}

# ─────────────────────────────
# 📟 tmux Helpers
# ─────────────────────────────

# Pick an existing tmux session or create a new one.
# Usage:
#   tm
#   tmuxx
tmuxx() {
  local session
  session=$((tmux ls -F "#{session_name}" 2>/dev/null; echo "[new]") | fzf --prompt="tmux session ▶ ")

  [[ -z "$session" ]] && return

  if [[ "$session" == "[new]" ]]; then
    read "session?New session name: "
    [[ -z "$session" ]] && return
    tmux new-session -s "$session"
  else
    tmux attach -t "$session" 2>/dev/null || tmux new-session -s "$session"
  fi
}

# Open a project from zoxide into its own tmux session.
# Reuses an existing session if present.
# Named `sessionize` to avoid conflict with the system `proj` binary.
# Usage:
#   sessionize
sessionize() {
  local dir
  dir=$(zoxide query -l | fzf --prompt="project ▶ ")

  [[ -z "$dir" ]] && return

  local name
  name=$(basename "$dir")

  if tmux has-session -t "$name" 2>/dev/null; then
    tmux attach -t "$name"
  else
    tmux new-session -s "$name" -c "$dir"
  fi
}

# Create a quick 3-pane dev session inside a chosen project.
# Uses the project folder name as the tmux session name.
# Good for editor / terminal / logs workflow.
# Usage:
#   tmuxdev
tmuxdev() {
  local dir
  dir=$(zoxide query -l | fzf --prompt="project ▶ ")
  [[ -z "$dir" ]] && return

  local name
  name=$(basename "$dir")
  local first_pane

  if tmux has-session -t "$name" 2>/dev/null; then
    tmux attach -t "$name"
    return
  fi

  first_pane=$(tmux new-session -d -P -F '#{pane_id}' -s "$name" -c "$dir") || return 1
  tmux split-window -t "$first_pane" -h -c "$dir"
  tmux split-window -t "$first_pane" -v -c "$dir"
  tmux select-pane -t "$first_pane"
  tmux attach -t "$name"
}

# ─────────────────────────────
# 🚀 zoxide + fzf
# ─────────────────────────────

# Jump to a recent/frequent directory using zoxide + fzf.
#
# Use when:
#   - You want to jump quickly to a project or folder
#   - You do not want to type long paths
#   - You want an interactive directory picker
#
# How it works:
#   - Uses zoxide history first
#   - Shows recent/frequent directories in fzf
#   - Shows a preview:
#       - Git log if the directory is a Git repo
#       - Directory listing otherwise
#   - If zoxide has no history yet, falls back to fd directory search under $HOME
#
# Notes:
#   - First use: zoxide needs history. `cd` into a few folders normally first.
#   - Alias is usually `zz`.
#   - Requires `zoxide` and `fzf`.
#   - Uses `fd` for fallback search.
#   - Uses `eza` for preview if available.
#
# Usage:
#   zz
#   zoxfz
zoxfz() {
  local dir
  local first

  if ! command -v zoxide >/dev/null 2>&1; then
    echo "zoxide not found"
    return 1
  fi

  first=$(zoxide query -l 2>/dev/null | head -n 1)

  if [[ -z "$first" ]]; then
    echo "No zoxide history yet. Falling back to fd directory search..."
    dir=$(command fd --type d --hidden --exclude .git . "$HOME" 2>/dev/null | fzf --prompt="jump ▶ ")
    [[ -n "$dir" ]] && cd "$dir"
    return
  fi

  dir=$(
    zoxide query -l 50 \
      | fzf --prompt="jump ▶ " \
            --preview='
              if [ -d "{}/.git" ]; then
                git -C "{}" --no-pager log --oneline --decorate --graph -10
              else
                eza -1 --icons --color=always "{}" | head -40
              fi
            '
  )

  [[ -n "$dir" ]] && cd "$dir"
}

# ─────────────────────────────
# 📋 taskwarrior Helpers
# ─────────────────────────────

# Pick a pending task interactively.
# Usage:
#   task-fzf
task-fzf() {
  local id
  id=$(task status:pending rc.report.next.columns=id,description rc.report.next.labels=on \
    | sed -E 's/^ +//' \
    | fzf --prompt="tasks ▶ " \
    | awk '{print $1}')

  [[ -n "$id" ]] && task "$id"
}

# ─────────────────────────────
# 🧹 Maintenance Helpers
# ─────────────────────────────

# Show concise MacBook battery and charging status.
# Use when you want terminal-visible battery state without opening macOS UI.
# Usage:
#   battery
battery() {
  command -v pmset >/dev/null 2>&1 || {
    echo "pmset not found"
    return 1
  }

  pmset -g batt | awk '
    NR == 1 { source = $0; sub(/^Now drawing from /, "", source); gsub(/'\''/, "", source) }
    NR == 2 {
      gsub(/^[[:space:]]+/, "")
      split($0, parts, ";")
      percent = parts[1]
      status = parts[2]
      time = parts[3]
      if (match(percent, /[0-9]+%/)) percent = substr(percent, RSTART, RLENGTH)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", percent)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", status)
      sub(/[[:space:]]*present: true$/, "", time)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", time)
      print "Power: " source
      print "Battery: " percent
      if (status != "") print "Status: " status
      if (time != "") print "Time: " time
    }
  '
}

# Empty the current user's macOS Trash safely.
#
# Why this exists:
#   The old alias used `rm -rf ~/.Trash/*`, which was fast but too easy to
#   trigger accidentally and did not ask for confirmation. This function shows
#   the Trash size and item count first, then requires explicit confirmation.
#
# When to use:
#   - After checking Trash size with `trashsize`
#   - When you are sure you no longer need the files in Trash
#   - When you want to empty Trash from terminal instead of Finder
#
# Warning:
#   This permanently removes files from ~/.Trash. It does not move them
#   somewhere else. There is no normal undo after this.
#
# Usage:
#   emptytrash
emptytrash() {
  local trash_dir="$HOME/.Trash"

  if [[ ! -d "$trash_dir" ]]; then
    echo "Trash directory not found: $trash_dir"
    return 1
  fi

  local size
  local count
  size=$(du -sh "$trash_dir" 2>/dev/null | awk '{print $1}')
  count=$(find "$trash_dir" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | tr -d ' ')

  if [[ "$count" == "0" ]]; then
    echo "Trash is already empty."
    return 0
  fi

  echo "WARNING: This will permanently empty your macOS Trash."
  echo "Trash: $trash_dir"
  echo "Size : ${size:-unknown}"
  echo "Items: $count"
  echo

  read "confirm?Type EMPTY to permanently delete these files: "

  if [[ "$confirm" != "EMPTY" ]]; then
    echo "Cancelled."
    return 1
  fi

  find "$trash_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  echo "Trash emptied."
}

# Clean user cache files safely with confirmation.
#
# Why this exists:
#   The old version immediately removed everything under ~/Library/Caches.
#   That is usually safe, but it is still an aggressive cleanup and should not
#   happen accidentally. This function shows the cache size first and requires
#   explicit confirmation.
#
# When to use:
#   - macOS apps feel bloated or cache-heavy
#   - You want to reclaim local disk space
#   - You are not in the middle of active work
#
# Warning:
#   Apps may recreate cache files later and may feel slower briefly after this.
#   Some cache files may be skipped if currently in use.
#
# Usage:
#   cleanmac
cleanmac() {
  local cache_dir="$HOME/Library/Caches"

  if [[ ! -d "$cache_dir" ]]; then
    echo "Cache directory not found: $cache_dir"
    return 1
  fi

  local size
  local count
  size=$(du -sh "$cache_dir" 2>/dev/null | awk '{print $1}')
  count=$(find "$cache_dir" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | tr -d ' ')

  if [[ "$count" == "0" ]]; then
    echo "User cache directory is already empty."
    return 0
  fi

  echo "WARNING: This will remove user cache files."
  echo "Cache: $cache_dir"
  echo "Size : ${size:-unknown}"
  echo "Items: $count"
  echo
  echo "Avoid running this during active work."
  echo

  read "confirm?Type CLEAN to remove user cache files: "

  if [[ "$confirm" != "CLEAN" ]]; then
    echo "Cancelled."
    return 1
  fi

  find "$cache_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} + 2>/dev/null
  echo "Done. Some cache files may be skipped if they were in use."
}

# Homebrew cleanup.
# Removes unused dependencies and old Homebrew downloads.
# Usage:
#   cleanbrew
cleanbrew() {
  command -v brew >/dev/null 2>&1 || { echo "brew not found"; return 1; }
  brew autoremove && brew cleanup -s
}

# npm cache verification / cleanup.
# Usage:
#   cleannpm
cleannpm() {
  command -v npm >/dev/null 2>&1 || { echo "npm not found"; return 1; }
  npm cache verify
}

# Yarn cache cleanup.
# Deletes Yarn's package cache; installs may need to re-download packages.
# Usage:
#   cleanyarn
cleanyarn() {
  command -v yarn >/dev/null 2>&1 || { echo "yarn not found"; return 1; }
  yarn cache clean
}

# Flutter / Dart cleanup with confirmation.
#
# Use when:
#   - Flutter build behaves weirdly
#   - Simulator cache causes odd issues
#   - Dart analysis/server feels stuck
#
# Warning:
#   This removes simulator caches and Dart server cache. It does not touch
#   project source files, but apps/tools may rebuild caches afterwards.
#
# Note:
#   This expects `flutter` to be available as a command.
#   If you only use FVM and do not have global flutter in PATH,
#   prefer running `f clean` inside the project.
#
# Usage:
#   cleanfluttercache
cleanfluttercache() {
  command -v flutter >/dev/null 2>&1 || { echo "flutter not found"; return 1; }

  echo "WARNING: This will clean Flutter build output and local Flutter/Dart caches."
  echo "It does not delete project source files."
  echo

  read "confirm?Type FLUTTERCLEAN to continue: "

  if [[ "$confirm" != "FLUTTERCLEAN" ]]; then
    echo "Cancelled."
    return 1
  fi

  echo "Cleaning Flutter and simulator caches..."
  flutter clean 2>/dev/null || true

  local sim_cache="$HOME/Library/Developer/CoreSimulator/Caches"
  [[ -d "$sim_cache" ]] && find "$sim_cache" -mindepth 1 -maxdepth 1 -exec rm -rf {} +

  rm -rf "$HOME/.dartServer"

  echo "Done."
}

# Remove Xcode DerivedData safely with confirmation.
#
# Use when:
#   - Xcode/iOS builds are stuck
#   - Old DerivedData is taking too much space
#   - Flutter iOS build behaves oddly
#
# Warning:
#   This does not delete source code, but Xcode will rebuild indexes/build data.
#
# Usage:
#   cleanderived
cleanderived() {
  local derived_dir="$HOME/Library/Developer/Xcode/DerivedData"

  if [[ ! -d "$derived_dir" ]]; then
    echo "DerivedData directory not found: $derived_dir"
    return 0
  fi

  local size
  size=$(du -sh "$derived_dir" 2>/dev/null | awk '{print $1}')

  echo "WARNING: This will remove Xcode DerivedData."
  echo "Path: $derived_dir"
  echo "Size: ${size:-unknown}"
  echo

  read "confirm?Type DERIVED to continue: "

  if [[ "$confirm" != "DERIVED" ]]; then
    echo "Cancelled."
    return 1
  fi

  find "$derived_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} + 2>/dev/null
  echo "Removed Xcode DerivedData."
}

# ─────────────────────────────
# 🧹 neatCLI Helpers
# ─────────────────────────────

# Generate neatCLI zsh completions.
# Writes ~/.zfunc/_neatcli and reloads completions.
# Usage:
#   neatcomp
neatcomp() {
  mkdir -p "$HOME/.zfunc"
  neatcli completions zsh > "$HOME/.zfunc/_neatcli"
  compinit
  echo "neatCLI completions installed & reloaded"
}

# Preview organizing any folder by type.
# Usage:
#   neatpreview
#   neatpreview ~/Downloads
neatpreview() {
  local dir="${1:-.}"
  neatcli organize "$dir" --by-type --show-all-files
}

# Execute organizing any folder by type.
# Moves files according to neatCLI's organization rules after confirmation.
# Usage:
#   neatexec ~/Downloads
neatexec() {
  local dir="${1:-.}"
  echo "This will organize: $dir"
  echo

  read "confirm?Type YES to continue: "

  if [[ "$confirm" != "YES" ]]; then
    echo "Cancelled."
    return 1
  fi

  neatcli organize "$dir" --by-type --execute
}

# Find duplicates in any folder.
# Usage:
#   neatdups
#   neatdups ~/Downloads
neatdups() {
  local dir="${1:-.}"
  neatcli duplicates "$dir"
}

# Trash duplicate files after confirmation.
# Moves detected duplicates to Trash using neatCLI.
# Usage:
#   neatdupsx ~/Downloads
neatdupsx() {
  local dir="${1:-.}"
  echo "This will move duplicate files in $dir to Trash."
  echo

  read "confirm?Type YES to continue: "

  if [[ "$confirm" != "YES" ]]; then
    echo "Cancelled."
    return 1
  fi

  neatcli duplicates "$dir" --delete --trash --execute
}

# Organize photos by EXIF date taken.
# Usage:
#   neatphotos ~/Pictures
neatphotos() {
  local dir="${1:-.}"
  neatcli organize "$dir" --by-date-taken
}

# Execute photo organization by EXIF date taken.
# Moves photo files according to neatCLI's date-taken rules after confirmation.
# Usage:
#   neatphotosx ~/Pictures
neatphotosx() {
  local dir="${1:-.}"
  echo "This will organize photos in $dir by EXIF date taken."
  echo

  read "confirm?Type YES to continue: "

  if [[ "$confirm" != "YES" ]]; then
    echo "Cancelled."
    return 1
  fi

  neatcli organize "$dir" --by-date-taken --execute
}

# Show folder stats.
# Usage:
#   neatstats
#   neatstats ~/Downloads
neatstats() {
  local dir="${1:-.}"
  neatcli stats "$dir"
}

# Safe Downloads cleanup workflow.
# Step 1: stats
# Step 2: preview organization
# Step 3: check duplicates
# Step 4: optionally execute
# Usage:
#   dlclean
dlclean() {
  local dir="$HOME/Downloads"

  echo "📊 Downloads stats:"
  neatcli stats "$dir"

  echo ""
  echo "🧹 Preview organization:"
  neatcli organize "$dir" --by-type --show-all-files

  echo ""
  echo "🔍 Duplicate check:"
  neatcli duplicates "$dir"

  echo ""
  echo "Nothing was changed."
  echo "Run 'dlcleanx' to execute the organization."
}

# Execute Downloads organization safely.
# Moves files in ~/Downloads by type after confirmation.
# Usage:
#   dlcleanx
dlcleanx() {
  local dir="$HOME/Downloads"

  echo "This will organize: $dir"
  echo "Files can be restored using: nundo"
  echo ""

  read "confirm?Type YES to continue: "

  if [[ "$confirm" != "YES" ]]; then
    echo "Cancelled."
    return 1
  fi

  neatcli organize "$dir" --by-type --execute

  echo ""
  echo "Done. If something looks wrong, run:"
  echo "  nundo"
}

# Clean old Downloads files safely by moving to Trash.
# Default: older than 30 days.
# Usage:
#   dlold
#   dlold 60d
dlold() {
  local dir="$HOME/Downloads"
  local age="${1:-30d}"

  neatcli clean "$dir" --older-than "$age" --trash
}

# Execute old Downloads cleanup.
# Moves old files from ~/Downloads to Trash after confirmation.
# Usage:
#   dloldx
#   dloldx 60d
dloldx() {
  local dir="$HOME/Downloads"
  local age="${1:-30d}"

  echo "This will move files older than $age from Downloads to Trash."
  echo ""

  read "confirm?Type YES to continue: "

  if [[ "$confirm" != "YES" ]]; then
    echo "Cancelled."
    return 1
  fi

  neatcli clean "$dir" --older-than "$age" --trash --execute
}

# ─────────────────────────────
# 🐳 OrbStack / Docker Functions
# ─────────────────────────────

# Show complete OrbStack + Docker health.
# Use when Docker commands behave oddly or context/version looks wrong.
# Usage:
#   docker-health
docker-health() {
  echo "== OrbStack =="
  orb status 2>/dev/null || echo "OrbStack is not running or orb CLI is unavailable"

  echo
  echo "== OrbStack Config =="
  orb config show | grep -E "cpu|memory_mib|rosetta|k8s.enable|docker.expose_ports_to_lan|machines.expose_ports_to_lan|mount_hide_shared|docker.set_context" 2>/dev/null

  echo
  echo "== Docker Contexts =="
  docker context ls

  echo
  echo "== Docker CLI =="
  which -a docker

  echo
  echo "== Docker Version =="
  docker version

  echo
  echo "== Compose Version =="
  docker compose version

  echo
  echo "== Running Containers =="
  docker ps
}

# Force Docker CLI to use OrbStack.
# Usage:
#   docker-use-orb
docker-use-orb() {
  docker context use orbstack
  docker context ls
}

# Full OrbStack restart.
# Useful after config changes.
# Stops and starts OrbStack, then restores the Docker context.
# Usage:
#   orbreload
orbreload() {
  orb stop && orb start
  docker context use orbstack >/dev/null 2>&1
  orb status
}

# Restart only OrbStack Docker engine.
# Use when containers/compose are stuck but OrbStack itself is fine.
# Usage:
#   docker-restart
docker-restart() {
  orb restart docker
  docker version
}

# Stop/remove Docker Compose containers and volumes after confirmation.
#
# Warning:
#   This can delete local Postgres/MySQL/Redis data for the current project.
#
# Usage:
#   dcdv
#   docker-compose-down-volumes
docker-compose-down-volumes() {
  echo "WARNING: This will run docker compose down -v in:"
  pwd
  echo
  echo "Compose volumes often contain local database data."
  echo

  read "confirm?Type VOLUMES to continue: "

  if [[ "$confirm" != "VOLUMES" ]]; then
    echo "Cancelled."
    return 1
  fi

  docker compose down -v
}

# Remove unused Docker volumes after confirmation.
#
# Warning:
#   Volumes often contain database data.
#
# Usage:
#   dvprune
#   docker-volume-prune
docker-volume-prune() {
  echo "WARNING: This will remove unused Docker volumes."
  echo "Volumes often contain local database data."
  echo

  read "confirm?Type VOLUMES to continue: "

  if [[ "$confirm" != "VOLUMES" ]]; then
    echo "Cancelled."
    return 1
  fi

  docker volume prune
}

# Open shell inside a running container.
# Tries bash first, then sh.
# Usage:
#   dsh container_name
#   dsh container_name bash
#   dsh container_name sh
dsh() {
  if [[ -z "$1" ]]; then
    echo "Usage: dsh <container-name-or-id> [bash|sh]"
    return 1
  fi

  local container="$1"
  local shell="${2:-}"

  if [[ -n "$shell" ]]; then
    docker exec -it "$container" "$shell"
    return
  fi

  docker exec -it "$container" bash 2>/dev/null || docker exec -it "$container" sh
}

# Follow logs for a container.
# Usage:
#   dlogs container_name
dlogs() {
  if [[ -z "$1" ]]; then
    echo "Usage: dlogs <container-name-or-id>"
    return 1
  fi

  docker logs -f "$1"
}

# Show container IP address.
# Usage:
#   dip container_name
dip() {
  if [[ -z "$1" ]]; then
    echo "Usage: dip <container-name-or-id>"
    return 1
  fi

  docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
}

# Show mapped ports for a container.
# Usage:
#   dports container_name
dports() {
  if [[ -z "$1" ]]; then
    echo "Usage: dports <container-name-or-id>"
    return 1
  fi

  docker port "$1"
}

# Inspect a container/image/volume/network.
# Usage:
#   dinspect container_name
dinspect() {
  if [[ -z "$1" ]]; then
    echo "Usage: dinspect <docker-object-name-or-id>"
    return 1
  fi

  docker inspect "$1"
}

# Remove stopped containers only.
# Docker asks for confirmation before pruning.
# Usage:
#   docker-clean-containers
docker-clean-containers() {
  echo "This removes stopped containers only."
  docker container prune
}

# Safe Docker cleanup.
# Removes stopped containers, unused networks, dangling images, and build cache.
# Does NOT remove volumes.
# Docker asks for confirmation before pruning.
# Usage:
#   docker-clean-safe
docker-clean-safe() {
  echo "This removes:"
  echo "- stopped containers"
  echo "- unused networks"
  echo "- dangling images"
  echo "- build cache"
  echo
  echo "It does NOT remove Docker volumes."
  echo

  docker system prune
}

# Hard Docker cleanup.
# WARNING: removes unused images and volumes.
# Can delete local DB data.
# Usage:
#   docker-clean-hard
docker-clean-hard() {
  echo "WARNING:"
  echo "This removes:"
  echo "- stopped containers"
  echo "- unused networks"
  echo "- unused images"
  echo "- build cache"
  echo "- unused volumes"
  echo
  echo "This can delete local Postgres/MySQL/Redis data stored in Docker volumes."
  echo

  read "confirm?Type DELETE to continue: "

  if [[ "$confirm" == "DELETE" ]]; then
    docker system prune -a --volumes
  else
    echo "Cancelled."
  fi
}

# Show Docker disk usage.
# Usage:
#   docker-disk
docker-disk() {
  docker system df -v
}

_valid_tcp_port() {
  emulate -L zsh
  [[ "$1" == <-> ]] && (( 10#$1 >= 1 && 10#$1 <= 65535 ))
}

_local_dev_password() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 16
  elif command -v uuidgen >/dev/null 2>&1; then
    uuidgen | tr -d '-'
  else
    echo "Cannot generate a password: openssl and uuidgen are unavailable." >&2
    return 1
  fi
}

# Quick temporary PostgreSQL container for testing.
#
# Use when:
#   - You need a fast local Postgres DB for Spring Boot/Node testing
#   - You do not want to write a full compose.yaml yet
#
# Default connection:
#   Host: localhost
#   Port: 5432
#   DB: testdb
#   User: mugilan
#   Password: generated for each container
#
# Notes:
#   - Port publishing is restricted to 127.0.0.1
#   - Container name is fixed: pgquick
#   - If it already exists, run pgquickrm first
#   - Use a different port if 5432 is busy: pgquick 5433
#
# Usage:
#   pgquick
#   pgquick 5433
pgquick() {
  emulate -L zsh

  local port="${1:-5432}"
  local password
  local reply

  command -v docker >/dev/null 2>&1 || { echo "docker not found"; return 1; }
  _valid_tcp_port "$port" || {
    echo "Invalid TCP port: $port"
    return 1
  }

  read "reply?Start temporary PostgreSQL on 127.0.0.1:$port? [y/N] "
  case "$reply" in
    [yY]|[yY][eE][sS]) ;;
    *) echo "Cancelled."; return 1 ;;
  esac

  password=$(_local_dev_password) || return 1

  docker run --name pgquick \
    -e POSTGRES_DB=testdb \
    -e POSTGRES_USER=mugilan \
    -e POSTGRES_PASSWORD="$password" \
    -p "127.0.0.1:$port:5432" \
    -d postgres:16 || return 1

  echo "Postgres running:"
  echo "Host: 127.0.0.1"
  echo "Port: $port"
  echo "DB: testdb"
  echo "User: mugilan"
  echo "Password: $password"
  echo "Save the generated password for this temporary container."
}

# Stop and remove the temporary pgquick PostgreSQL container.
#
# Use when:
#   - You are done testing
#   - You want to recreate pgquick cleanly
# Warning:
#   Force-removes the fixed `pgquick` container if it exists.
#
# Usage:
#   pgquickrm
pgquickrm() {
  docker rm -f pgquick
}

# Quick temporary Redis container for testing.
#
# Use when:
#   - You need Redis for Spring Boot/Node testing
#   - You want to test cache/session/queue behavior quickly
#
# Notes:
#   - Port publishing is restricted to 127.0.0.1
#   - Authentication uses a generated password
#   - Container name is fixed: redisquick
#   - If it already exists, run redisquickrm first
#   - Use a different port if 6379 is busy: redisquick 6380
#
# Usage:
#   redisquick
#   redisquick 6380
redisquick() {
  emulate -L zsh

  local port="${1:-6379}"
  local password
  local reply

  command -v docker >/dev/null 2>&1 || { echo "docker not found"; return 1; }
  _valid_tcp_port "$port" || {
    echo "Invalid TCP port: $port"
    return 1
  }

  read "reply?Start temporary Redis on 127.0.0.1:$port? [y/N] "
  case "$reply" in
    [yY]|[yY][eE][sS]) ;;
    *) echo "Cancelled."; return 1 ;;
  esac

  password=$(_local_dev_password) || return 1

  docker run --name redisquick \
    -p "127.0.0.1:$port:6379" \
    -d redis:7 redis-server --requirepass "$password" || return 1

  echo "Redis running on 127.0.0.1:$port"
  echo "Password: $password"
  echo "Connect with: redis-cli -h 127.0.0.1 -p $port -a '<password>'"
}

# Stop and remove the temporary redisquick Redis container.
#
# Warning:
#   Force-removes the fixed `redisquick` container if it exists.
#
# Usage:
#   redisquickrm
redisquickrm() {
  docker rm -f redisquick
}

# ─────────────────────────────
# 🧭 Alias / Function Namespace Helpers
# ─────────────────────────────

# Check whether a name is already used by zsh.
#
# Why this exists:
#   Before creating a new alias or function, you can check whether the name is
#   already taken by an alias, function, builtin command, external command, or
#   zsh reserved word.
#
# When to use:
#   - Before adding a new alias
#   - Before adding a new function
#   - When a command behaves unexpectedly
#   - When you want to know whether a short name like "dcu", "gs", "k", etc. is safe
#
# Usage:
#   namecheck dcu
#   namecheck docker
#   namecheck dcu docker-health pgquick
#
# Example:
#   namecheck dcu
#
# Output meaning:
#   ✅ Free      -> safe to use as a new alias/function name
#   ⚠️ Not free -> name already exists somewhere
namecheck() {
  emulate -L zsh

  if [[ $# -eq 0 ]]; then
    echo "Usage: namecheck <name> [name2 name3 ...]"
    return 1
  fi

  local name
  local found

  for name in "$@"; do
    echo
    echo "== $name =="

    found=0

    if (( ${+aliases[$name]} )); then
      echo "Alias: ${aliases[$name]}"
      found=1
    fi

    if (( ${+functions[$name]} )); then
      echo "Function: defined"
      found=1
    fi

    if (( ${+builtins[$name]} )); then
      echo "Builtin: zsh builtin"
      found=1
    fi

    if (( ${+commands[$name]} )); then
      echo "Command: ${commands[$name]}"
      found=1
    fi

    if (( ${+reswords[$name]} )); then
      echo "Reserved word: zsh reserved word"
      found=1
    fi

    if (( found == 0 )); then
      echo "✅ Free: you can use this name"
    else
      echo "⚠️ Not free: this name already exists"
      echo
      whence -va "$name" 2>/dev/null
    fi
  done
}


# Count how many times a command/alias/function appears in your zsh history.
#
# Why this exists:
#   zsh does not automatically tell you whether you actually use your aliases
#   and functions. This searches your shell history and gives a rough usage count.
#
# When to use:
#   - When cleaning your dotfiles
#   - Before deleting old aliases/functions
#   - To find whether a shortcut is actually useful
#   - To compare whether you use the alias or the full command more often
#
# Usage:
#   usedcount dcu
#   usedcount docker-health
#   usedcount pgquick
#
# Example:
#   usedcount dcu
#
# Output:
#   dcu used 12 time(s) in shell history
#
# Note:
#   This is history-based, so it is not perfect. If old history was deleted,
#   the count will only reflect the history currently available.
usedcount() {
  emulate -L zsh

  if [[ -z "$1" ]]; then
    echo "Usage: usedcount <command-or-alias-name>"
    return 1
  fi

  local name="$1"
  local count

  # Token-based match instead of regex-based grep.
  # This works better for aliases like `..` and `...`, where dots would
  # otherwise behave like regex wildcards.
  count=$(
    fc -l 1 2>/dev/null \
      | awk -v target="$name" '
          {
            $1=""
            sub(/^ /, "")
            n = split($0, parts, /[[:space:];|&]+/)
            for (i = 1; i <= n; i++) {
              if (parts[i] == target) c++
            }
          }
          END { print c + 0 }
        '
  )

  echo "$name used $count time(s) in shell history"
}
