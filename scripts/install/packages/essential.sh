#!/bin/bash

# Essential packages

APT_PACKAGES_ESSENTIAL=(
  "build-essential"
  "libssl-dev"
  "libffi-dev"
  "cmake"
  "curl"
  "wget"
  "zip"
  "unzip"
  "unar"
  "git"
  "gnupg2"
  "net-tools"
)

echolog
echolog "${UL_NC}Installing Essential Packages${NC}"
echolog

apt_bulk_install "${APT_PACKAGES_ESSENTIAL[@]}"

# Git-lfs
if curl_install "https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash"; then
  apt_install "git-lfs"
  git lfs install
fi

