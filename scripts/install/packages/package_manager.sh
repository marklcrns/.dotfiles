#!/bin/bash

APT_PACKAGES_PACKAGE_MANAGER=(
  "npm"
)

NPM_PACKAGES_PACKAGE_MANAGER=(
  "browser-sync"
  "gulp-cli"
)

echolog
echolog "${UL_NC}Installing Package Manager Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_PACKAGE_MANAGER[@]}"
npm_bulk_install "${NPM_PACKAGES_PACKAGE_MANAGER[@]}"

# Solves Missing write access to /usr/local/lib error
# https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
mkdir ${HOME}/.npm-global
npm config set prefix "${HOME}/.npm-global"

# Update npm to latest version
npm install -g npm@latest

# NVM/NodeJS
if curl_install "https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash"; then
  # source bashrc or zshrc
  if [[ -n ${BASH_VERSION} ]]; then
    source ~/.bashrc
  elif [[ -n ${ZSH_VERSION} ]]; then
    source ~/.zshrc
  fi
  # Install latest nvm and set to default
  export LATEST_NPM="$(nvm ls-remote | tail -1 | sed 's/^.*\(v[0-9\.]\)/\1/')"
  ## install latest npm
  nvm install ${LATEST_NPM}
  nvm use ${LATEST_NPM}
  nvm alias default ${LATEST_NPM}
fi

# Yarn (Needs to go before APT_PACKAGES_PACKAGE_MANAGER installation)
curl_install "https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -"
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt_install "yarn" 1

# Cargo
curl_install "https://sh.rustup.rs | sh"

