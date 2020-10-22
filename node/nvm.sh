# (https://github.com/nvm-sh/nvm)
# NVM_VERSION="v0.36.0"

# Command is used to find the latest tag and set it to NVM_VERSION
NVM_VERSION=$(git ls-remote --tags --sort=-version:refname --refs https://github.com/nvm-sh/nvm | head -n1 | sed 's/.*\///')

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

if command -v nvm 1>/dev/null 2>&1; then
    echo "==> NVM already exists"
else 
    echo "==> Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
fi

# echo "==> Installing Latest Node Version..."
# nvm install node

# echo "==> Installing Latest Node LTS Version..."
# nvm install --lts