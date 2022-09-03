# Workaround to only run when not in WSL because of tmuxinator issue
# not running commands when sourcing files
# Ref: https://superuser.com/a/187673
if ! grep -i "microsoft" /proc/version &> /dev/null; then
  [[ -e ~/.profile ]] && emulate sh -c "source ${HOME}/.profile"
fi

# Mimic Bash `fg N` command replaces Zsh `fg %N`.
# Ref: https://stackoverflow.com/a/32614814
fg() {
  if [[ $# -eq 1 && $1 = - ]]; then
    builtin fg %-
  else
    builtin fg %"$@"
  fi
}
