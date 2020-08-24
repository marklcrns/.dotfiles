#!/bin/bash

# Installer script for Linux and WSL 2 Ubuntu 20.04 Focal Fossa
#
# Store .dotfiles repo in ~/Projects/.dotfiles
#
# For Java Oracle JDK 11, Download Java SE that matches default-jdk installation
# if the one provided in the install directory is not matched:
# https://www.oracle.com/java/technologies/javase-jdk11-downloads.html
# for previous versions:
# https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html





################################################## CONSTANT GLOBAL VARIABLES ###

LOG_FILE_DIR="${HOME}/log"
LOG_FILE="$(date +"%Y-%m-%dT%H:%M:%S")_$(basename -- $0).log"

SCRIPTPATH="$(realpath -s $0)"
SCRIPTDIR=$(dirname ${SCRIPTPATH})
DOTFILES_ROOT="$(realpath "${SCRIPTDIR}/../..")"

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

############################################################### FLAG OPTIONS ###

# Display help
usage() {
  cat << EOF
USAGE:

Command description.

  command [ -DsvVy ]

OPTIONS:

  -D  debug mode (redirect output in log file)
  -s  silent output
  -v  verbose output
  -V  very verbose output
  -y  skip confirmation
  -h  help

EOF
}

# Set flag options
while getopts "DsvVyh" opt; do
  case "$opt" in
    D) [[ -n "$DEBUG"           ]] && unset DEBUG                      || DEBUG=true;;
    s) [[ -n "$IS_SILENT"       ]] && unset IS_SILENT                  || IS_SILENT=true;;
    v) [[ -n "$IS_VERBOSE"      ]] && unset IS_VERBOSE                 || IS_VERBOSE=true;;
    V) [[ -n "$IS_VERY_VERBOSE" ]] && unset IS_VERBOSE IS_VERY_VERBOSE || IS_VERBOSE=true; IS_VERY_VERBOSE=true;;
    y) [[ -n "$SKIP_CONFIRM"    ]] && unset SKIP_CONFIRM               || SKIP_CONFIRM=true;;
    h) usage && exit 0;;
    *) usage && echo -e "${SCRIPTPATH}:\n${RED}ERROR: Invalid flag.${NC}"
      exit 1
  esac
done 2>/dev/null
shift "$((OPTIND-1))"

####################################################### PRE-EXECUTION SET UP ###

# Strip trailing '/' in DIR path variables
LOG_FILE_DIR=$(echo ${LOG_FILE_DIR} | sed 's,/*$,,')

# Log stdout and stderr to $LOG_FILE in $LOG_FILE_DIR
if [[ -n "${DEBUG}" ]]; then
  # Append LOG_FILE
  LOG_FILE_PATH="${LOG_FILE_DIR}/${LOG_FILE}"
  # Create log directory if not existing
  if [[ ! -d "${LOG_FILE_DIR}" ]]; then
    mkdir -p "${LOG_FILE_DIR}"
  fi
  # Initialize log file
  echo -e "${SCRIPTPATH} log outputs\n" > ${LOG_FILE_PATH}
fi

################################################## SCRIPT ARGUMENTS HANDLING ###

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
TRASH_DIR="${HOME}/.Trash"
PACKAGES="${SCRIPTDIR}/packages"

[[ ! -d "${HOME}/Projects" ]] && mkdir -p "${HOME}/Projects"
[[ ! -d "${HOME}/Downloads" ]] && mkdir -p "${DOWNLOADS_DIR}"
[[ ! -d "${HOME}/.Trash" ]] && mkdir -p "${TRASH_DIR}"

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
if ! sudo apt update && sudo apt upgrade -y; then
  error "Apt update and upgrade failed" 1
fi

# restore nameserver
if [[ "$(grep -i microsoft /proc/version)" ]]; then
  cat ~/nameserver.txt | sudo tee /etc/resolv.conf
fi

#################### Essentials ####################

ESSENTIAL_PACKAGES="${PACKAGES}/essential.sh"

if [[ -f "${ESSENTIAL_PACKAGES}" ]]; then
  source "${ESSENTIAL_PACKAGES}"
else
  error "${ESSENTIAL_PACKAGES} not found"
fi

#################### Languages ####################

LANGUAGE_PACKAGES="${PACKAGES}/language.sh"

if [[ -f "${LANGUAGE_PACKAGES}" ]]; then
  source "${LANGUAGE_PACKAGES}"
else
  error "${LANGUAGE_PACKAGES} not found"
fi

#################### Package Managers ####################

PACKAGE_MANAGER_PACKAGES="${PACKAGES}/package_manager.sh"

if [[ -f "${PACKAGE_MANAGER_PACKAGES}" ]]; then
  source "${PACKAGE_MANAGER_PACKAGES}"
else
  error "${PACKAGE_MANAGER_PACKAGES} not found"
fi

############### Shell ################

SHELL_PACKAGES="${PACKAGES}/shell.sh"

