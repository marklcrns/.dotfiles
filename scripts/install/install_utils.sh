#!/bin/bash

# Prevent from being executed directly in the terminal
if [ ${0##*/} == ${BASH_SOURCE[0]##*/} ]; then
  echo "WARNING:"
  echo "$(realpath -s $0) is not meant to be executed directly!"
  echo "Use this script only by sourcing it."
  echo
  exit 1
fi

# Exclude 'ppa:' from repo argument if is_ppa
# e.g. for 'sudo add-apt-repository ppa:bashtop-monitor/bashtop', only pass in
# 'bashtop-monitor/bashtop'
apt_add_repo() {
  repo=$1
  is_ppa=$2

  if find /etc/apt/ -name "*.list" | xargs cat | grep -h "^[[:space:]]*deb.*${repo}" &> /dev/null; then
    ok "Apt repository '${repo}' already added in '/etc/apt/'"
    skipped_packages="${skipped_packages}\nApt ${repo} ADDED SKIPPED"
    return 0
  fi

  # if WSL, nameserver to 8.8.8.8 before updating
  if [[ "$(grep -i microsoft /proc/version)" ]]; then
    cat /etc/resolv.conf > ~/nameserver.txt
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf &> /dev/null
    # Add ppa if is_ppa
    if [[ ${is_ppa} -eq 1 ]];then
      warning "Adding ppa:${repo}..."
      if sudo add-apt-repository "ppa:${repo}" -y &> /dev/null; then
        ok "Apt ppa '${repo}' added"
        successful_packages="${successful_packages}\nApt ${repo} ADDED"
        return 0
      else
        error "Apt ppa '${repo}' failed to be added ... Removing"
        sudo add-apt-repository -r "ppa:${repo}"
        failed_packages="${failed_packages}\nApt ${repo} NOT ADDED"
        return 1
      fi
    else
      warning "Adding ${repo}..."
      if sudo add-apt-repository "${repo}" -y &> /dev/null; then
        ok "Apt '${repo}' repository added" -y
        successful_packages="${successful_packages}\nApt ${repo} ADDED"
        return 0
      else
        error "Apt '${repo}' repository failed to be added ... Removing"
        sudo add-apt-repository -r "${repo}" -y
        failed_packages="${failed_packages}\nApt ${repo} NOT ADDED"
        return 1
      fi
    fi
    # restore nameserver after adding apt
    cat ~/nameserver.txt | sudo tee /etc/resolv.conf &> /dev/null
  else
    # Add ppa if is_ppa
    if [[ ${is_ppa} -eq 1 ]];then
      warning "Adding ppa:${repo}..."
      if sudo add-apt-repository "ppa:${repo}" -y &> /dev/null; then
        ok "Apt ppa '${repo}' added"
        successful_packages="${successful_packages}\nApt ${repo} ADDED"
        return 0
      else
        error "Apt ppa '${repo}' failed to be added ... Removing"
        sudo add-apt-repository -r "ppa:${repo}"
        failed_packages="${failed_packages}\nApt ${repo} NOT ADDED"
        return 1
      fi
    else
      warning "Adding ${repo}..."
      if sudo add-apt-repository "${repo}" -y &> /dev/null; then
        ok "Apt '${repo}' repository added" -y
        successful_packages="${successful_packages}\nApt ${repo} ADDED"
        return 0
      else
        error "Apt '${repo}' repository failed to be added ... Removing"
        sudo add-apt-repository -r "${repo}" -y
        failed_packages="${failed_packages}\nApt ${repo} NOT ADDED"
        return 1
      fi
    fi
  fi
}

# Will `apt update` first before installation if $2 -eq 1
apt_install() {
  package=$1
  is_update=$2

  # Check if package exists in apt repository
  if ! apt-cache search --names-only "${package}" | grep -F "${package}"; then
    error "${package} package not found in apt repository"
    failed_packages="${failed_packages}\nApt ${package} FAILED. Package not found"
    return 1
  fi
  # Check if already installed
  if dpkg -s "${package}" &> /dev/null; then
    ok "Apt ${package} package already installed"
    skipped_packages="${skipped_packages}\nApt ${package} SKIPPED"
    return 0
  fi
  # sudo apt update if is_update
  if [[ ${is_update} -eq 1 ]]; then
    # if WSL, nameserver to 8.8.8.8 before updating
    if [[ "$(grep -i microsoft /proc/version)" ]]; then
      cat /etc/resolv.conf > ~/nameserver.txt
      echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf &> /dev/null
      if sudo apt update -y; then
        ok "Apt update successful!"
      else
        error "Apt update failed"
      fi
      # restore nameserver after apt update
      cat ~/nameserver.txt | sudo tee /etc/resolv.conf &> /dev/null
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
    successful_packages="${successful_packages}\nApt ${package} SUCCESSFUL"
    return 0
  else
    error "Apt ${package} package installation failed"
    failed_packages="${failed_packages}\nApt ${package} FAILED"
    return 1
  fi
}

# if apt package is appended with ';update', will `apt update` first before
# installation
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
      failed_packages="${failed_packages}\nCurl '${from}' -> '${to}' FAILED. Invalid destination path"
      return 1
    fi
    # Execute installation
    if eval "curl -sS ${from} -o ${to}"; then
      ok "Curl '${from}' -> '${to}' successful!"
      successful_packages="${successful_packages}\nCurl '${from}' -> '${to}' SUCCESSFUL"
      return 0
    else
      error "Curl '${from}' -> '${to}' FAILED"
      failed_packages="${failed_packages}\nCurl '${from}' -> '${to}' FAILED"
      return 1
    fi
  else
    # Execute installation
    if eval "curl -sS ${from}"; then
      ok "Curl '${from}' successful!"
      successful_packages="${successful_packages}\nCurl '${from}' SUCCESSFUL"
      return 0
    else
      error "Curl '${from}' -> '${to}' FAILED"
      failed_packages="${failed_packages}\nCurl '${from}' FAILED"
      return 1
    fi
  fi
}

# Specify destination directory
wget_install() {
  from=$1
  to=$2

  # If has destination directory use -P flag, else use regular wget
  if [[ -n "${to}" ]]; then
    # Check destination directory validity
    if [[ ! -d "${to}" ]]; then
      error "Invalid wget destination path '${to}'"
      failed_packages="${failed_packages}\nWget '${from}' -> '${to}' FAILED. Invalid destination path"
      return 1
    fi
    # Execute installation
    if eval "wget ${from} –P ${to}"; then
      ok "Wget '${from}' -> '${to}' successful!"
      successful_packages="${successful_packages}\nWget '${from}' -> '${to}' SUCCESSFUL"
      return 0
    else
      error "Wget '${from}' -> '${to}' FAILED"
      failed_packages="${failed_packages}\nWget '${from}' -> '${to}' FAILED"
      return 1
    fi
  else
    # Execute installation
    if eval "wget ${from}"; then
      ok "Wget '${from}' successful!"
      successful_packages="${successful_packages}\nWget'${from}' -> '${to}' SUCCESSFUL"
      return 0
    else
      error "Wget '${from}' -> '${to}' FAILED"
      failed_packages="${failed_packages}\nWget '${from}' -> '${to}' FAILED"
      return 1
    fi
  fi
}

git_clone() {
  from=$1
  to=$2

  # Validate git repo link
  if [[ -n "${from}" ]]; then
    # Extract git repo link
    link="$(echo ${from} | sed -E "s,.*((https|git)(:\/\/|@)github.com(\/|:).*\/[^ ]+).*,\1,")"

    if ! git ls-remote ${link} &> /dev/null; then
      error "Invalid git repo link '${link}'"
      failed_packages="${failed_packages}\nGit clone '${link}' FAILED. Invalid git repo link"
      return 1
    fi
  else
    error "Missing git repo link"
    return 1
  fi
  # If output/destination file is given, else use regular curl
  if [[ -n "${to}" ]]; then
    # Check destination directory validity
    if [[ ! -d "$(dirname "${to}")" ]]; then
      error "Invalid git clone destination directory path '${to}'"
      echolog "$(dirname ${to})"
      failed_packages="${failed_packages}\nGit clone '${from}' -> '${to}' FAILED. Invalid directory path"
      return 1
    fi
    # Remove old repository if existing
    if [[ -d "${to}/.git" ]]; then
      warning "Removing old ${to} repository"
      rm -rf "${to}"
    fi
    # Execute installation
    if eval "git clone ${from} ${to}"; then
      ok "Git clone '${from}' -> '${to}' successful!"
      successful_packages="${successful_packages}\nGit clone '${from}' -> '${to}' SUCCESSFUL"
      return 0
    else
      # Catch error if authentication failed and try again up to 5 tries
      for i in {1..5}; do
        if [[ ${?} -eq 128 ]]; then
          warning "Git authentication failed. Try again ($i/5)"
          if eval "git clone ${from} ${to}"; then
            wait
            ok "Git clone '${from}' -> '${to}' successful!"
            successful_packages="${successful_packages}\nGit clone '${from}' -> '${to}' SUCCESSFUL"
            return 0
          fi
        fi
      done
      if [[ $? -ne 0 ]]; then
        error "Cloning ${from} failed"
        failed_packages="${failed_packages}\nGit clone '${from}' -> '${to}' FAILED"
        return 1
      fi
    fi
  else
    # Execute installation
    if eval "git clone ${from}"; then
      ok "Git clone '${from}' successful!"
      successful_packages="${successful_packages}\nGit clone '${from}' -> '${to}' SUCCESSFUL"
      return 0
    else
      # Catch error if authentication failed and try again up to 5 tries
      for i in {1..5}; do
        if [[ ${?} -eq 128 ]]; then
          warning "Git authentication failed. Try again ($i/5)"
          if eval "git clone ${from}"; then
            wait
            ok "Git clone '${from}' -> '${to}' successful!"
            successful_packages="${successful_packages}\nGit clone '${from}' -> '${to}' SUCCESSFUL"
            return 0
          fi
        fi
      done
      if [[ $? -ne 0 ]]; then
        error "Cloning ${from} failed"
        failed_packages="${failed_packages}\nGit clone '${from}' -> '${to}' FAILED"
        return 1
      fi
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
      failed_packages="${failed_packages}\nPip${pip_version} ${package} FAILED. Invalid pip version"
      return 1
    fi
  fi
  # Check if pip is installed
  if ! command -v pip${pip_version} &> /dev/null; then
    error "Pip${pip_version} not installed"
    failed_packages="${failed_packages}\nPip${pip_version} ${package} FAILED. pip${pip_version} not installed"
    return 1
  else
    which_pip="$(which "pip${pip_version}")"
  fi
  # Check if package exists in pip repository
  if ! eval "pip${pip_version} search ${package} &> /dev/null"; then
    error "${package} package not found in pip repository"
    failed_packages="${failed_packages}\nPip${pip_version} ${package} for '${which_pip}' FAILED. Package not found"
    return 1
  fi
  # Check if already installed
  if eval "pip${pip_version} list | grep -F ${package} &> /dev/null"; then
    ok "Pip${pip_version} ${package} already installed"
    skipped_packages="${skipped_packages}\nPip${pip_version} ${package} for '${which_pip}' SKIPPED"
    return 0
  fi
  # Execute installation
  if eval "pip${pip_version} install ${package}"; then
    ok "Pip${pip_version} ${package} package installation successful!"
    successful_packages="${successful_packages}\nPip${pip_version} ${package} for '${which_pip}' SUCCESSFUL"
    return 0
  else
    error "Pip${pip_version} ${package} package installation failed"
    failed_packages="${failed_packages}\nPip${pip_version} ${package} for '${which_pip}' FAILED"
    return 1
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
  is_global=$1
  package=$2

  # Check if package exists in npm repository
  if npm search ${package} | grep -q "^No matches found"; then
    error "${package} package not found in npm repository"
    failed_packages="${failed_packages}\nNpm ${package} FAILED. Package not found"
    return 1
  fi
  # Check if package already installed
  if [[ ${is_global} -eq 1 ]]; then
    if eval "npm list -g | grep -F ${package}" &> /dev/null; then
      ok "Npm ${package} global package already installed"
      successful_packages="${successful_packages}\nNpm ${package} SUCCESSFUL"
      return 0
    fi
  else
    if eval "npm list | grep -F ${package}" &> /dev/null; then
      ok "Npm ${package} local package already installed"
      skipped_packages="${skipped_packages}\nNpm ${package} SKIPPED"
      return 0
    fi
  fi
  # Execute installation
  if [[ ${is_global} -eq 1 ]]; then
    if eval "npm -g install ${package}"; then
      ok "Npm ${package} global package installation successful!"
      successful_packages="${successful_packages}\nNpm ${package} SUCCESSFUL"
      return 0
    else
      error "Npm ${package} global package installation failed"
      failed_packages="${failed_packages}\nNpm ${package} FAILED"
      return 1
    fi
  else
    if eval "npm install ${package}"; then
      ok "Npm ${package} local package installation successful!"
      successful_packages="${successful_packages}\nNpm ${package} SUCCESSFUL"
      return 0
    else
      error "Npm ${package} local package installation failed"
      failed_packages="${failed_packages}\nNpm ${package} FAILED"
      return 1
    fi
  fi
}

npm_bulk_install() {
  is_global=$1

  if [[ ${is_global} -eq 1 ]]; then
    shift
  fi

  packages=("$@")

  # Loop over packages array and npm_install
  if [[ -n "${packages}" ]]; then
    for package in ${packages[@]}; do
      warning "Installing npm ${package} package..."
      npm_install ${is_global} "${package}"
    done
  else
    error "${FUNCNAME[0]}: Array not found" 1
  fi
}

pkg_install() {
  package=$1
  is_update=$2

  # Check if already installed
  if pkg search "${package}" | grep "installed" &> /dev/null; then
    ok "Pkg ${package} package already installed"
    skipped_packages="${skipped_packages}\nApt ${package} SKIPPED"
    return 0
  fi
  # pkg upgrade if is_update
  if [[ ${is_update} -eq 1 ]]; then
      if pkg upgrade -y; then
        ok "Pkg upgrade successful!"
      else
        error "Pkg upgrade failed"
      fi
    fi
  fi
  # Execute installation
  if eval "pkg install ${package} -y"; then
    ok "Pkg ${package} package installation successful!"
    successful_packages="${successful_packages}\nApt ${package} SUCCESSFUL"
    return 0
  else
    error "Pkg ${package} package installation failed"
    failed_packages="${failed_packages}\nPkg ${package} FAILED"
    return 1
  fi
}

# if apt package is appended with ';update', will `apt update` first before
# installation
pkg_bulk_install() {
  packages=("$@")

  # Loop over packages array and apt_install
  if [[ -n "${packages}" ]]; then
    for package in ${packages[@]}; do
      if echo "${package}" | grep -q ";update"; then
        package="$(echo ${package} | sed "s,;update,,")"
        warning "Installing pkg ${package} package..."
        pkg_install "${package}" 1
      else
        warning "Installing pkg ${package} package..."
        pkg_install "${package}"
      fi
    done
  else
    error "${FUNCNAME[0]}: Array not found" 1
  fi
}
