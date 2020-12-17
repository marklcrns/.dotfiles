#!/bin/bash

# Browser Packages

echolog
echolog "${UL_NC}Installing Browser Packages${NC}"
echolog

# Google Chrome
if wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"; then
  sudo apt install ./google-chrome-stable_current_amd64.deb -y
fi

