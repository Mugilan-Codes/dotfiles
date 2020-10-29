rm -rf $HOME/.gitconfig
ln -s $DOTFILES/git/config $HOME/.gitconfig

rm -rf $HOME/.gitignore_global
ln -s $DOTFILES/git/ignore $HOME/.gitignore_global

# Set Project Directories & Clone Github repositories
./clone.sh