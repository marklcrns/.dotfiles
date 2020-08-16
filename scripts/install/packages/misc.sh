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

apt_bulk_install "${APT_PACKAGES_MISC[@]}"

# Battery saving tool
apt_install tlp && sudo tlp start

# Tldr
mkdir -p ~/bin
curl -o ~/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr && \
  chmod +x ~/bin/tldr

# Taskwarrior & Timewarrior
if apt_install taskwarrior timewarrior -y; then
  pip3 install --user git+git://github.com/tbabej/tasklib@develop && \
  pip install --user git+git://github.com/tbabej/tasklib@develop
  # Personal Timewarrior configuration files
  git_clone "https://github.com/marklcrns/.timewarrior" "${HOME}/.timewarrior"
  # Taskwarrior hooks
  if git clone https://github.com/marklcrns/.task ~/.task; then
    ln -s ${HOME}/.task/.taskrc ${HOME}/.taskrc && \
      cd ${HOME}/.task/hooks && \
        sudo chmod +x on-modify-pirate on-add-pirate on-modify.timewarrior
    if pip_install 3 "taskwarrior-time-tracking-hook"; then
      ln -s `which taskwarrior_time_tracking_hook` "~/.task/hooks/on-modify.timetracking"
    fi
  fi
fi

