#!/bin/bash

# Prevent from being executed directly in the terminal
if [ ${0##*/} == ${BASH_SOURCE[0]##*/} ]; then
  echo "WARNING:"
  echo "$(realpath -s $0) is not meant to be executed directly!"
  echo "Use this script only by sourcing it."
  echo
  exit 1
fi


APT_PACKAGES_ESSENTIAL=(
  "build-essential"
  "libssl-dev"
  "libffi-dev"
  "curl"
  "wget"
  "zip"
  "unzip"
  "git"
  "vim"
  "gnupg2"
  "net-tools"
)

APT_PACKAGES_LANGUAGE=(
  # Python
  "python-dev" # Deprecated
  "python3-dev"
  "python3-pip"
  "python3-venv"
  # Java
  "openjdk-8-jdk"
  "openjdk-8-jre"
  "openjdk-11-jdk"
  "openjdk-11-jre"
  "openjdk-13-jdk"
  "openjdk-13-jre"
  "default-jre"
  "default-jdk"
  "oracle-java11-installer-local"
  "oracle-java11-set-default-local"
)

PIP3_PACKAGES_LANGUAGES=(
  "notebook"
  "Send2Trash"
  "pipenv"
)

APT_PACKAGES_PACKAGE_MANAGER=(
  "npm"
  "yarn;update"
)

NPM_PACKAGES_PACKAGE_MANAGER=(
  "npm@latest"
  # Extras
  "browser-sync"
  "gulp-cli"
)

APT_PACKAGES_SHELL=(
  "zsh"
)

APT_PACKAGES_SESSION_MANAGER=(
  "tmux"
  "tmuxinator"
  "gawk"
  "urlview"
)

PIP3_PACKAGES_SESSION_MANAGER=(
  "spotify-cli-linux"
)

APT_PACKAGES_FILE_EXPLORER=(
  "ranger"
  "caca-utils"
  "highlight"
  "atool"
  "w3m"
  "w3m-img"
  "zathura"
  "xdotool"
  "poppler-utils"
  "mediainfo"
  "mupdf"
  "mupdf-tools"
)

APT_PACKAGES_TEXT_EDITOR=(
  "neovim"
  "python-neovim" # Deprecated, not found
  "python3-neovim"
  # Dependencies
  "yad"
  "zenity"
)

NPM_PACKAGES_TEXT_EDITOR=(
  "neovim"
  "eslint"
  "stylelint"
  "prettier"
)

PIP3_PACKAGES_TEXT_EDITOR_NEOVIM=(
  "neovim"
  "tasklib"
  "send2trash"
  "vim-vint"
  "flake8"
  "pylint"
  "autopep8"
)

APT_PACKAGES_UTILITY=(
  "tree"
  "xclip"
  "xdg-utils"
  "fd-find"
  "mlocate"
  "autojump"
  "k-y"
  "synaptic"
  "rclone-browser"
  "ripgrep"
  "pandoc-data"
  "pandoc"
  "texlive"
  "r-base"
  "inotify-tools"
)

APT_PACKAGES_UTILITY_CTAGS_DEPENDENCIES=(
  "gcc"
  "make"
  "pkg-config"
  "autoconf"
  "automake"
  "python3-docutils"
  "libseccomp-dev"
  "libjansson-dev"
  "libyaml-dev"
  "libxml2-dev"
)

APT_PACKAGES_UTILITY_PANDOC_DEPENCENCIES=(
  "pandoc-data"
  "pandoc"
  "texlive"


)

APT_PACKAGES_WEB_SERVER=(
  "apache2"
  "apache2-utils"
  "sqlite3"
  "libsqlite3-dev"
  "sqlitebrowser"
)

APT_PACKAGES_WEB_SERVER_PHP_DEPENDENCIES=(
  "php"
  "libapache2-mod-php"
  "php-cli"
  "php-fpm"
  "php-json"
  "php-pdo"
  "php-mysql"
  "php-zip"
  "php-gd"
  "php-mbstring"
  "php-curl"
  "php-xml"
  "php-pear"
  "php-bcmath"
)

APT_PACKAGES_VIRTUAL_MACHINE=(
  # VirtualBox
  "virtualbox"
  # VirtualBox dependencies
  "virtualbox-dkms"
  "linux-headers-generic"
  "linux-headers-$(uname -r)"
  # Docker
  "docker.io"
)

APT_PACKAGES_DESKTOP_WINDOW_MANAGER=(
  "dwm"
  "suckless-tools"
  "xdm"
  "dmenu"
  "xorg"
)

APT_PACKAGES_MISC=(
  "screenfetch"
  "neofetch"
  "htop"
  "colordiff"
  "cmatrix"
  "cowsay"
  "xcowsay"
  "figlet"
  "lolcat"
  "fortune"
  "sl"
  "taskwarrior"
  "timewarrior"
)

APT_PACKAGES_DESKTOP_APPLICATION=(
  "libreoffice"
  "flameshot"
  "gimp"
)

