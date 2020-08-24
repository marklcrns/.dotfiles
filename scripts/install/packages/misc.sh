#!/bin/bash

# Misc Packages

APT_PACKAGES_MISC=(
  "screenfetch"
  "neofetch"
  "htop"
  "colordiff"
  "cmatrix"
  "cowsay"
  "xcowsay"
  "figlet"
  "lolcat"
  "fortune"
  "sl"
  "taskwarrior"
  "timewarrior"
)

echolog
echolog "${UL_NC}Installing Misc Packages${NC}"
echolog

# Bashtop
apt_add_repo "bashtop-monitor/bashtop" 1
apt_install "bashtop" 1

# Glances
pip_install 3 "glances"

apt_bulk_install "${APT_PACKAGES_MISC[@]}"

# Battery saving tool
apt_install tlp && sudo tlp start

# Tldr
[[ ! -d "${HOME}/bin" ]] && mkdir -p "${HOME}/bin"
curl -o ~/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr && \
  chmod +x ~/bin/tldr

