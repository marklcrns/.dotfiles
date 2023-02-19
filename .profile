# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash, if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
# umask 022

# ==================== PATH VARIABLES ==================== #

# Personal bin and its subdirectories
if [ -d "$HOME/bin" ]; then
	for d in $(find ${HOME}/bin -type d); do
		export PATH="$d":$PATH
	done
fi

# local bin dir
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin":$PATH
fi

# Personal scripts and its subdirectories
if [ -d "$HOME/scripts" ]; then
	# Excludes scripting-utils directory
	# Ref: https://stackoverflow.com/a/15736463/11850077
	for d in $(find "${HOME}/scripts" -type d -not -path "*.git*" -not -path "*scripting-utils*"); do
		export PATH="$d":$PATH
	done
fi

# Cargo bin
export PATH=$PATH:$HOME/.cargo/bin
# Haskel-platform cabal bin
export PATH=$PATH:$HOME/.cabal/bin
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$PATH:$HOME/.rvm/bin
# Emacs bin
export PATH=$PATH:$HOME/emacs.d/bin
# Global npm modules path
export PATH=$PATH:$HOME/.npm-global/bin

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

# Fix for Vimwiki perl error: https://stackoverflow.com/questions/2499794/how-to-fix-a-locale-setting-warning-from-perl
export LC_ALL=C

# ez-install
export EZ_INSTALL_HOME="${HOME}/.ez-install"

if [[ -e "/opt/gradle/latest" ]]; then
	export GRADLE_HOME=/opt/gradle/latest
	export PATH=${GRADLE_HOME}/bin:${PATH}
fi

# For WSL Configs ONLY
# Pulse audio fix resources:
#   Setting up pulseaudio in windows    - https://github.com/microsoft/WSL/issues/5816#issuecomment-682242686
#   Reinstall pulseaudio in wsl2 ubuntu - https://unix.stackexchange.com/a/465734
#   Setting proper host ip              - https://github.com/microsoft/WSL/issues/5816#issuecomment-760613983
#   Remove pulse configs                - https://github.com/microsoft/WSL/issues/5816#issuecomment-755409888
#   Editing /etc/pulse/default.pa       - https://github.com/microsoft/WSL/issues/5816#issuecomment-713702166
if grep -i "microsoft" /proc/version &>/dev/null; then
	# $PATHS
	export PATH=$PATH:"/mnt/c/Program Files/Mozilla Firefox/"
	export PATH=$PATH:"/mnt/c/Program Files (x86)/Google/Chrome/Application/"
	export PATH=$PATH:"/mnt/c/wsl/bin/"

	# Enable Vagrant access outisde of WSL.
	export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
	export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/vagrant"

	# Works with windows pulse server
	# HOST_IP=$(host `hostname` | grep 192. | tail -1 | awk '{ print $NF }' | tr -d '\r')
	# Faster than using hostname
	HOST_IP=$(ip route | awk '/^default/{print $3; exit}')

	# Workaround for WSL/WSL2 X Server not working
	if grep -q "WSL2" /proc/version &>/dev/null; then
		# WSL2
		export DISPLAY=$HOST_IP:0.0
		export PULSE_SERVER=tcp:$HOST_IP
	else
		#WSL1
		export DISPLAY="${DISPLAY:-localhost:0.0}"
		export PULSE_SERVER="${PULSE_SERVER:-tcp:127.0.0.1}"
	fi

	export NO_AT_BRIDGE=1
	export LIBGL_ALWAYS_INDIRECT=1

	# Export Windows username if in WSL
	# 2>/dev/null to suppress UNC paths are not supported error
	export WIN_USERNAME="$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)"
	export WIN_APPDATA="/mnt/c/Users/${WIN_USERNAME}/AppData/Roaming"
	export WIN_HOME="/mnt/c/Users/${WIN_USERNAME}"
fi

# Ref: https://unix.stackexchange.com/a/139787
# Ref: https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
if [[ -e "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]]; then
	export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
	export LESS=' -R '
	alias lessh='LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s" less -M '
fi

# ==================== CUSTOM GLOBAL VARIABLES ==================== #

export DOTFILESRC="${HOME}/.dotfilesrc"
export WIKI_HOME="${HOME}/Documents/my-wiki"

# ==================== SOURCING FILES ==================== #

# SOURCING FILES NEEDS TO GO IN BASHRC OR ZSHRC TO PREVENT SOME ISSUES

# ==================== MISC ==================== #

# Remove duplicates in $PATH
# Ref: https://unix.stackexchange.com/a/40973
if [ -n "$PATH" ]; then
	old_PATH=$PATH:
	PATH=
	while [ -n "$old_PATH" ]; do
		x=${old_PATH%%:*} # the first remaining entry
		case $PATH: in
		*:"$x":*) ;;        # already there
		*) PATH=$PATH:$x ;; # not there yet
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
	if type neofetch &>/dev/null; then
		neofetch
	elif type screenfetch &>/dev/null; then
		screenfetch
	fi
	if hash fortune &>/dev/null && hash lolcat &>/dev/null; then
		fortune | lolcat
	elif hash fortune &>/dev/null; then
		fortune
	fi
fi
