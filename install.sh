#!/bin/bash
set -eo pipefail

echo "Setting up dotfiles..."

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ============================================================================
# macOS — install CLI tools WITHOUT Homebrew.
#
# Everything lands in ~/.local/bin (single-binary tools), ~/.local/go and
# ~/.local/nvim-* (toolchains that need their runtime tree), or /usr/local/bin
# (fish, via its signed .pkg). No package manager required.
#
# GUI apps are NOT installed here — see the "Applications" section in README.md.
# ============================================================================

# Resolve the first release asset URL matching a regex. Always exits 0; prints
# nothing on miss so callers can test for an empty string. Honours $GITHUB_TOKEN
# to dodge the 60-req/hr unauthenticated API limit.
gh_asset() {
    local repo="$1" re="$2" hdr=()
    [ -n "${GITHUB_TOKEN:-}" ] && hdr=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
    {
        curl -fsSL "${hdr[@]+"${hdr[@]}"}" \
            "https://api.github.com/repos/${repo}/releases/latest" 2>/dev/null \
            | grep -oE '"browser_download_url": *"[^"]+"' \
            | cut -d'"' -f4 \
            | grep -E "$re" \
            | head -n1
    } || true
}

# Place a single binary in ~/.local/bin. Handles .tar.gz/.tar.xz, .zip, or a raw
# binary download; finds the file named like the tool inside any archive.
install_binary() {
    local name="$1" url="$2" tmp
    tmp="$(mktemp -d)"
    case "$url" in
        *.tar.gz|*.tgz|*.tar.xz)
            curl -fsSL "$url" -o "$tmp/a"
            tar -xf "$tmp/a" -C "$tmp"
            install -m 0755 "$(find "$tmp" -type f -name "$name" | head -n1)" \
                "$HOME/.local/bin/$name"
            ;;
        *.zip)
            curl -fsSL "$url" -o "$tmp/a.zip"
            unzip -q "$tmp/a.zip" -d "$tmp"
            install -m 0755 "$(find "$tmp" -type f -name "$name" | head -n1)" \
                "$HOME/.local/bin/$name"
            ;;
        *)
            curl -fsSL "$url" -o "$HOME/.local/bin/$name"
            chmod 0755 "$HOME/.local/bin/$name"
            ;;
    esac
    rm -rf "$tmp"
}

# Convenience wrapper: skip if already on PATH, else resolve + install.
fetch_gh() {
    local name="$1" repo="$2" re="$3"
    if command -v "$name" &>/dev/null; then
        echo "  • $name (already installed)"
        return 0
    fi
    local url
    url="$(gh_asset "$repo" "$re")"
    if [ -z "$url" ]; then
        echo "  ✗ $name — no release asset matched /$re/ (skipping)"
        return 0
    fi
    install_binary "$name" "$url"
    echo "  ✓ $name"
}

