# Workaround to only run when not in WSL because of tmuxinator issue
# not running commands when sourcing files
# Ref: https://superuser.com/a/187673
if [[ ! "$(grep -i microsoft /proc/version)" ]]; then
  emulate sh
  source ${HOME}/.profile
  emulate zsh
fi

