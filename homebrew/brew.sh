if [ ! $(which brew) ]; then
  echo "==> Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  echo "==> Homebrew already exists."
fi

brew update

brew tap homebrew/bundle
echo "==> Installing Brew Files..."
brew bundle

brew upgrade
brew cleanup