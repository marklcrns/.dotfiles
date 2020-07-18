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
  # Excludes plugins directory in ~/bin
  for d in $(find ${HOME}/bin \( -type d -name "plugins" -prune \) -o -type d); do
    add_to_path 'PATH' "$d"
  done
fi

# Personal local bin dir
if [ -d "$HOME/.local/bin" ] ; then
  add_to_path 'PATH' "$HOME/.local/bin"
fi

# Cargo bin
add_to_path 'PATH' "$HOME/.cargo/bin"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
add_to_path 'PATH' "$HOME/.rvm/bin"
# Rclonesync-V2 PATH
add_to_path 'PATH' "$HOME/bin/plugins/rclonesync-V2"
# Emacs bin
add_to_path 'PATH' "$HOME/emacs.d/bin"

# WSL profile
if [[ "$(grep -i microsoft /proc/version)" ]]; then
  # $PATHS
  add_to_path 'PATH' "/mnt/c/Program Files/Mozilla Firefox/"
  add_to_path 'PATH' "/mnt/c/Program Files (x86)/Google/Chrome/Application"
  # NetBeans
  add_to_path 'PATH' "/opt/netbeans/bin/"
  # VirtualBox Windows path
  add_to_path 'PATH' "/mnt/c/Program Files/Oracle/VirtualBox"
fi

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

export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_251
export JRE_HOME=/usr/lib/jvm/jdk1.8.0_251/jre

# For WSL Configs ONLY
if [[ "$(grep -i microsoft /proc/version)" ]]; then
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

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# ==================== MISC ==================== #

# if running bash, display custom graphics
if [[ -n "$BASH_VERSION" ]]; then
  # Ref: https://stackoverflow.com/a/677212
  type neofetch >/dev/null && neofetch
  hash fortune 2>/dev/null 2>&1 && \
    hash figlet 2>/dev/null 2>&1 && \
    hash lolcat 2>/dev/null 2>&1 && \
    fortune | figlet | lolcat
fi

