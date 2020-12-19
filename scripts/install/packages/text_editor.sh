#!/bin/bash

NPM_PACKAGES_TEXT_EDITOR=(
  "neovim"
  "eslint"
  "stylelint"
  "prettier"
)

echolog
echolog "${UL_NC}Installing Text Editors Packages${NC}"
echolog

if apt_add_repo "ppa:neovim-ppa/unstable" 2; then
  apt_install "neovim" 1
fi

npm_bulk_install 1 "${NPM_PACKAGES_TEXT_EDITOR[@]}"
pip_install 3 "neovim"

