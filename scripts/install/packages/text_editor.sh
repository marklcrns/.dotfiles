#!/bin/bash

APT_PACKAGES_TEXT_EDITOR=(
  "neovim"
  "python3-neovim"
  # Dependencies
  "yad"
  "zenity"
)

NPM_PACKAGES_TEXT_EDITOR=(
  "neovim"
  "eslint"
  "stylelint"
  "prettier"
)

PIP3_PACKAGES_TEXT_EDITOR_NEOVIM=(
  "wheel"
  "neovim"
  "tasklib"
  "send2trash"
  "vim-vint"
  "flake8"
  "pylint"
  "autopep8"
)

echolog
echolog "${UL_NC}Installing Text Editors Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_TEXT_EDITOR[@]}"
npm_bulk_install 1 "${NPM_PACKAGES_TEXT_EDITOR[@]}"

# Personal neovim config files
git_clone "https://github.com/marklcrns/ThinkVim" "${HOME}/.config/nvim/"
# Install nvim configs dependencies
if cd ${HOME}/.config/nvim; then
  scripts/install.sh
fi

# Clone Vimwiki wikis
[[ -d "${HOME}/Docs/wiki" ]] && rm -rf ~/Docs/wiki
[[ ! -d "${HOME}/Docs" ]] && mkdir -p "${HOME}/Docs"
git_clone "https://github.com/marklcrns/wiki" "${HOME}/Docs/wiki" && \
  git_clone "https://github.com/marklcrns/wiki-wiki" "${HOME}/Docs/wiki/wiki"

## Kite
# bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"

