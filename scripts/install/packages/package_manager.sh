#!/bin/bash

NPM_PACKAGES_PACKAGE_MANAGER=(
  "browser-sync"
  "gulp-cli"
)

echolog
echolog "${UL_NC}Installing Package Manager Packages${NC}"
echolog

# Install Node.js via nvm
if curl_install "https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash"; then

# source bashrc or zshrc
  if [[ -n ${BASH_VERSION} ]]; then
    source ~/.bashrc
  elif [[ -n ${ZSH_VERSION} ]]; then
    source ~/.zshrc
  fi

  # Source nvm script
  source $NVM_DIR/nvm.sh

  nvm install node
  nvm use node
  nvm alias default node
fi

npm_bulk_install 1 "${NPM_PACKAGES_PACKAGE_MANAGER[@]}"

# Yarn (Needs to go before APT_PACKAGES_PACKAGE_MANAGER installation)
curl_install "https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -"
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt_install "yarn" 1

# Cargo
curl_install "https://sh.rustup.rs | sh"

