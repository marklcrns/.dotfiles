#!/bin/bash

APT_PACKAGES_VIRTUAL_MACHINE=(
  # VirtualBox
  "virtualbox"
  # VirtualBox dependencies
  "virtualbox-dkms"
  "linux-headers-generic"
  "linux-headers-$(uname -r)"
)

APT_PACKAGES_VIRTUAL_MACHINE_DOCKER=(
  "docker-ce;update"
  "docker-ce-cli"
  "containerd.io"
)

APT_PACKAGES_VIRTUAL_MACHINE_DOCKER_DEPENDENCIES=(
  "apt-transport-htt"
  "ca-certificates"
  "curl"
  "gnupg"
  "lsb-release"
)

echolog
echolog "${UL_NC}Installing Virtual Machine Packages${NC}"
echolog

# # Vagrant 2.2.9
# if wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb; then
#   sudo dpkg -i vagrant_2.2.9_x86_64.deb
#   sudo apt -f install
# fi

# Docker
if apt_bulk_install "${APT_PACKAGES_VIRTUAL_MACHINE_DOCKER_DEPENDENCIES[@]}"; then
  if curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt_bulk_install "${APT_PACKAGES_VIRTUAL_MACHINE_DOCKER[@]}"
  fi
fi

