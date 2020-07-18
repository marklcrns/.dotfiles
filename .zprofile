# Utility function to add path into $PATH
# Ref: https://unix.stackexchange.com/q/334382
function add_to_path() {
  for p in ${(s.:.)2}; do
    if [[ ! "${(P)1}" =~ "${p%/}" ]]; then
      new_path="$p:${(P)1#:}"
      export "$1"="${new_path%:}"
    fi
  done
}

# Ref:
# https://superuser.com/a/187673
emulate sh
. ~/.profile
emulate zsh

