#!/bin/bash
set -eo pipefail

# Bring an already-provisioned machine up to date: pull this repo, refresh the
# symlinks, and re-resolve every managed tool against its latest upstream
# release. Safe to run as often as you like — tools already on the newest tag
# are skipped without downloading anything.
#
#   ./update.sh              everything
#   ./update.sh --no-pull    skip `git pull` (keep the repo where it is)
#   ./update.sh --links      only re-stow the symlinks
#   ./update.sh --tools      only refresh the installed tools

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib.sh
source "$DOTFILES_DIR/lib.sh"

export UPGRADE=1

DO_PULL=1
DO_LINKS=1
DO_TOOLS=1

while [ $# -gt 0 ]; do
    case "$1" in
        --no-pull) DO_PULL=0 ;;
        --links)   DO_TOOLS=0; DO_PULL=0 ;;
        --tools)   DO_LINKS=0; DO_PULL=0 ;;
        -h|--help) sed -n '4,13p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
    shift
done

# ----------------------------------------------------------------------------
# 1. The repo itself
# ----------------------------------------------------------------------------

if [ "$DO_PULL" = 1 ] && git -C "$DOTFILES_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    echo "Updating the dotfiles repo..."
    if ! git -C "$DOTFILES_DIR" remote get-url origin >/dev/null 2>&1; then
        echo "  • no 'origin' remote — skipping pull"
    elif [ -n "$(git -C "$DOTFILES_DIR" status --porcelain)" ]; then
        echo "  ! local changes present — skipping pull (commit or stash first):"
        git -C "$DOTFILES_DIR" status --short | sed 's/^/      /'
    elif git -C "$DOTFILES_DIR" pull --ff-only --quiet; then
        echo "  ✓ $(git -C "$DOTFILES_DIR" log -1 --format='%h %s')"
    else
        echo "  ✗ pull failed — resolve it by hand"
    fi
fi

# ----------------------------------------------------------------------------
# 2. Symlinks
# ----------------------------------------------------------------------------

if [ "$DO_LINKS" = 1 ]; then
    echo "Refreshing symlinks..."
    prune_dropped_links
    mkdir -p "$HOME/.config/fish/conf.d" "$HOME/.config/fish/functions/local"
    cd "$DOTFILES_DIR"
    for pkg in "${STOW_PACKAGES[@]}"; do
        stow -R -t "$HOME" "$pkg" 2>&1 | sed 's/^/  /' || true
    done
    echo "  ✓ ${#STOW_PACKAGES[@]} packages linked"
fi

# ----------------------------------------------------------------------------
# 3. Tools
# ----------------------------------------------------------------------------

if [ "$DO_TOOLS" = 1 ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Checking CLI tools for updates..."
        install_macos_tools
        echo "Checking GUI bits..."
        install_nerd_font
        install_iterm2_app
    else
        echo "Updating distro packages..."
        upgrade_linux_packages
        echo "Checking upstream tools..."
        detect_arch
        fetch_gh codex openai/codex "codex-${RUST_TRIPLE}\.tar\.gz$"
        install_starship
        install_fnm
    fi

    # Node.js LTS
    if command -v fnm >/dev/null 2>&1; then
        echo "Updating Node.js LTS..."
        fnm install --lts >/dev/null 2>&1 && echo "  ✓ node $(fnm current 2>/dev/null || echo lts)"
    fi

    # Neovim plugins
    if command -v nvim >/dev/null 2>&1; then
        echo "Syncing Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 && echo "  ✓ lazy.nvim" \
            || echo "  ! lazy.nvim sync reported a problem — open nvim and run :Lazy"
    fi

    # Claude Code, if it manages its own binary
    if command -v claude >/dev/null 2>&1; then
        echo "Updating Claude Code..."
        claude update 2>&1 | sed 's/^/  /' || true
    fi
fi

# ----------------------------------------------------------------------------
# 4. iTerm2 prefs folder
# ----------------------------------------------------------------------------

if [[ "$OSTYPE" == "darwin"* ]] && [ "$DO_LINKS" = 1 ]; then
    PLIST="$DOTFILES_DIR/iterm2/.config/iterm2/prefs/com.googlecode.iterm2.plist"
    # iTerm2 saves its settings back as a binary plist; keep the repo copy XML
    # so changes show up as a readable diff.
    if [ -f "$PLIST" ] && ! head -c 64 "$PLIST" | grep -q '<?xml'; then
        plutil -convert xml1 "$PLIST" && echo "iTerm2 prefs re-serialised as XML for a readable diff."
    fi
fi

echo
echo "Up to date."
if git -C "$DOTFILES_DIR" rev-parse --git-dir >/dev/null 2>&1 \
    && [ -n "$(git -C "$DOTFILES_DIR" status --porcelain)" ]; then
    echo "Uncommitted changes in $DOTFILES_DIR:"
    git -C "$DOTFILES_DIR" status --short | sed 's/^/  /'
fi
