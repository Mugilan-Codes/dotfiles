# Print short status and log of latest commits:
git_status_short() {
  if [[ -z $(git status -s) ]]; then
    echo 'Nothing to commit, working tree clean\n'
  else
    git status -s && echo ''
  fi
  git log -${1:-3} --oneline | cat
}

git_count() {
  echo "$(git rev-list --count HEAD) commits total up to current HEAD"
}