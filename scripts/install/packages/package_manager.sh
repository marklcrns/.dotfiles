#!/bin/bash

APT_PACKAGES_PACKAGE_MANAGER=(
  "npm"
  "yarn;update"
)

NPM_PACKAGES_PACKAGE_MANAGER=(
  "browser-sync"
  "gulp-cli"
)

echolog
echolog "${UL_NC}Installing Package Manager Packages${NC}"
echolog

# NVM/NodeJS
if curl_install "https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash"; then
  LATESTNPM=`nvm ls-remote | tail -1 | sed 's/^.*\(v[0-9\.]\)/\1/'`
  ## install latest npm
  nvm install $LATESTNPM
  nvm use $LATESTNPM
  nvm alias default $LATESTNPM
fi

# Yarn (Needs to go before APT_PACKAGES_PACKAGE_MANAGER installation)
# Alternative
curl -o- -L https://yarnpkg.com/install.sh | bash
# Not working
# curl_install "https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -"
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt_bulk_install "${APT_PACKAGES_PACKAGE_MANAGER[@]}"
npm_bulk_install "${NPM_PACKAGES_PACKAGE_MANAGER[@]}"

# Solves Missing write access to /usr/local/lib error
# https://flaviocopes.com/npm-fix-missing-write-access-error/
sudo chown -R ${USER} /usr/local/lib/node_modules
# Update npm to latest version
npm install -g npm@latest
