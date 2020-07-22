# Ref:
# https://superuser.com/a/187673
# TODO: add_to_path from .profile produces `bad substitution`
#
# # Workaround to only run when not in WSL
# if [[ ! "$(grep -i microsoft /proc/version)" ]]; then
#   emulate sh
#   source ~/.profile
#   emulate zsh
# fi

# TODO: Fix issue with tmuxinator not running apps with these on

# # ==================== PATH VARIABLES ==================== #
# 
# # Utility function to add path into $PATH
# # Ref: https://unix.stackexchange.com/q/334382
# function add_to_path() {
#   for p in ${(s.:.)2}; do
#     if [[ ! "${(P)1}" =~ "${p%/}" ]]; then
#       new_path="$p:${(P)1#:}"
#       export "$1"="${new_path%:}"
#     fi
#   done
# }
# 
# # Personal bin and its subdirectories
# if [ -d "$HOME/bin" ] ; then
#   # Excludes plugins directory in ~/bin
#   for d in $(find ${HOME}/bin \( -type d -name "plugins" -prune \) -o -type d); do
#     add_to_path 'PATH' "$d"
#   done
# fi
# 
# # Personal local bin dir
# if [ -d "$HOME/.local/bin" ] ; then
#   add_to_path 'PATH' "$HOME/.local/bin"
# fi
# 
# # Cargo bin
# add_to_path 'PATH' "$HOME/.cargo/bin"
# # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# add_to_path 'PATH' "$HOME/.rvm/bin"
# # Rclonesync-V2 PATH
# add_to_path 'PATH' "$HOME/bin/plugins/rclonesync-V2"
# # Emacs bin
# add_to_path 'PATH' "$HOME/emacs.d/bin"
# 
# # WSL profile
# if [[ "$(grep -i microsoft /proc/version)" ]]; then
#   # $PATHS
#   add_to_path 'PATH' "/mnt/c/Program Files/Mozilla Firefox/"
#   add_to_path 'PATH' "/mnt/c/Program Files (x86)/Google/Chrome/Application"
#   # NetBeans
#   add_to_path 'PATH' "/opt/netbeans/bin/"
#   # VirtualBox Windows path
#   add_to_path 'PATH' "/mnt/c/Program Files/Oracle/VirtualBox"
# fi
# 
# # ==================== OTHER GLOBAL VARIABLES ==================== #
# 
# # Ripgrep global flags
# export RIPGREP_CONFIG_PATH=~/.ripgreprc
# 
# # Default editor
# export VISUAL="nvim"
# export EDITOR=$VISUAL
# 
# # Tldr Config
# # Repo: https://github.com/raylee/tldr
# export TLDR_HEADER='magenta bold underline'
# export TLDR_QUOTE='italic'
# export TLDR_DESCRIPTION='green'
# export TLDR_CODE='red'
# export TLDR_PARAM='blue'
# 
# export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_251
# export JRE_HOME=/usr/lib/jvm/jdk1.8.0_251/jre
# 
# # For WSL Configs ONLY
# if [[ "$(grep -i microsoft /proc/version)" ]]; then
#   export BROWSER="/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
# 
#   # Enable Vagrant access outisde of WSL.
#   export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
#   export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/vagrant"
# 
#   # Workaround for WSL 2 X Server not working
#   # export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
#   export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
#   export LIBGL_ALWAYS_INDIRECT=1
# 
#   # Export Windows username if in WSL
#   # 2>/dev/null to suppress UNC paths are not supported error
#   export WIN_USERNAME=$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)
# fi

