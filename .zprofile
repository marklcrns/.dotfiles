# Ref:
# https://superuser.com/a/187673

# Workaround to only run when not in WSL because of tmuxinator issue
# not running commands when sourcing files
if [[ ! "$(grep -i microsoft /proc/version)" ]]; then
  emulate sh
  source ${HOME}/.profile
  emulate zsh
fi

