#!/bin/bash

# Prevent from being executed directly in the terminal
if [ ${0##*/} == ${BASH_SOURCE[0]##*/} ]; then
  echo "WARNING:"
  echo "$(realpath -s $0) is not meant to be executed directly!"
  echo "Use this script only by sourcing it."
  echo
  exit 1
fi

apt_install() {
  package=$1
  is_update=$2

  # Check if package exists in apt repository
  if [[ -z "$(apt-cache search --names-only ${package})" ]]; then
    error "${package} package not found in apt repository"
    return 1
  fi
  # Check if already installed
  if dpkg -s "${package}" &> /dev/null; then
    ok "Apt ${package} package already installed"
    return 0
  fi
  # sudo apt update if is_update
  if [[ ${is_update} -eq 1 ]]; then
    # if WSL nameserver to 8.8.8.8 before updating
    if [[ "$(grep -i microsoft /proc/version)" ]]; then
      cat /etc/resolv.conf > ~/nameserver.txt
      echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
      if sudo apt update -y; then
        ok "Apt update successful!"
      else
        error "Apt update failed"
      fi
      # restore nameserver after apt update
      cat ~/nameserver.txt | sudo tee /etc/resolv.conf
    else
      if sudo apt update -y; then
        ok "Apt update successful!"
      else
        error "Apt update failed"
      fi
    fi
  fi
  # Execute installation
  if eval "sudo apt install ${package} -y"; then
    ok "Apt ${package} package installation successful!"
    if [[ -n ${successful_packages} ]]; then
      successful_packages="${successful_packages}\nApt ${package}"
    else
      successful_packages="Apt ${package}"
    fi
  else
    error "Apt ${package} package installation failed"
    if [[ -n ${failed_packages} ]]; then
      failed_packages="${failed_packages}\nApt ${package}"
    else
      failed_packages="Apt ${package}"
    fi
  fi
}

apt_bulk_install() {
  packages=("$@")

  # Loop over packages array and apt_install
  if [[ -n "${packages}" ]]; then
    for package in ${packages[@]}; do
      if echo "${package}" | grep -q ";update"; then
        package="$(echo ${package} | sed "s,;update,,")"
        warning "Installing apt ${package} package..."
        apt_install "${package}" 1
      else
        warning "Installing apt ${package} package..."
        apt_install "${package}"
      fi
    done
  else
    error "${FUNCNAME[0]}: Array not found" 1
  fi
}

curl_install() {
  from=$1
  to=$2

  # If output/destination file is given, else use regular curl
  if [[ -n "${to}" ]]; then
    # Check destination directory validity
    if [[ ! -d "$(dirname ${to})" ]]; then
      error "Invalid curl destination path '${to}'"
      return 1
    fi
    # Execute installation
    if eval "curl -fLsS ${from} -o ${to}"; then
      ok "Curl '${from}' -> '${to}' successful!"
    fi
  else
    # Execute installation
    if eval "curl -fLsSO ${from}"; then
      ok "Curl '${from}' successful!"
    fi
  fi
}

git_clone() {
  from=$1
  to=$2

  # If output/destination file is given, else use regular curl
  if [[ -n "${to}" ]]; then

    # Check destination directory validity
    if [[ ! -d "$(dirname "${to}")" ]]; then
      error "Invalid git clone destination directory path '${to}'"
      return 1
    fi

    if [[ -d "${to}/.git" ]]; then
      warning "Removing old ${to} repository"
      rm -rf "${to}"
    fi

    # Execute installation
    if git clone "${from}" "${to}"; then
      ok "Git clone '${from}' -> '${to}' successful!"
    else
      # Catch error if authentication failed and try again
      while [[ ${?} -eq 128 ]]; do
        git clone "${from}" "${to}" && ok "Git clone '${from}' -> '${to}' successful!"
      done
    fi
  else
    # Execute installation
    if git clone "${from}"; then
      ok "Git clone '${from}' successful!"
    else
      # Catch error if authentication failed and try again
      while [[ ${?} -eq 128 ]]; do
        git clone "${from}" && ok "Git clone '${from}' successful!"
      done
    fi
  fi
}

pip_install() {
  pip_version=$1
  package=$2

  # Check pip version if not 2 or 3
  if [[ -n ${pip_version} ]]; then
    if [[ ${pip_version} -gt 3 || ${pip_version} -lt 2 ]]; then
      error "Invalid pip version"
      return 1
    fi
  fi

  # Check if package exists in pip repository
  if ! eval "pip${pip_version} search ${package} &> /dev/null"; then
    error "${package} package not found in pip repository"
    return 1
  fi

  # Check if already installed
  if eval "pip${pip_version} list | grep -F ${package} &> /dev/null"; then
    ok "Pip${pip_version} ${package} already installed"
    return 0
  fi

  # Execute installation
  if eval "pip${pip_version} install ${package}"; then
    ok "Pip${pip_version} ${package} package installation successful!"
  else
    error "Pip${pip_version} ${package} package installation failed"
  fi
}

pip_bulk_install() {
  pip_version=$1

  if [[ -n ${pip_version} ]]; then
    shift
  fi

  packages=("$@")

  if [[ -n "${packages}" ]]; then
    for package in ${packages[@]}; do
      warning "Installing pip${pip_version} ${package} package..."
      pip_install ${pip_version} "${package}"
    done
  else
    error "${FUNCNAME[0]}: Array not found" 1
  fi

}

npm_install() {
  package=$1
  is_global=$2

  # Check if package exists in npm repository
  if npm search ${package} | grep -q "^No matches found"; then
    error "${package} package not found in npm repository"
  fi

  # Check if package already installed
  if [[ ${is_global} -eq 1 ]]; then
    if eval "npm list -g | grep -F ${package}" &> /dev/null; then
      ok "Npm ${package} global package already installed"
      return 0
    fi
  else
    if eval "npm list | grep -F ${package}" &> /dev/null; then
      ok "Npm ${package} local package already installed"
      return 0
    fi
  fi

  # Execute installation
  if [[ ${is_global} -eq 1 ]]; then
    if eval "npm -g install ${package}"; then
      ok "Npm ${package} global package installation successful!"
    else
      error "Npm ${package} global package installation failed"
    fi
  else
    if eval "npm install ${package}"; then
      ok "Npm ${package} local package installation successful!"
    else
      error "Npm ${package} local package installation failed"
    fi
  fi
}

npm_bulk_install() {
  is_global=$1

  if [[ -n ${is_global} ]]; then
    shift
  fi

  packages=("$@")

  # Loop over packages array and npm_install
  if [[ -n "${packages}" ]]; then
    for package in ${packages[@]}; do
      warning "Installing npm ${package} package..."
      npm_install "${package}" ${is_global}
    done
  else
    error "${FUNCNAME[0]}: Array not found" 1
  fi
}
