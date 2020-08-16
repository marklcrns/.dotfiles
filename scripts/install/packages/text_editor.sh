#!/bin/bash

APT_PACKAGES_TEXT_EDITOR=(
  "neovim"
  "python-neovim" # Deprecated, not found
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


# Install python and python3 env in nvim root directory
cd ${HOME}/.config/nvim
## python3 host prog
mkdir -p env/python3 && cd env/python3
python3 -m venv env && \
  source env/bin/activate && \
  pip_bulk_install 3 "${PIP3_PACKAGES_TEXT_EDITOR_NEOVIM[@]}" && \
  deactivate

## python2 host prog (DEPRECATED)
# mkdir -p env/python && cd env/python
# python -m venv env && \
#   source env/bin/activate && \
#   pip install neovim tasklib send2trash vim-vint flake8 pylint autopep8 && \
#   deactivate

# Personal neovim config files
git_clone "https://github.com/marklcrns/ThinkVim" "${HOME}/.config/nvim/"

## Clone Vimwiki wikis
[[ -d "${HOME}/Docs/wiki" ]] && rm -rf ~/Docs/wiki
git_clone "https://github.com/marklcrns/wiki" "${HOME}/Docs/wiki" && \
  git_clone "https://github.com/marklcrns/wiki-wiki" "${HOME}/Docs/wiki/wiki"

## Kite
# bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"
