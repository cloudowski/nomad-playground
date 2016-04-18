#!/bin/bash

cat << EOF > /root/.tmux.conf
set-option -g prefix C-a
unbind-key C-b
bind-key C-a send-prefix
set -g history-limit 10000
set -g default-terminal "screen-256color" 
set -g utf8
set-window-option -g utf8 on
set-window-option -g xterm-keys on

EOF

cat /root/.tmux.conf >> /etc/tmux.conf
