if [ ! -e ~/.oh-my-zsh ]; then
  echo "Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh-My-Zsh installation is skipped"
fi

rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc

# Plugins install
# zsh-nvm 
# zsh-autosuggestions 
# zsh-syntax-highlighting

# Theme Install
# powerlevel10k

rm -rf $HOME/.p10k.zsh
ln -s $HOME/.dotfiles/zsh/.p10k.zsh $HOME/.p10k.zsh