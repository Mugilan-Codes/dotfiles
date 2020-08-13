# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias reloadshell="source $HOME/.zshrc"
alias c="clear"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"

# Git
alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."