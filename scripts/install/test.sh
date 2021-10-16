#!/bin/bash

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
DOTFILES_ROOT="$(realpath "${SCRIPTDIR}/../..")"
DOWNLOADS_DIR="${HOME}/Downloads"

############################################## EXTERNAL DEPENDENCIES SCRIPTS ###

# Ansi color code variables
if [[ -e "${SCRIPTDIR}/../colors" ]]; then
  source "${SCRIPTDIR}/../colors"
else
  echo "${SCRIPTPATH} WARNING: Failed to source '../colors' dependency"
  echo
fi
# Utility functions
if [[ -e "${SCRIPTDIR}/../utils" ]]; then
  source "${SCRIPTDIR}/../utils"
else
  echo "${SCRIPTPATH} ERROR: Failed to source '../utils' dependency"
  exit 1
fi
# Install utility functions
if [[ -e "${SCRIPTDIR}/install_utils.sh" ]]; then
  source "${SCRIPTDIR}/install_utils.sh"
else
  echo "${SCRIPTPATH} ERROR: Failed to source './install_utils.sh' dependency"
  exit 1
fi

##################################################### SCRIPT MAIN EXECUTIONS ###

# Confirmation
if [[ -z "${SKIP_CONFIRM}" ]]; then
  log "Do you wish to continue? (Y/y): \n" 1
  ${SCRIPTDIR}/../confirm "Do you wish to continue? (Y/y): "
  if [[ "${?}" -eq 1 ]]; then
    abort "${SCRIPTPATH}: Aborted."
  elif [[ "${?}" -eq 2 ]]; then
    error "${SCRIPTPATH}: Unsupported shell"
  fi
fi

DOWNLOADS_DIR="${HOME}/Downloads"
PACKAGES="${SCRIPTDIR}/packages"

[[ ! -d "${HOME}/Projects" ]] && mkdir -p "${HOME}/Projects"
[[ ! -d "${HOME}/Downloads" ]] && mkdir -p "${DOWNLOADS_DIR}"

cd ${DOWNLOADS_DIR}

successful_packages=""
failed_packages=""
skipped_packages=""

# Internet connection issue on apt update workaround for WSL2
if [[ "$(grep -i microsoft /proc/version)" ]]; then
  cat /etc/resolv.conf > ~/nameserver.txt
  echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
fi

# Apt update and upgrade
if ! (sudo apt update && sudo apt upgrade -y); then
  error "Apt update and upgrade failed" 1
fi

# restore nameserver
if [[ "$(grep -i microsoft /proc/version)" ]]; then
  cat ~/nameserver.txt | sudo tee /etc/resolv.conf
fi


# START TEST COMMANDS HERE

MISC_PACKAGES="${PACKAGES}/misc.sh"

if [[ -f "${MISC_PACKAGES}" ]]; then
  source "${MISC_PACKAGES}"
else
  error "${MISC_PACKAGES} not found"
fi

#################################################################### WRAP UP ###

total_count=0
successful_count=0
skipped_count=0
failed_count=0

echolog
echolog "${UL_NC}Successful Installations${NC}"
echolog
while IFS= read -r package; do
  if [[ -n ${package} ]]; then
    ok "${package}"
    total_count=$(expr ${total_count} + 1)
    successful_count=$(expr ${successful_count} + 1)
  fi
done < <(echo -e "${successful_packages}") # Process substitution for outside variables

echolog
echolog "${UL_NC}Skipped Installations${NC}"
echolog
while IFS= read -r package; do
  if [[ -n ${package} ]]; then
    warning "${package}"
    total_count=$(expr ${total_count} + 1)
    skipped_count=$(expr ${skipped_count} + 1)
  fi
done < <(echo -e "${skipped_packages}") # Process substitution for outside variables

echolog
echolog "${UL_NC}Failed Installations${NC}"
echolog
while IFS= read -r package; do
  if [[ -n ${package} ]]; then
    error "${package}"
    total_count=$(expr ${total_count} + 1)
    failed_count=$(expr ${failed_count} + 1)
  fi
done < <(echo -e "${failed_packages}") # Process substitution for outside variables

echolog
echolog "Successful installations:\t${successful_count}"
echolog "Skipped installations:\t\t${skipped_count}"
echolog "failed installations:\t\t${failed_count}"
echolog "${BO_NC}Total installations:\t\t${total_count}"

finish 'TEST INSTALLATION COMPLETE!'
