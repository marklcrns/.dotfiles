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

