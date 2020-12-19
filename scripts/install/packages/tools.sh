#!/bin/bash

# Tools Packages

APT_PACKAGES_TOOLS=(
  "tree"
  "xclip"
  "xdg-utils"
  "fd-find"
  "mlocate"
  "autojump"
  "ripgrep"
  "neofetch"
  "htop"
  "neomutt"
)


echolog
echolog "${UL_NC}Installing Tools Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_TOOLS[@]}"

# Rclone
curl_install "https://rclone.org/install.sh | sudo bash"

# Fzf
if git_clone "--depth=1 https://github.com/junegunn/fzf.git" "${DOWNLOADS_DIR}/.fzf"; then
  "${DOWNLOADS_DIR}/.fzf/install"
fi

