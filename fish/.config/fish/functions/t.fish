function t --description 'tmux launcher: no args → last or main; <name> → attach/create; . → smart-name of cwd'
    if set -q TMUX
        echo "already in tmux (session: $(tmux display-message -p '#S'))"
        return 1
    end

    if not type -q tmux
        echo "tmux not installed"
        return 1
    end

    set -l target

    switch (count $argv)
        case 0
            # No sessions: create "main". Any sessions: attach to most-recent.
            if tmux has-session 2>/dev/null
                tmux attach
                return
            else
                set target main
            end
        case '*'
            if test "$argv[1]" = "."
                set target (~/.config/tmux/bin/smart-name.sh (pwd))
            else
                set target $argv[1]
            end
    end

    tmux new-session -A -s $target
end
