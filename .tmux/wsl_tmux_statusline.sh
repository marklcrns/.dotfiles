#!/bin/bash

if [[ "$(grep -i microsoft /proc/version)" ]]; then
  tmux source-file ~/.tmux/wsl_statusline.conf
fi
