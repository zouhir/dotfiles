function zd --description "Start or attach to the dev tmux session"
    if not tmux has-session -t=dev 2>/dev/null
        tmux new-session -d -s dev
    end

    if set -q TMUX
        tmux switch-client -t dev
    else
        tmux attach-session -t dev
    end
end
