#!/bin/sh
# Resolve a smart tmux session name for the given path (default: $PWD).
# Rule: if inside a git repo, use the repo's toplevel basename; else use the
# basename of the path. Dots become dashes (tmux dislikes dots in names).

path="${1:-$PWD}"
cd "$path" 2>/dev/null || cd "$HOME" || exit 1

if top=$(git rev-parse --show-toplevel 2>/dev/null); then
    name=$(basename "$top")
else
    name=$(basename "$(pwd)")
fi

printf '%s\n' "$name" | tr '.' '-'
