# # ─────────────────────────────
# # 🛠 Shell & Config
# # ─────────────────────────────
# alias reload="omz reload"
# alias reloadall="source ~/.zshenv && source ~/.zprofile && source ~/.zshrc"

# alias zshconfig="code ~/.zshrc"
# alias aliases="code ~/.oh-my-zsh/custom/aliases.zsh"
# alias functions="code ~/.oh-my-zsh/custom/functions.zsh"

# # Quality-of-life nav
# alias ..="cd .."
# alias ...="cd ../.."
# alias c="clear"

# # ─────────────────────────────
# # 🚀 Flutter / Dart (via FVM)
# # ─────────────────────────────
# alias f="fvm flutter"
# alias fd="fvm dart"
# alias fv=".fvm/flutter_sdk/bin/flutter"

# alias frefresh="f clean && f pub get"
# alias fbuildrunner="f pub run build_runner build --delete-conflicting-outputs"
# alias fwatchrunner="f pub run build_runner watch --delete-conflicting-outputs"
# alias fdoctor="f doctor"
# alias flog="f logs"

# # ─────────────────────────────
# # ⚛ React Native (USB / WiFi debug)
# # ─────────────────────────────
# # WiFi Debugging
# alias rnwifi='adb kill-server && adb tcpip 5555 && adb connect 192.168.0.105:5555 && adb devices'
# alias rnreset='watchman watch-del-all && rm -rf node_modules && npm install && npm start -- --reset-cache'

# # ─────────────────────────────
# # 🧰 Node / PNPM / Dev
# # ─────────────────────────────
# alias pn="pnpm"
# alias pni="pn install"
# alias pnr="pn run"
# alias dev="pn dev"
# alias lint="pn lint"
# alias test="pn test"

# # ─────────────────────────────
# # 🔧 Git
# # (avoid aliasing gst, gco, gcmsg, etc. used by oh-my-zsh git plugin)
# # ─────────────────────────────
# alias ga="git add ."
# alias gnew="git checkout -b"
# alias gclean="git-clean-branches"   # interactive safe branch cleanup

# # ─────────────────────────────
# # 🌐 Network / Port
# # ─────────────────────────────
# alias ports="lsof -iTCP -sTCP:LISTEN -n -P"
# alias serve="python3 -m http.server 8080"

# # ─────────────────────────────
# # 💽 System / Maintenance
# # ─────────────────────────────
# alias update="brew update && brew upgrade && brew autoremove && brew cleanup -s"
# alias fixperm="sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}"

# # ─────────────────────────────
# # 🗃 Projects
# # ─────────────────────────────
# alias cdp="cd ~/Projects"
# alias cdw="cd ~/dev/work/vzlabs"
# alias cdapp="cd ~/Projects/Work/appverse-mobileapp"

# # ─────────────────────────────
# # 📹 Media
# # ─────────────────────────────
# # Download YouTube videos in best quality
# alias ytdownload='yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b"'
# alias fixaudio="sudo kill -9 \`ps ax | grep 'coreaudio[a-z]' | awk '{print \$1}'\`"

# # ─────────────────────────────
# # 🧠 Productivity
# # ─────────────────────────────
# alias fo="fzf-open"        # open files via fuzzy finder
# alias searchf="fzf-content" # search file contents via fuzzy finder
# alias journal="dailylog"   # create/edit daily work log markdown

# # ─────────────────────────────
# # 📋 Task CLI (taskwarrior)
# # ─────────────────────────────
# alias t="task"
# alias ta="task add"
# alias tl="task list"
# alias td="task done"
# # alias tn="task-fzf"      # optional: interactive picker via function

# # ─────────────────────────────
# # 📟 tmux quick-attach / create
# # ─────────────────────────────
# alias tm="tmuxx"           # interactive tmux launcher

# # ─────────────────────────────
# # 🚀 zoxide + fzf auto-cd
# # ─────────────────────────────
# alias zz="zoxfz"           # jump to recent dir

# ====== REMOVE ABOVE LINES ======

