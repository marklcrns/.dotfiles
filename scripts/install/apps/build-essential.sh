#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
  running "Found you use mac"
  brew install bat
  brew install ripgrep
  brew install --HEAD universal-ctags/universal-ctags/universal-ctags
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  running "Found you use Linux"

  if [ "$(uname -o)" == "Android" ]; then
    # Android Termux
    if [ -x "$(command -v pkg)" ];then pkg install bat ripgrep taskwarrior; fi
  else
    if [ -x "$(command -v apk)" ];then sudo apk add bat ripgrep xclip zenity zeal taskwarrior ccls; fi
    if [ -x "$(command -v pkg)" ];then sudo pkg install bat ripgrep xclip zenity zeal taskwarrior ccls; fi
    if [ -x "$(command -v pacman)" ];then sudo pacman -S bat ripgrep xclip zenity zeal taskwarrior ccls; fi
    if [ -x "$(command -v apt)" ]; then sudo apt install bat ripgrep xclip zenity zeal taskwarrior ccls; fi
    if [ -x "$(command -v dnf)" ]; then sudo dnf install bat ripgrep xclip zenity zeal taskwarrior ccls; fi
    if [ -x "$(command -v nix-env)" ]; then sudo nix-env -i bat ripgrep xclip zenity zeal taskwarrior ccls; fi
    if [ -x "$(command -v zypper)" ]; then sudo zypper install bat ripgrep xclip zenity zeal taskwarrior ccls; fi
  fi
fi
apt_install "build-essential"
