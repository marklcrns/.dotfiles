#!/bin/bash

# File Manager Packages

APT_PACKAGES_FILE_MANAGER=(
  "ranger"
  "caca-utils"
  "highlight"
  "atool"
  "w3m"
  "w3m-img"
  "zathura"
  "xdotool"
  "poppler-utils"
  "mediainfo"
  "mupdf"
  "mupdf-tools"
)

echolog
echolog "${UL_NC}Installing File Manager Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_FILE_MANAGER[@]}"

# Copy default ranger config
ranger --copy-config=all
# Devicons
git_clone "https://github.com/alexanderjeurissen/ranger_devicons" "${HOME}/.config/ranger/plugins"

