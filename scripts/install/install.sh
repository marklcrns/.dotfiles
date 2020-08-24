#!/bin/bash

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})

# Ubuntu distributions
if lsb_release -i | grep "Ubuntu" &> /dev/null; then
  # 20.04 Focal Fossa
  if lsb_release -c | grep "focal" &> /dev/null; then
    echo "Installing packages for Ubuntu 20.04 Focal Fossa"
    ${SCRIPTDIR}/ubuntu_20.04.sh
  fi
fi
