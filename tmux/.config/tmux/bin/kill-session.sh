#!/bin/sh
# Kill the current tmux session, but first switch the client to another session
# so we never detach the user (which on SSH would drop them back to the login
# shell or close the window). If this is the only session, refuse.

count=$(tmux list-sessions 2>/dev/null | wc -l | tr -d ' ')
current=$(tmux display-message -p '#S')

if [ "$count" -le 1 ]; then
    tmux display-message "can't kill '$current' — it's the only session (D to detach, or exit the shell)"
    exit 0
fi

tmux switch-client -n
tmux kill-session -t "$current"
tmux display-message "killed session: $current"
