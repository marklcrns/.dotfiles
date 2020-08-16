#!/bin/bash

APT_PACKAGES_DESKTOP_APPLICATION=(
  "libreoffice"
  "flameshot"
  "gimp"
)

echolog
echolog "${UL_NC}Installing Desktop Apps Packages${NC}"
echolog

apt_bulk_install ${APT_PACKAGES_DESKTOP_APPLICATION[@]}

# Peek
if sudo add-apt-repository ppa:peek-developers/stable -y; then
  apt_install peek
fi

# # Wine
# ## Installation
# sudo dpkg --add-architecture i386
# if wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -; then
#   if sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' -y; then
#     apt_install "--install-recommends winehq-stable" 1
#     # Setup
#     winecfg
#   fi
#   # PlayOnLinux
#   apt_install playonlinux
# fi

