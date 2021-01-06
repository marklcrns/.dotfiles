#!/bin/bash

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})

# Ubuntu distributions
if lsb_release -i | grep "Ubuntu" &> /dev/null; then
  # 20.04 Focal Fossa
  if lsb_release -c | grep "focal" &> /dev/null; then
    echo "Installing packages for Ubuntu 20.04 Focal Fossa"
    if [[ -f "${SCRIPTDIR}/ubuntu_20.04.sh" ]]; then
      ${SCRIPTDIR}/ubuntu_20.04.sh
    else
      error "${SCRIPTDIR}/ubuntu_20.04.sh not found"
    fi
  fi
# Raspberry Pi Raspbian distributions
elif lsb_release -i | grep "Raspbian" &> /dev/null; then
  # Raspbian buster
  if lsb_release -c | grep "buster" &> /dev/null; then
    echo "Installing packages for Raspbian buster"
    if [[ -f "${SCRIPTDIR}/raspbian_buster.sh" ]]; then
      ${SCRIPTDIR}/raspbian_buster.sh
    else
      error "${SCRIPTDIR}/raspbian_buster.sh not found"
    fi
  fi
elif uname -o | grep "Android" &> /dev/null; then
  echo "Installing packages for Android"
  ${SCRIPTDIR}/android.sh
fi