# ~/.oh-my-zsh/custom/aliases.zsh

# ─────────────────────────────
# 🛠 Shell & Config
# ─────────────────────────────
alias reload="omz reload"
alias rz="exec zsh"
alias rzl="exec zsh -l"

alias zshconfig="code ~/.zshrc"
alias zprofile="code ~/.zprofile"
alias zshenv="code ~/.zshenv"
alias zlogin="code ~/.zlogin"
alias aliases="code ~/.oh-my-zsh/custom/aliases.zsh"
alias functions="code ~/.oh-my-zsh/custom/functions.zsh"
alias completions="code ~/.oh-my-zsh/custom/completions.zsh"

# ─────────────────────────────
# 🧭 Navigation
# ─────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias c="clear"

# ─────────────────────────────
# 🚀 Flutter / Dart (via FVM)
# ─────────────────────────────
alias f="fvm flutter"
alias fd="fvm dart"
alias fv=".fvm/flutter_sdk/bin/flutter"

alias frefresh="f clean && f pub get"
alias fbuildrunner="f pub run build_runner build --delete-conflicting-outputs"
alias fwatchrunner="f pub run build_runner watch --delete-conflicting-outputs"
alias fdoctor="f doctor"
alias flog="f logs"

# ─────────────────────────────
# ⚛ React Native (USB / WiFi debug)
# ─────────────────────────────
alias rnwifi='adb kill-server && adb tcpip 5555 && adb connect 192.168.0.105:5555 && adb devices'
alias rnreset='watchman watch-del-all && rm -rf node_modules && npm install && npm start -- --reset-cache'

# ─────────────────────────────
# 🧰 Node / PNPM / Dev
# ─────────────────────────────
alias pn="pnpm"
alias pni="pn install"
alias pnr="pn run"
alias pna="pn add"
alias pnad="pn add -D"
alias pnx="pn dlx"
alias dev="pn dev"
alias lint="pn lint"
alias test="pn test"

# ─────────────────────────────
# 🔧 Git
# (avoid aliasing gst, gco, gcmsg, etc. used by oh-my-zsh git plugin)
# ─────────────────────────────
alias ga="git add ."
alias gnew="git checkout -b"
alias gclean="git-clean-branches"

# ─────────────────────────────
# 🌐 Network / Port
# ─────────────────────────────
alias ports="lsof -iTCP -sTCP:LISTEN -n -P"
alias serve="python3 -m http.server 8080"

# ─────────────────────────────
# 💽 System / Maintenance
# ─────────────────────────────
alias update="brew update && brew upgrade && brew autoremove && brew cleanup -s"
alias topmem="ps aux | sort -nr -k 4 | head -15"
alias topcpu="ps aux | sort -nr -k 3 | head -15"
alias ram="top -o mem"
alias cpu="top -o cpu"
alias bt="btop"
alias du1="du -d 1 -h . | sort -h"
alias trashsize="du -sh ~/.Trash"
alias emptytrash="rm -rf ~/.Trash/*"

# ─────────────────────────────
# 🗃 Projects
# ─────────────────────────────
alias cdp="cd ~/Projects"
alias cdw="cd ~/dev/work/vzlabs"
alias cdapp="cd ~/Projects/Work/appverse-mobileapp"

# ─────────────────────────────
# 📹 Media
# ─────────────────────────────
alias ytdownload='yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/bv*+ba/b"'

# ─────────────────────────────
# 🧠 Productivity
# ─────────────────────────────
alias fo="fzf-open"
alias searchf="fzf-content"
alias journal="dailylog"
alias fdf="fd --hidden --exclude .git"

# ─────────────────────────────
# 📋 Task CLI (taskwarrior)
# ─────────────────────────────
alias t="task"
alias ta="task add"
alias tl="task list"
alias td="task done"

# ─────────────────────────────
# 📟 tmux quick-attach / create
# ─────────────────────────────
alias tm="tmuxx"

# ─────────────────────────────
# 🚀 zoxide + fzf auto-cd
# ─────────────────────────────
alias zz="zoxfz"