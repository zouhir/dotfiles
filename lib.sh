#!/bin/bash
# Shared install/upgrade helpers, sourced by install.sh and update.sh.
#
# Every CLI tool this repo manages lands in ~/.local/bin (single binaries),
# ~/.local/go and ~/.local/nvim-* (toolchains that need their runtime tree), or
# /usr/local/bin (fish, via its signed .pkg). No package manager required.
#
# Set UPGRADE=1 before calling the installers to re-resolve each tool against
# its latest upstream release instead of skipping whatever is already present.

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

# These scripts run under bash, which has not sourced config.fish, so make sure
# the directories we install into are searched first. Without this, command -v
# would miss our own copies and report tools as "managed outside this repo".
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$HOME/.local/go/bin:$PATH" ;;
esac
export PATH

# Stow packages, in link order. Add new tools here.
STOW_PACKAGES=(fish git ssh iterm2 lazygit tmux nvim starship)

# Which upstream release each managed binary came from, so update.sh can tell
# "already latest" apart from "needs re-downloading".
DOTFILES_STATE="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles"
VERSIONS_FILE="$DOTFILES_STATE/versions"

recorded_version() {
    [ -f "$VERSIONS_FILE" ] || return 0
    grep -E "^$1 " "$VERSIONS_FILE" 2>/dev/null | tail -n1 | cut -d' ' -f2- || true
}

record_version() {
    mkdir -p "$DOTFILES_STATE"
    : > "$VERSIONS_FILE.tmp"
    if [ -f "$VERSIONS_FILE" ]; then
        grep -vE "^$1 " "$VERSIONS_FILE" >> "$VERSIONS_FILE.tmp" 2>/dev/null || true
    fi
    printf '%s %s\n' "$1" "$2" >> "$VERSIONS_FILE.tmp"
    mv "$VERSIONS_FILE.tmp" "$VERSIONS_FILE"
}

