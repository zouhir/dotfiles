#!/bin/bash
set -e

echo "Setting up dotfiles..."

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect OS and install packages
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS"

    # Install Homebrew if not present
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "Installing packages via Homebrew..."
    brew install fish stow git-delta zoxide direnv starship fnm go neovim zellij fzf fd ripgrep bat
    brew install --cask font-jetbrains-mono-nerd-font

else
    echo "Detected Linux"

    # Install packages via native package manager
    if command -v apt &> /dev/null; then
        echo "Installing packages via apt..."
        sudo apt update
        sudo apt install -y fish stow zoxide direnv neovim fzf fd-find ripgrep bat
        # fd and bat have different binary names on Debian/Ubuntu
        mkdir -p "$HOME/.local/bin"
        [ -x "$(command -v fdfind)" ] && ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
        [ -x "$(command -v batcat)" ] && ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
    elif command -v dnf &> /dev/null; then
        echo "Installing packages via dnf..."
        sudo dnf install -y fish stow zoxide direnv neovim fzf fd-find ripgrep bat
    elif command -v pacman &> /dev/null; then
        echo "Installing packages via pacman..."
        sudo pacman -S --noconfirm fish stow zoxide direnv neovim fzf fd ripgrep bat
    else
        echo "Unknown package manager. Please install: fish stow zoxide direnv neovim fzf fd ripgrep bat"
        exit 1
    fi

    # Zellij
    if ! command -v zellij &> /dev/null; then
        echo "Installing Zellij..."
        bash <(curl -L https://zellij.dev/launch)
    fi

    # Starship (cross-platform installer)
    if ! command -v starship &> /dev/null; then
        echo "Installing Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    # fnm (cross-platform installer)
    if ! command -v fnm &> /dev/null; then
        echo "Installing fnm..."
        curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
    fi
fi

# Set fish as default shell
FISH_PATH=$(which fish)
if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "Adding fish to /etc/shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

if [ "$SHELL" != "$FISH_PATH" ]; then
    echo "Setting fish as default shell..."
    chsh -s "$FISH_PATH"
fi

# Symlink dotfiles
echo "Linking dotfiles..."
cd "$DOTFILES_DIR"

# Backup existing files that would conflict
for file in .gitconfig .gitignore_global; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        echo "Backing up ~/$file to ~/$file.bak"
        mv "$HOME/$file" "$HOME/$file.bak"
    fi
done

stow -v -t "$HOME" fish
stow -v -t "$HOME" git
stow -v -t "$HOME" ghostty
stow -v -t "$HOME" lazygit
stow -v -t "$HOME" starship
stow -v -t "$HOME" zellij
stow -v -t "$HOME" nvim

# Install Node.js via fnm
if command -v fnm &> /dev/null; then
    echo "Installing Node.js LTS via fnm..."
    fnm install --lts
fi

echo "Done! Restart your terminal or run: exec fish"
