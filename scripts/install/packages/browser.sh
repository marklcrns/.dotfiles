#!/bin/bash

# Browser Packages


APT_PACKAGES_BROWSER_APPLICATION=(
  "firefox"
)

echolog
echolog "${UL_NC}Installing Browser Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_BROWSER_APPLICATION[@]}"

