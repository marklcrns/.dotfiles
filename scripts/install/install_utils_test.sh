#!/bin/bash

source ../colors
source ../utils
source ./install_utils.sh

apt_add_repo "bashtop-monitor/bashtop" 1
apt_add_repo "universe"

