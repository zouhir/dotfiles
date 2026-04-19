#!/usr/bin/env bash
# Minimal installer for the work dotfiles repo.
# Assumes the public dotfiles at ~/Projects/dotfiles have already been stowed —
# this repo layers drop-in files on top of that baseline.
set -euo pipefail

cd "$(dirname "$0")"

command -v stow >/dev/null || { echo "GNU stow not installed — run public dotfiles install.sh first" >&2; exit 1; }

for pkg in fish ssh git; do
    [ -d "$pkg" ] && stow -v -t "$HOME" "$pkg"
done

echo "work dotfiles stowed. Reload your shell and run: ssh -G corp-bastion | head"
