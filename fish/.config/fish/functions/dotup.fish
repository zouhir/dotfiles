function dotup --description "Update the dotfiles repo, symlinks, and every managed tool"
    set -l repo $DOTFILES

    # Fall back to walking back from the stow symlink of this very config.
    if test -z "$repo"
        set -l linked (realpath ~/.config/fish/config.fish 2>/dev/null)
        if test -n "$linked"
            set repo (string replace -r '/fish/\.config/fish/config\.fish$' '' -- $linked)
        end
    end

    if test -z "$repo" -o ! -f "$repo/update.sh"
        set repo $HOME/Projects/dotfiles
    end

    if not test -f "$repo/update.sh"
        echo "dotup: could not find update.sh — set \$DOTFILES to your dotfiles checkout" >&2
        return 1
    end

    bash "$repo/update.sh" $argv
end
