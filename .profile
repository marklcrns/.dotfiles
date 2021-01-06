# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# ==================== PATH VARIABLES ==================== #

# Personal bin and its subdirectories
if [ -d "$HOME/bin" ] ; then
  for d in $(find ${HOME}/bin -type d); do
    export PATH="$d":$PATH
  done
fi

# local bin dir
if [ -d "$HOME/.local/bin" ] ; then
  export PATH="$HOME/.local/bin":$PATH
fi

# Personal scripts and its subdirectories
if [ -d "$HOME/scripts" ] ; then
  # Excludes scripting-utils directory
  # Ref: https://stackoverflow.com/a/15736463/11850077
  for d in $(find "${HOME}/scripts" -type d -not -path "*.git*" -not -path "*scripting-utils*"); do
    export PATH="$d":$PATH
  done
fi

# Cargo bin
export PATH=$PATH:$HOME/.cargo/bin
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$PATH:$HOME/.rvm/bin
# Emacs bin
export PATH=$PATH:$HOME/emacs.d/bin
# Global npm modules path
export PATH=$PATH:$HOME/.npm-global/bin

# WSL profile
if grep -i "microsoft" /proc/version &> /dev/null; then
  # $PATHS
  export PATH=$PATH:"/mnt/c/Program Files/Mozilla Firefox/"
  export PATH=$PATH:"/mnt/c/Program Files (x86)/Google/Chrome/Application"
fi

# ==================== RC FILES GLOBAL VARIABLES ==================== #

export DOTFILESRC="${HOME}/.dotfilesrc"

# ==================== OTHER GLOBAL VARIABLES ==================== #

# Ripgrep global flags
export RIPGREP_CONFIG_PATH=~/.ripgreprc

# Default editor
export VISUAL="nvim"
export EDITOR=$VISUAL

# Tldr Config
# Repo: https://github.com/raylee/tldr
export TLDR_HEADER='magenta bold underline'
export TLDR_QUOTE='italic'
export TLDR_DESCRIPTION='green'
export TLDR_CODE='red'
export TLDR_PARAM='blue'

if [[ -e "/opt/gradle/latest" ]]; then
  export GRADLE_HOME=/opt/gradle/latest
  export PATH=${GRADLE_HOME}/bin:${PATH}
fi

# For WSL Configs ONLY
if grep -i "microsoft" /proc/version &> /dev/null; then
  export BROWSER="/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"

  # Enable Vagrant access outisde of WSL.
  export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
  export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/vagrant"

  # Workaround for WSL 2 X Server not working
  # export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
  export LIBGL_ALWAYS_INDIRECT=1

  # Export Windows username if in WSL
  # 2>/dev/null to suppress UNC paths are not supported error
  export WIN_USERNAME=$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)
fi

# ==================== SOURCING FILES ==================== #

# SOURCING FILES NEEDS TO GO IN BASHRC OR ZSHRC TO PREVENT SOME ISSUES

# ==================== MISC ==================== #

# Remove duplicates in $PATH
# Ref: https://unix.stackexchange.com/a/40973
if [ -n "$PATH" ]; then
  old_PATH=$PATH:; PATH=
  while [ -n "$old_PATH" ]; do
    x=${old_PATH%%:*}       # the first remaining entry
    case $PATH: in
      *:"$x":*) ;;          # already there
      *) PATH=$PATH:$x;;    # not there yet
    esac
    old_PATH=${old_PATH#*:}
  done
  PATH=${PATH#:}
  unset old_PATH x
fi

# If running bash, display custom graphics
# Requires neofetch or screenfetch, figlet and/or lolcat
# Ref: https://stackoverflow.com/a/677212
if [[ -n "$BASH_VERSION" ]]; then
  if type neofetch >/dev/null; then
    neofetch
  elif type screenfetch >/dev/null; then
    screenfetch
  fi
  if hash fortune 2>/dev/null && hash lolcat &>/dev/null; then
    fortune | lolcat
  elif hash fortune 2>/dev/null; then
    fortune
  fi
fi

