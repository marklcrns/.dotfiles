#!/bin/bash

# Session Manager Packages

APT_PACKAGES_SESSION_MANAGER=(
  "tmux"
  "tmuxinator"
  "gawk"
  "urlview"
)

PIP3_PACKAGES_SESSION_MANAGER=(
  "spotify-cli-linux"
)

echolog
echolog "${UL_NC}Installing Session Manager Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_SESSION_MANAGER[@]}"
pip_bulk_install 3 "${PIP3_PACKAGES_SESSION_MANAGER[@]}"

# Tmuxinator
git_clone "https://github.com/marklcrns/.tmuxinator" "${HOME}"
# Tmux plugin manager
git_clone "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins"

