function fs --description "Fuzzy switch between tmux sessions"
    if not set -q TMUX
        echo "Not inside tmux. Run 'fp' or 'fr' to start a session first."
        return 1
    end

    set -l session (tmux list-sessions -F "#{session_name}" | fzf --prompt="Session: ")

    if test -z "$session"
        return 0
    end

    tmux switch-client -t $session
end
