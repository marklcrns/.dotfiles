# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PATH="$HOME/.cargo/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Export Windows username if in WSL
if [[ "$(grep -i microsoft /proc/version)" ]]; then
  # 2>/dev/null to suppress UNC paths are not supported error
  export WIN_USERNAME=$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)
fi

# Ref: https://stackoverflow.com/a/677212
type neofetch >/dev/null && neofetch
hash fortune 2>/dev/null 2>&1 && \
  hash figlet 2>/dev/null 2>&1 && \
  hash lolcat 2>/dev/null 2>&1 && \
  fortune | figlet | lolcat

