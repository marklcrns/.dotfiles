#!/bin/bash

if [[ "$(grep -i microsoft /proc/version)" ]]; then
  tmux source-file "set -g status-left '#[fg=colour235,bg=cyan,bold] #S #[fg=cyan,bg=colour238,nobold,nounderscore,noitalics]#[fg=cyan,bg=colour238] #W#{?window_zoomed_flag, ,} #[fg=colour238,bg=colour235,nobold,nounderscore,noitalics]#[fg=colour244,bg=colour235] #(cat /tmp/gtd-tmux) #[fg=colour244]'"
  tmux source-file "set -g status-right ' #{prefix_highlight} #[fg=colour244,bg=colour235] %H:%M  %m|%d %a #[fg=colour238,bg=colour235,nobold,nounderscore,noitalics]#[fg=cyan,bg=colour238] #(whoami) #[fg=cyan,bg=colour238,nobold,nounderscore,noitalics]#[fg=colour235,bg=cyan,bold] #H '"

