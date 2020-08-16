#!/bin/bash

# Windows Manager Packages

APT_PACKAGES_DESKTOP_WINDOW_MANAGER=(
"dwm"
"suckless-tools"
"xdm"
"dmenu"
"xorg"
)

echolog
echolog "${UL_NC}Installing Windows Manager Packages${NC}"
echolog

# DWM
# Ref: https://medium.com/hacker-toolbelt/dwm-windows-manager-in-ubuntu-14958224a782
## If asked, choose XDM as display manager (you can even remove gdm3: sudo apt-get remove gdm3)
# if apt_bulk_install "${APT_PACKAGES_DESKTOP_WINDOW_MANAGER[@]}"; then
#   echo dwm > ${HOME}.xsession
# fi
