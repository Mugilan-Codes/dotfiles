if [ ! -e ~/.oh-my-zsh ]; then
  echo "Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh-My-Zsh installation is skipped"
fi

echo "==> Symlinking .zshrc file"
rm -rf $HOME/.zshrc
ln -s $DOTFILES/zsh/.zshrc $HOME/.zshrc

echo "==> Installing Custom zsh plugins..."
ZSH_CUSTOM=$DOTFILES/zsh/custom

echo "===> zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo "===> zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

echo "===> autoupdate"
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate

echo "==> Symlinking .p10k.zsh file"
rm -rf $HOME/.p10k.zsh
ln -s $DOTFILES/zsh/.p10k.zsh $HOME/.p10k.zsh