# True when $1 is absent, or lives somewhere this repo owns — ~/.local/bin plus
# any extra prefixes passed as $2.. . Keeps update.sh from shadowing a tool that
# a system package manager (or a leftover Homebrew) is responsible for.
dotfiles_owns() {
    local name="$1" p pre
    shift
    p="$(command -v "$name" 2>/dev/null || true)"
    [ -z "$p" ] && return 0
    for pre in "$HOME/.local/bin" "$@"; do
        case "$p" in "$pre"/*) return 0 ;; esac
    done
    return 1
}

# Set RUST_TRIPLE / GO_ARCH / DL_ARCH for the current OS and CPU.
detect_arch() {
    local m os
    m="$(uname -m)"
    os="$(uname -s)"
    if [ "$os" = "Darwin" ]; then
        case "$m" in
            arm64|aarch64) RUST_TRIPLE="aarch64-apple-darwin"; GO_ARCH="arm64"; DL_ARCH="arm64"  ;;
            x86_64)        RUST_TRIPLE="x86_64-apple-darwin";  GO_ARCH="amd64"; DL_ARCH="x86_64" ;;
            *) echo "Unsupported architecture: $m" >&2; return 1 ;;
        esac
    else
        case "$m" in
            arm64|aarch64) RUST_TRIPLE="aarch64-unknown-linux-musl"; GO_ARCH="arm64"; DL_ARCH="aarch64" ;;
            x86_64)        RUST_TRIPLE="x86_64-unknown-linux-musl";  GO_ARCH="amd64"; DL_ARCH="x86_64"  ;;
            *) echo "Unsupported architecture: $m" >&2; return 1 ;;
        esac
    fi
}

# Resolve the latest release of repo $1 whose asset matches regex $2. Prints
# "<tag> <url>", or nothing on a miss. Always exits 0. Honours $GITHUB_TOKEN to
# dodge the 60-req/hr unauthenticated API limit.
gh_release() {
    local repo="$1" re="$2" json tag url
    local hdr=()
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        hdr=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
    fi
    json="$(curl -fsSL "${hdr[@]+"${hdr[@]}"}" \
        "https://api.github.com/repos/${repo}/releases/latest" 2>/dev/null)" || return 0
    tag="$(printf '%s\n' "$json" | grep -oE '"tag_name": *"[^"]+"' | head -n1 | cut -d'"' -f4 || true)"
    url="$(printf '%s\n' "$json" | grep -oE '"browser_download_url": *"[^"]+"' \
        | cut -d'"' -f4 | grep -E "$re" | head -n1 || true)"
    if [ -n "$url" ]; then
        printf '%s %s\n' "${tag:-unknown}" "$url"
    fi
    return 0
}

# Place a single binary in ~/.local/bin. Handles .tar.gz/.tar.xz, .zip, or a raw
# binary download.
install_binary() {
    local name="$1" url="$2" tmp found
    tmp="$(mktemp -d)"
    mkdir -p "$HOME/.local/bin"
    case "$url" in
        *.tar.gz|*.tgz|*.tar.xz)
            curl -fsSL "$url" -o "$tmp/a" && tar -xf "$tmp/a" -C "$tmp"
            ;;
        *.zip)
            curl -fsSL "$url" -o "$tmp/a.zip" && unzip -q "$tmp/a.zip" -d "$tmp"
            ;;
        *)
            if curl -fsSL "$url" -o "$tmp/$name"; then
                install -m 0755 "$tmp/$name" "$HOME/.local/bin/$name"
                rm -rf "$tmp"
                return 0
            fi
            rm -rf "$tmp"
            return 1
            ;;
    esac
    # Archives name the binary after the tool (rg, fd, ...) or after the target
    # triple (codex-aarch64-apple-darwin); fall back to the first executable.
    found="$(find "$tmp" -type f -name "$name" -print -quit 2>/dev/null || true)"
    if [ -z "$found" ]; then
        found="$(find "$tmp" -type f -name "${name}-*" -perm -u+x -print -quit 2>/dev/null || true)"
    fi
    if [ -z "$found" ]; then
        found="$(find "$tmp" -type f -perm -u+x -print -quit 2>/dev/null || true)"
    fi
    if [ -z "$found" ]; then
        rm -rf "$tmp"
        return 1
    fi
    install -m 0755 "$found" "$HOME/.local/bin/$name"
    rm -rf "$tmp"
}

# Install (or, with UPGRADE=1, refresh) a single-binary tool from a GitHub release.
fetch_gh() {
    local name="$1" repo="$2" re="$3" have rel tag url
    have="$(recorded_version "$name")"

    if command -v "$name" >/dev/null 2>&1 && [ "${UPGRADE:-0}" != "1" ]; then
        echo "  • $name (already installed)"
        return 0
    fi
    if ! dotfiles_owns "$name"; then
        echo "  • $name (managed outside this repo: $(command -v "$name"))"
        return 0
    fi

    rel="$(gh_release "$repo" "$re")"
    if [ -z "$rel" ]; then
        echo "  ✗ $name — no release asset matched /$re/ (skipping)"
        return 0
    fi
    tag="${rel%% *}"
    url="${rel#* }"

    if [ -n "$have" ] && [ "$have" = "$tag" ] && command -v "$name" >/dev/null 2>&1; then
        echo "  • $name $tag (up to date)"
        return 0
    fi

    if ! install_binary "$name" "$url"; then
        echo "  ✗ $name — download or extraction failed (skipping)"
        return 0
    fi
    record_version "$name" "$tag"
    if [ -n "$have" ] && [ "$have" != "$tag" ]; then
        echo "  ↑ $name $have → $tag"
    else
        echo "  ✓ $name $tag"
    fi
}

# --- Tools that need more than a single binary drop -------------------------

# Neovim ships its runtime tree; extract whole, symlink the binary.
install_neovim() {
    local asset have rel tag url tmp
    if [ "$(uname -s)" = "Darwin" ]; then
        asset="nvim-macos-${DL_ARCH}\.tar\.gz$"
    else
        asset="nvim-linux-${DL_ARCH}\.tar\.gz$"
    fi
    have="$(recorded_version nvim)"
    if command -v nvim >/dev/null 2>&1 && [ "${UPGRADE:-0}" != "1" ]; then
        echo "  • nvim (already installed)"
        return 0
    fi
    if ! dotfiles_owns nvim; then
        echo "  • nvim (managed outside this repo: $(command -v nvim))"
        return 0
    fi
    rel="$(gh_release neovim/neovim "$asset")"
    if [ -z "$rel" ]; then
        echo "  ✗ nvim — no release asset matched (skipping)"
        return 0
    fi
    tag="${rel%% *}"
    url="${rel#* }"
    if [ -n "$have" ] && [ "$have" = "$tag" ] && command -v nvim >/dev/null 2>&1; then
        echo "  • nvim $tag (up to date)"
        return 0
    fi
    tmp="$(mktemp -d)"
    if ! curl -fsSL "$url" -o "$tmp/nvim.tar.gz"; then
        rm -rf "$tmp"
        echo "  ✗ nvim — download failed (skipping)"
        return 0
    fi
    tar -xf "$tmp/nvim.tar.gz" -C "$tmp"
    local tree legacy
    tree="$(find "$tmp" -maxdepth 1 -type d -name 'nvim-*' -print -quit)"
    if [ -z "$tree" ]; then
        rm -rf "$tmp"
        echo "  ✗ nvim — unexpected archive layout (skipping)"
        return 0
    fi
    mkdir -p "$HOME/.local/bin"
    rm -rf "$HOME/.local/nvim-runtime"
    mv "$tree" "$HOME/.local/nvim-runtime"
    ln -sf "$HOME/.local/nvim-runtime/bin/nvim" "$HOME/.local/bin/nvim"
    rm -rf "$tmp"
    # Older installs of this repo unpacked into ~/.local/nvim-macos-<arch>.
    for legacy in "$HOME/.local"/nvim-macos-* "$HOME/.local"/nvim-linux-*; do
        [ -d "$legacy" ] && rm -rf "$legacy"
    done
    record_version nvim "$tag"
    if [ -n "$have" ] && [ "$have" != "$tag" ]; then
        echo "  ↑ nvim $have → $tag"
    else
        echo "  ✓ nvim $tag"
    fi
}

# Go — extract the toolchain to ~/.local/go (PATH wired in config.fish).
install_go() {
    local have ver tmp os
    os="$(uname -s | tr '[:upper:]' '[:lower:]')"
    have="$(recorded_version go)"
    if command -v go >/dev/null 2>&1 && [ "${UPGRADE:-0}" != "1" ]; then
        echo "  • go (already installed)"
        return 0
    fi
    if ! dotfiles_owns go "$HOME/.local/go/bin"; then
        echo "  • go (managed outside this repo: $(command -v go))"
        return 0
    fi
    ver="$(curl -fsSL 'https://go.dev/dl/?mode=json' \
        | grep -oE '"version": *"go[0-9.]+"' | head -n1 | cut -d'"' -f4 || true)"
    if [ -z "$ver" ]; then
        echo "  ✗ go — could not resolve latest version (skipping)"
        return 0
    fi
    if [ "$have" = "$ver" ] && command -v go >/dev/null 2>&1; then
        echo "  • go $ver (up to date)"
        return 0
    fi
    tmp="$(mktemp -d)"
    if ! curl -fsSL "https://go.dev/dl/${ver}.${os}-${GO_ARCH}.tar.gz" -o "$tmp/go.tar.gz"; then
        rm -rf "$tmp"
        echo "  ✗ go — download failed (skipping)"
        return 0
    fi
    rm -rf "$HOME/.local/go"
    mkdir -p "$HOME/.local"
    tar -xf "$tmp/go.tar.gz" -C "$HOME/.local"
    rm -rf "$tmp"
    record_version go "$ver"
    if [ -n "$have" ] && [ "$have" != "$ver" ]; then
        echo "  ↑ go $have → $ver"
    else
        echo "  ✓ go $ver"
    fi
}

# fnm and starship ship official installers that always fetch the latest build,
# so re-running them is how we upgrade.
install_fnm() {
    if command -v fnm >/dev/null 2>&1 && [ "${UPGRADE:-0}" != "1" ]; then
        echo "  • fnm (already installed)"
        return 0
    fi
    if ! dotfiles_owns fnm; then
        echo "  • fnm (managed outside this repo: $(command -v fnm))"
        return 0
    fi
    if curl -fsSL https://fnm.vercel.app/install \
        | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell >/dev/null 2>&1; then
        echo "  ✓ fnm $(fnm --version 2>/dev/null || echo installed)"
    else
        echo "  ✗ fnm — installer failed (skipping)"
    fi
}

install_starship() {
    if command -v starship >/dev/null 2>&1 && [ "${UPGRADE:-0}" != "1" ]; then
        echo "  • starship (already installed)"
        return 0
    fi
    if ! dotfiles_owns starship; then
        echo "  • starship (managed outside this repo: $(command -v starship))"
        return 0
    fi
    if curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin" >/dev/null 2>&1; then
        echo "  ✓ starship $(starship --version 2>/dev/null | head -n1 || echo installed)"
    else
        echo "  ✗ starship — installer failed (skipping)"
    fi
}

# GNU Stow — a Perl program (Perl ships with macOS); build it from source.
install_stow() {
    local tmp
    if command -v stow >/dev/null 2>&1; then
        echo "  • stow (already installed)"
        return 0
    fi
    echo "Installing stow (from source)..."
    tmp="$(mktemp -d)"
    if curl -fsSL https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz -o "$tmp/stow.tar.gz"; then
        tar -xf "$tmp/stow.tar.gz" -C "$tmp"
        ( cd "$tmp"/stow-* && ./configure --prefix="$HOME/.local" >/dev/null && make install >/dev/null )
        echo "  ✓ stow"
    else
        echo "  ✗ stow — download failed"
    fi
    rm -rf "$tmp"
}

# fish — signed .pkg, installs to /usr/local/bin (needs sudo).
install_fish_macos() {
    local have rel tag url tmp
    have="$(recorded_version fish)"
    if command -v fish >/dev/null 2>&1 && [ "${UPGRADE:-0}" != "1" ]; then
        echo "  • fish (already installed)"
        return 0
    fi
    if ! dotfiles_owns fish /usr/local/bin; then
        echo "  • fish (managed outside this repo: $(command -v fish))"
        return 0
    fi
    rel="$(gh_release fish-shell/fish-shell '\.pkg$')"
    if [ -z "$rel" ]; then
        echo "  ✗ fish — no .pkg asset found (skipping)"
        return 0
    fi
    tag="${rel%% *}"
    url="${rel#* }"
    if [ -n "$have" ] && [ "$have" = "$tag" ] && command -v fish >/dev/null 2>&1; then
        echo "  • fish $tag (up to date)"
        return 0
    fi
    echo "Installing fish $tag (.pkg, requires sudo)..."
    tmp="$(mktemp -d)"
    if curl -fsSL "$url" -o "$tmp/fish.pkg" && sudo installer -pkg "$tmp/fish.pkg" -target /; then
        record_version fish "$tag"
        echo "  ✓ fish $tag"
    else
        echo "  ✗ fish — install failed (skipping)"
    fi
    rm -rf "$tmp"
}

# --- macOS GUI bits ---------------------------------------------------------

# iTerm2 keeps itself current through Sparkle once installed, so this only ever
# does the initial download.
install_iterm2_app() {
    local tmp
    if [ -d "/Applications/iTerm.app" ]; then
        echo "  • iTerm2 (installed; self-updates via Sparkle)"
        return 0
    fi
    echo "Installing iTerm2..."
    tmp="$(mktemp -d)"
    if curl -fsSL "https://iterm2.com/downloads/stable/latest" -o "$tmp/iterm2.zip" \
        && unzip -q "$tmp/iterm2.zip" -d "$tmp" && [ -d "$tmp/iTerm.app" ]; then
        cp -R "$tmp/iTerm.app" /Applications/
        xattr -dr com.apple.quarantine /Applications/iTerm.app 2>/dev/null || true
        echo "  ✓ iTerm2"
    else
        echo "  ✗ iTerm2 — download failed (grab it from https://iterm2.com)"
    fi
    rm -rf "$tmp"
}

# Point iTerm2 at the stowed prefs folder.
#
# It has to be the prefs/ SUBDIRECTORY: iTerm2 itself owns ~/.config/iterm2,
# where it keeps a live socket and symlinks into its app support directory.
# ~/.config/iterm2/prefs is a symlink to this repo, so anything changed in
# iTerm2's UI is saved straight back here and shows up in `git diff` — revert
# with: git -C "$DOTFILES_DIR" checkout iterm2
use_iterm2_prefs() {
    [ -d "$HOME/.config/iterm2/prefs" ] || return 0
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.config/iterm2/prefs"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
    echo "  ✓ iTerm2 prefs ← ~/.config/iterm2/prefs"
    # pgrep -x misses it on macOS; match the executable path instead.
    if ps -Ao comm= 2>/dev/null | grep -q '/iTerm\.app/Contents/MacOS/iTerm2$'; then
        echo "  ! iTerm2 is running with its old settings and will write them back on quit."
        echo "    Quit iTerm2 (⌘Q) and reopen it; if the repo copy got clobbered, run:"
        echo "      git -C \"$DOTFILES_DIR\" checkout iterm2"
    fi
}

# JetBrainsMono Nerd Font — what iTerm2, tmux and the starship prompt expect.
install_nerd_font() {
    local dest="$HOME/Library/Fonts" rel url tmp
    [ "$(uname -s)" = "Darwin" ] || dest="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
    if ls "$dest"/JetBrainsMonoNerdFont-*.ttf >/dev/null 2>&1; then
        echo "  • JetBrainsMono Nerd Font (already installed)"
        return 0
    fi
    echo "Installing JetBrainsMono Nerd Font..."
    rel="$(gh_release ryanoasis/nerd-fonts 'JetBrainsMono\.zip$')"
    if [ -z "$rel" ]; then
        echo "  ✗ nerd font — no release asset found (get it from nerdfonts.com)"
        return 0
    fi
    url="${rel#* }"
    tmp="$(mktemp -d)"
    if curl -fsSL "$url" -o "$tmp/font.zip" && unzip -q "$tmp/font.zip" -d "$tmp"; then
        mkdir -p "$dest"
        # Just the proportional and strict-mono faces; skip the NL/Propo variants.
        find "$tmp" -type f \( -name 'JetBrainsMonoNerdFont-*.ttf' \
            -o -name 'JetBrainsMonoNerdFontMono-*.ttf' \) -exec cp {} "$dest/" \;
        echo "  ✓ JetBrainsMono Nerd Font (${rel%% *})"
    else
        echo "  ✗ nerd font — download failed (skipping)"
    fi
    rm -rf "$tmp"
}

# --- Codex ------------------------------------------------------------------

# The Codex CLI rewrites ~/.codex/config.toml itself (model picks, plugins, MCP
# servers), so the repo copy is a seed rather than a symlink — it is only
# copied in when there is nothing there yet.
seed_codex_config() {
    local src="$DOTFILES_DIR/codex/.codex/config.toml" dst="$HOME/.codex/config.toml"
    [ -f "$src" ] || return 0
    mkdir -p "$HOME/.codex"
    if [ -e "$dst" ]; then
        echo "  • codex config (kept existing ~/.codex/config.toml)"
    else
        cp "$src" "$dst"
        echo "  ✓ codex config seeded from the repo"
    fi
}

# --- Housekeeping -----------------------------------------------------------

# Tools that used to be stowed here leave a broken symlink behind once their
# package is gone. Clear those, and only those — a real config someone still
# wants is left untouched.
DROPPED_PACKAGES=(ghostty)

prune_dropped_links() {
    local pkg link
    for pkg in "${DROPPED_PACKAGES[@]}"; do
        link="$HOME/.config/$pkg"
        if [ -L "$link" ] && [ ! -e "$link" ]; then
            rm "$link"
            echo "  ✓ removed the dangling ~/.config/$pkg symlink"
        fi
    done
}

# --- Bundles ----------------------------------------------------------------

install_macos_tools() {
    mkdir -p "$HOME/.local/bin"
    detect_arch || exit 1

    echo "Installing single-binary CLI tools into ~/.local/bin..."
    # Rust tools — *-apple-darwin tarballs, binary named after the tool.
    fetch_gh rg      BurntSushi/ripgrep     "ripgrep-.*${RUST_TRIPLE}\.tar\.gz$"
    fetch_gh fd      sharkdp/fd             "fd-.*${RUST_TRIPLE}\.tar\.gz$"
    fetch_gh bat     sharkdp/bat            "bat-.*${RUST_TRIPLE}\.tar\.gz$"
    fetch_gh delta   dandavison/delta       "delta-.*${RUST_TRIPLE}\.tar\.gz$"
    fetch_gh zoxide  ajeetdsouza/zoxide     "zoxide-.*${RUST_TRIPLE}\.tar\.gz$"
    fetch_gh codex   openai/codex           "codex-${RUST_TRIPLE}\.tar\.gz$"
    # Go tools — vendor-specific naming.
    fetch_gh fzf     junegunn/fzf           "fzf-.*darwin_${GO_ARCH}\.tar\.gz$"
    fetch_gh lazygit jesseduffield/lazygit   "lazygit_.*darwin_${DL_ARCH}\.tar\.gz$"
    fetch_gh gh      cli/cli                "gh_.*macOS_${GO_ARCH}\.zip$"
    fetch_gh direnv  direnv/direnv          "direnv\.darwin-${GO_ARCH}$"
    fetch_gh jq      jqlang/jq              "jq-macos-${GO_ARCH}$"
    fetch_gh tmux    tmux/tmux-builds       "tmux-.*macos-${DL_ARCH}\.tar\.gz$"

    install_neovim
    install_go
    install_fnm
    install_starship
    install_stow
    install_fish_macos
}

install_linux_tools() {
    detect_arch || exit 1

    if command -v apt >/dev/null 2>&1; then
        echo "Installing packages via apt..."
        sudo apt update
        sudo apt install -y fish stow zoxide direnv neovim tmux fzf fd-find ripgrep bat gh
        # fd and bat have different binary names on Debian/Ubuntu
        mkdir -p "$HOME/.local/bin"
        [ -x "$(command -v fdfind)" ] && ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
        [ -x "$(command -v batcat)" ] && ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
    elif command -v dnf >/dev/null 2>&1; then
        echo "Installing packages via dnf..."
        sudo dnf install -y fish stow zoxide direnv neovim tmux fzf fd-find ripgrep bat starship gh
    elif command -v pacman >/dev/null 2>&1; then
        echo "Installing packages via pacman..."
        sudo pacman -S --noconfirm fish stow zoxide direnv neovim tmux fzf fd ripgrep bat starship github-cli
    else
        echo "Unknown package manager. Please install: fish stow zoxide direnv neovim fzf fd ripgrep bat"
        exit 1
    fi

    # Not packaged by the distros — pull these from upstream releases.
    echo "Installing tools not in the distro repos..."
    fetch_gh codex openai/codex "codex-${RUST_TRIPLE}\.tar\.gz$"
    install_starship
    install_fnm
}

# Refresh everything the distro package manager owns on Linux.
upgrade_linux_packages() {
    if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt upgrade -y
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf upgrade -y
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Syu --noconfirm
    fi
}
