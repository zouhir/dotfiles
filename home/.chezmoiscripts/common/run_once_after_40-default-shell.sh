#!/bin/bash
set -euo pipefail

[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
fish_path="$(command -v fish)"
grep -qx "$fish_path" /etc/shells || echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
current="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || true)"
[ -n "$current" ] || current="$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')"
[ "$current" = "$fish_path" ] || sudo chsh -s "$fish_path" "$USER"
