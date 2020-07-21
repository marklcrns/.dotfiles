# include .profile if it exists
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