install_macos_tools() {
    mkdir -p "$HOME/.local/bin"

    local arch rust_arch go_arch dl_arch
    arch="$(uname -m)"
    case "$arch" in
        arm64|aarch64) rust_arch="aarch64-apple-darwin"; go_arch="arm64";  dl_arch="arm64"  ;;
        x86_64)        rust_arch="x86_64-apple-darwin";  go_arch="amd64";  dl_arch="x86_64" ;;
        *) echo "Unsupported architecture: $arch"; exit 1 ;;
    esac

    echo "Installing single-binary CLI tools into ~/.local/bin..."
    # Rust tools — *-apple-darwin tarballs, binary named after the tool.
    fetch_gh rg      BurntSushi/ripgrep   "ripgrep-.*${rust_arch}\.tar\.gz$"
    fetch_gh fd      sharkdp/fd           "fd-.*${rust_arch}\.tar\.gz$"
    fetch_gh bat     sharkdp/bat          "bat-.*${rust_arch}\.tar\.gz$"
    fetch_gh delta   dandavison/delta     "delta-.*${rust_arch}\.tar\.gz$"
    fetch_gh zoxide  ajeetdsouza/zoxide   "zoxide-.*${rust_arch}\.tar\.gz$"
    # Go tools — vendor-specific naming.
    fetch_gh fzf      junegunn/fzf        "fzf-.*darwin_${go_arch}\.tar\.gz$"
    fetch_gh lazygit  jesseduffield/lazygit "lazygit_.*darwin_${dl_arch}\.tar\.gz$"
    fetch_gh gh       cli/cli             "gh_.*macOS_${go_arch}\.zip$"
    fetch_gh direnv   direnv/direnv       "direnv\.darwin-${go_arch}$"
    fetch_gh jq       jqlang/jq           "jq-macos-${go_arch}$"
    fetch_gh tmux     tmux/tmux-builds    "tmux-.*macos-${dl_arch}\.tar\.gz$"

    # Neovim — ships its runtime tree; extract whole, symlink the binary.
    if ! command -v nvim &>/dev/null; then
        echo "Installing neovim..."
        local nvurl
        nvurl="$(gh_asset neovim/neovim "nvim-macos-${dl_arch}\.tar\.gz$")"
        if [ -n "$nvurl" ]; then
            local tmp; tmp="$(mktemp -d)"
            curl -fsSL "$nvurl" -o "$tmp/nvim.tar.gz"
            rm -rf "$HOME/.local/nvim-macos-${dl_arch}"
            tar -xf "$tmp/nvim.tar.gz" -C "$HOME/.local"
            ln -sf "$HOME/.local/nvim-macos-${dl_arch}/bin/nvim" "$HOME/.local/bin/nvim"
            rm -rf "$tmp"
            echo "  ✓ nvim"
        fi
    else
        echo "  • nvim (already installed)"
    fi

    # Go — extract toolchain to ~/.local/go (PATH wired in config.fish).
    if ! command -v go &>/dev/null; then
        echo "Installing go..."
        local gover
        gover="$(curl -fsSL 'https://go.dev/dl/?mode=json' \
            | grep -oE '"version": *"go[0-9.]+"' | head -n1 | cut -d'"' -f4)"
        if [ -n "$gover" ]; then
            local tmp; tmp="$(mktemp -d)"
            curl -fsSL "https://go.dev/dl/${gover}.darwin-${go_arch}.tar.gz" -o "$tmp/go.tar.gz"
            rm -rf "$HOME/.local/go"
            tar -xf "$tmp/go.tar.gz" -C "$HOME/.local"
            rm -rf "$tmp"
            echo "  ✓ go ($gover)"
        fi
    else
        echo "  • go (already installed)"
    fi

    # fnm — official installer, pinned to ~/.local/bin.
    if ! command -v fnm &>/dev/null; then
        echo "Installing fnm..."
        curl -fsSL https://fnm.vercel.app/install \
            | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell
    else
        echo "  • fnm (already installed)"
    fi

    # starship — official installer, pinned to ~/.local/bin.
    if ! command -v starship &>/dev/null; then
        echo "Installing starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
    else
        echo "  • starship (already installed)"
    fi

    # GNU Stow — Perl program (Perl ships with macOS); build from source.
    if ! command -v stow &>/dev/null; then
        echo "Installing stow (from source)..."
        local tmp; tmp="$(mktemp -d)"
        if curl -fsSL https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz -o "$tmp/stow.tar.gz"; then
            tar -xf "$tmp/stow.tar.gz" -C "$tmp"
            ( cd "$tmp"/stow-* && ./configure --prefix="$HOME/.local" >/dev/null && make install >/dev/null )
            echo "  ✓ stow"
        else
            echo "  ✗ stow — download failed"
        fi
        rm -rf "$tmp"
    else
        echo "  • stow (already installed)"
    fi

    # fish — signed .pkg installs to /usr/local/bin (needs sudo).
    if ! command -v fish &>/dev/null; then
        echo "Installing fish (.pkg, requires sudo)..."
        local fishurl
        fishurl="$(gh_asset fish-shell/fish-shell '\.pkg$')"
        if [ -n "$fishurl" ]; then
            local tmp; tmp="$(mktemp -d)"
            curl -fsSL "$fishurl" -o "$tmp/fish.pkg"
            sudo installer -pkg "$tmp/fish.pkg" -target /
            rm -rf "$tmp"
            echo "  ✓ fish"
        fi
    else
        echo "  • fish (already installed)"
    fi
}

# Detect OS and install packages
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS"

    install_macos_tools

    # Apply macOS defaults
    echo "Applying macOS defaults..."
    bash "$DOTFILES_DIR/macos-defaults.sh"

else
    echo "Detected Linux"

    # Install packages via native package manager
    if command -v apt &> /dev/null; then
        echo "Installing packages via apt..."
        sudo apt update
        sudo apt install -y fish stow zoxide direnv neovim tmux fzf fd-find ripgrep bat gh
        # fd and bat have different binary names on Debian/Ubuntu
        mkdir -p "$HOME/.local/bin"
        [ -x "$(command -v fdfind)" ] && ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
        [ -x "$(command -v batcat)" ] && ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
    elif command -v dnf &> /dev/null; then
        echo "Installing packages via dnf..."
        sudo dnf install -y fish stow zoxide direnv neovim tmux fzf fd-find ripgrep bat starship gh
    elif command -v pacman &> /dev/null; then
        echo "Installing packages via pacman..."
        sudo pacman -S --noconfirm fish stow zoxide direnv neovim tmux fzf fd ripgrep bat starship github-cli
    else
        echo "Unknown package manager. Please install: fish stow zoxide direnv neovim fzf fd ripgrep bat"
        exit 1
    fi

    # Starship: not in default apt repos, use official installer as fallback
    if ! command -v starship &> /dev/null; then
        echo "Installing starship..."
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
    chsh -s "$FISH_PATH" || true
fi

# Symlink dotfiles
echo "Linking dotfiles..."
cd "$DOTFILES_DIR"

# Backup existing files that would conflict
# This handles both root-level files like .gitconfig and .config/ subdirectories
CONFIG_TARGETS=("fish" "ghostty" "lazygit" "nvim" "tmux" )
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
chmod 600 "$HOME/Projects/dotfiles/ssh/.ssh/config.local" 2>/dev/null || true

# Create local functions dir for per-machine prompt overrides
mkdir -p "$HOME/.config/fish/functions/local"

stow -v -t "$HOME" fish
stow -v -t "$HOME" git
stow -v -t "$HOME" ssh
stow -v -t "$HOME" ghostty
stow -v -t "$HOME" lazygit
stow -v -t "$HOME" tmux
stow -v -t "$HOME" nvim
stow -v -t "$HOME" starship

# Install Node.js via fnm
if command -v fnm &> /dev/null; then
    echo "Installing Node.js LTS via fnm..."
    fnm install --lts
fi

echo "Done! Restart your terminal or run: exec fish"
