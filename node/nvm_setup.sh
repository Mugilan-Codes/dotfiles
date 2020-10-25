# (https://github.com/nvm-sh/nvm)
# NVM_VERSION="v0.36.0"

# Command is used to find the latest tag and set it to NVM_VERSION
# NVM_VERSION=$(git ls-remote --tags --sort=-version:refname --refs https://github.com/nvm-sh/nvm | head -n1 | sed 's/.*\///')

# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

# if command -v nvm 1>/dev/null 2>&1; then
#     echo "==> NVM already exists"
#     echo "==> Updating NVM..."
# else 
#     echo "==> Installing NVM..."
# fi

# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

# echo "==> Installing Latest Node Version..."
# nvm install node

# echo "==> Installing Latest Node LTS Version..."
# nvm install --lts