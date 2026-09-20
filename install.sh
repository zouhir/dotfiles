#!/bin/bash
set -eo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib.sh
source "$DOTFILES_DIR/lib.sh"

echo "Setting up dotfiles..."

# ============================================================================
# Packages
#
# macOS installs everything WITHOUT Homebrew: prebuilt upstream release
# binaries, official install scripts, and signed .pkg files. Linux uses the
# native package manager. See lib.sh for the mechanics.
# ============================================================================

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS"

    install_macos_tools

    echo "Installing GUI bits..."
    install_nerd_font
    install_iterm2_app

    echo "Applying macOS defaults..."
    bash "$DOTFILES_DIR/macos-defaults.sh"
else
    echo "Detected Linux"
    install_linux_tools
fi

# Set fish as default shell
FISH_PATH="$(command -v fish || true)"
if [ -n "$FISH_PATH" ]; then
    if ! grep -q "^$FISH_PATH\$" /etc/shells; then
        echo "Adding fish to /etc/shells..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi
    if [ "$SHELL" != "$FISH_PATH" ]; then
        echo "Setting fish as default shell..."
        # Non-fatal: LDAP / Cloudtop accounts often cannot chsh.
        chsh -s "$FISH_PATH" || true
    fi
fi

# ============================================================================
# Symlinks
# ============================================================================

echo "Linking dotfiles..."
cd "$DOTFILES_DIR"

prune_dropped_links

# Back up anything real that would collide with a symlink.
# Note "iterm2/prefs", not "iterm2": iTerm2 owns ~/.config/iterm2 itself
# (live socket, app-support symlinks) and must not be moved aside.
CONFIG_TARGETS=("fish" "iterm2/prefs" "lazygit" "nvim" "tmux")
HOME_TARGETS=(".gitconfig" ".gitignore_global" ".ssh/config" ".ssh/config.local" ".config/starship.toml")

for target in "${CONFIG_TARGETS[@]}"; do
    if [ -e "$HOME/.config/$target" ] && [ ! -L "$HOME/.config/$target" ]; then
        echo "Backing up ~/.config/$target to ~/.config/${target}.bak"
        mv "$HOME/.config/$target" "$HOME/.config/${target}.bak"
    fi
done

for target in "${HOME_TARGETS[@]}"; do
    if [ -e "$HOME/$target" ] && [ ! -L "$HOME/$target" ]; then
        # Ensure parent directory exists for files like .ssh/config
        mkdir -p "$(dirname "$HOME/$target")"
        echo "Backing up ~/$target to ~/$target.bak"
        mv "$HOME/$target" "$HOME/$target.bak"
    fi
done

# Ensure SSH environment is ready
mkdir -p "$HOME/.ssh/sockets"
chmod 700 "$HOME/.ssh"
chmod 600 "$DOTFILES_DIR/ssh/.ssh/config.local" 2>/dev/null || true

# Create local functions dir and conf.d for per-machine overrides and overlays
mkdir -p "$HOME/.config/fish/conf.d" "$HOME/.config/fish/functions/local"

for pkg in "${STOW_PACKAGES[@]}"; do
    stow -v -t "$HOME" "$pkg"
done

# ============================================================================
# Post-link setup
# ============================================================================

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Wiring up iTerm2..."
    use_iterm2_prefs
fi

seed_codex_config

# Install Node.js via fnm
if command -v fnm &> /dev/null; then
    echo "Installing Node.js LTS via fnm..."
    fnm install --lts
fi

echo
echo "Done! Restart your terminal or run: exec fish"
echo "Keep everything current later with: dotup   (or bash $DOTFILES_DIR/update.sh)"
