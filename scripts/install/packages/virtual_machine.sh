#!/bin/bash

APT_PACKAGES_VIRTUAL_MACHINE=(
  # VirtualBox
  "virtualbox"
  # VirtualBox dependencies
  "virtualbox-dkms"
  "linux-headers-generic"
  "linux-headers-$(uname -r)"
  # Docker
  "docker.io"
)

echolog
echolog "${UL_NC}Installing Virtual Machine Packages${NC}"
echolog

# # Vagrant 2.2.9
# if wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb; then
#   sudo dpkg -i vagrant_2.2.9_x86_64.deb
#   sudo apt -f install
# fi

