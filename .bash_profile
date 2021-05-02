# source ~/.profile
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

# source ~/.bashrc
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.bashrc"
fi

. "$HOME/.cargo/env"