if [[ -f "${SHELL_PACKAGES}" ]]; then
  source "${SHELL_PACKAGES}"
else
  error "${SHELL_PACKAGES} not found"
fi

#################### Session Manager ####################

SESSION_MANAGER_PACKAGES="${PACKAGES}/session_manager.sh"

if [[ -f "${SESSION_MANAGER_PACKAGES}" ]]; then
  source "${SESSION_MANAGER_PACKAGES}"
else
  error "${SESSION_MANAGER_PACKAGES} not found"
fi

#################### File Manager ####################

FILE_MANAGER_PACKAGES="${PACKAGES}/file_manager.sh"

if [[ -f "${FILE_MANAGER_PACKAGES}" ]]; then
  source "${FILE_MANAGER_PACKAGES}"
else
  error "${FILE_MANAGER_PACKAGES} not found"
fi

############### Text Editors ##################

TEXT_EDITOR_PACKAGES="${PACKAGES}/text_editor.sh"

if [[ -f "${TEXT_EDITOR_PACKAGES}" ]]; then
  source "${TEXT_EDITOR_PACKAGES}"
else
  error "${TEXT_EDITOR_PACKAGES} not found"
fi

#################### Fonts ####################

FONT_PACKAGES="${PACKAGES}/font.sh"

if [[ -f "${FONT_PACKAGES}" ]]; then
  source "${FONT_PACKAGES}"
else
  error "${FONT_PACKAGES} not found"
fi

#################### Tools ####################

TOOLS_PACKAGES="${PACKAGES}/tools.sh"

if [[ -f "${TOOLS_PACKAGES}" ]]; then
  source "${TOOLS_PACKAGES}"
else
  error "${TOOLS_PACKAGES} not found"
fi

#################### Browser ####################

BROWSER_PACKAGES="${PACKAGES}/browser.sh"

if [[ -f "${BROWSER_PACKAGES}" ]]; then
  source "${BROWSER_PACKAGES}"
else
  error "${BROWSER_PACKAGES} not found"
fi

#################### Server ####################

SERVER_PACKAGES="${PACKAGES}/server.sh"

if [[ -f "${SERVER_PACKAGES}" ]]; then
  source "${SERVER_PACKAGES}"
else
  error "${SERVER_PACKAGES} not found"
fi

#################### Virtual Machine/Containers ####################

VIRTUAL_MACHINE_PACKAGES="${PACKAGES}/virtual_machine.sh"

if [[ -f "${VIRTUAL_MACHINE_PACKAGES}" ]]; then
  source "${VIRTUAL_MACHINE_PACKAGES}"
else
  error "${VIRTUAL_MACHINE_PACKAGES} not found"
fi

#################### Misc ####################

MISC_PACKAGES="${PACKAGES}/misc.sh"

if [[ -f "${MISC_PACKAGES}" ]]; then
  source "${MISC_PACKAGES}"
else
  error "${MISC_PACKAGES} not found"
fi

#################### Desktop Apps ####################

DESKTOP_APPS_PACKAGES="${PACKAGES}/desktop_apps.sh"

if [[ -f "${DESKTOP_APPS_PACKAGES}" ]]; then
  source "${DESKTOP_APPS_PACKAGES}"
else
  error "${DESKTOP_APPS_PACKAGES} not found"
fi

#################### Dotfiles ####################

# Distribute dotfiles into $HOME
source ${DOTFILES_ROOT}/.dotfilesrc
${DOTFILES_ROOT}/bin/tools/dotfiles/dotdist -v "${DOTFILES_ROOT}" "${HOME}"


#################################################################### WRAP UP ###


total_count=0
successful_count=0
skipped_count=0
failed_count=0

echolog
echolog "${UL_NC}Successful Package Installations${NC}"
echolog
while IFS= read -r package; do
  ok "${package}"
  total_count=$(expr ${total_count} + 1)
  successful_count=$(expr ${successful_count} + 1)
done < <(echo -e "${successful_packages}") # Process substitution for outside variables

echolog
echolog "${UL_NC}Skipped Package Installations${NC}"
echolog
while IFS= read -r package; do
  warning "${package}"
  total_count=$(expr ${total_count} + 1)
  skipped_count=$(expr ${skipped_count} + 1)
done < <(echo -e "${skipped_packages}") # Process substitution for outside variables

echolog
echolog "${UL_NC}Failed Package Installations${NC}"
echolog
while IFS= read -r package; do
  error "${package}"
  total_count=$(expr ${total_count} + 1)
  failed_count=$(expr ${failed_count} + 1)
done < <(echo -e "${failed_packages}") # Process substitution for outside variables

echolog
echolog "Successful packages:\t${successful_count}"
echolog "Skipped packages:\t${skipped_count}"
echolog "failed packages:\t${failed_count}"
echolog "${BO_NC}Total packages:\t\t${total_count}"

finish 'INSTALLATION COMPLETE!'

