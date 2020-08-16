#!/bin/bash

# Fonts

echolog
echolog "${UL_NC}Installing Fonts${NC}"
echolog

sudo cp "${SCRIPTDIR}/../../fonts/Haskplex-Nerd-Regular.ttf" "/usr/local/share/fonts"
sudo cp "${SCRIPTDIR}/../../fonts/Sauce Code Pro Nerd Font Complete.ttf" "/usr/local/share/fonts"

