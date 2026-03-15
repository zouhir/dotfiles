function tn --description "Rename the current tmux session"
    if not set -q TMUX
        echo "Not in a tmux session"
        return 1
    end

    if test (count $argv) -eq 0
        echo "Usage: tn <new-name>"
        return 1
    end

    tmux rename-session $argv[1]
end
