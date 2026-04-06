function fs --description "Fuzzy switch between tmux sessions"
    set -l sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null)
    if test -z "$sessions"
        echo "No tmux sessions. Use 'fp' to start one."
        return 1
    end

    set -l session (printf "%s\n" $sessions | fzf --prompt="Session: ")

    if test -z "$session"
        return 0
    end

    if set -q TMUX
        tmux switch-client -t $session
    else
        tmux attach-session -t $session
    end
end
