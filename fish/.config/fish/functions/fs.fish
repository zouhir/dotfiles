function fs --description "Fuzzy switch between tmux sessions (fzf)"
    if not type -q tmux
        echo "tmux not installed"
        return 1
    end

    set -l current (tmux display-message -p '#S' 2>/dev/null)
    set -l sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null)

    if test -z "$sessions"
        echo "no tmux sessions"
        return 1
    end

    # Mark the current session with a dot so the user always knows where they are
    set -l lines
    for s in $sessions
        if test "$s" = "$current"
            set -a lines "● $s"
        else
            set -a lines "  $s"
        end
    end

    set -l picked (printf "%s\n" $lines | fzf \
        --prompt="session> " \
        --reverse \
        --height=100% \
        --border=none \
        --color="bg+:#292e42,fg+:#c0caf5,hl:#7aa2f7,hl+:#7aa2f7,prompt:#bb9af7,pointer:#ff007c,marker:#9ece6a,info:#565f89")

    if test -z "$picked"
        return 0
    end

    # Strip the marker/spacing
    set -l target (string sub -s 3 -- $picked)

    if test "$target" = "$current"
        return 0
    end

    if set -q TMUX
        tmux switch-client -t $target
    else
        tmux attach-session -t $target
    end
end
