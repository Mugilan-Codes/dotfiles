if [ ! -e ~/.oh-my-zsh ]; then
  echo "Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh-My-Zsh installation is skipped"
fi

rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc

DOTFILES=$HOME/.dotfiles
ZSH_CUSTOM=$DOTFILES/zsh/custom
# Plugins install
# zsh-nvm 
git clone https://github.com/lukechilds/zsh-nvm $ZSH_CUSTOM/plugins/zsh-nvm
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

rm -rf $HOME/.p10k.zsh
ln -s $HOME/.dotfiles/zsh/.p10k.zsh $HOME/.p10k.zsh