# Utility function to add a path into $PATH
# Ref: https://unix.stackexchange.com/q/334382
function add_to_path() {
  for path in ${2//:/ }; do
    if ! [[ "${!1}" =~ "${path%/}" ]]; then # ignore last /
      new_path="$path:${!1#:}"
      export "$1"="${new_path%:}" # remove trailing :
    fi
  done
}

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

# include .profile if it exists
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

