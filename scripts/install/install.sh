#!/bin/bash

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})

# Ubuntu distributions
if lsb_release -i | grep "Ubuntu"; then

  # 20.04 Focal Fossa
  if lsb_release -c | grep "focal"; then
    ${SCRIPTDIR}/ubuntu_20.04.sh
  fi

fi
