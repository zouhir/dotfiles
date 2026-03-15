function ta --description "Create or attach to a tmux session named after the current directory"
    set -l session_name (basename $PWD | string replace -a '.' '-')

    if not tmux has-session -t=$session_name 2>/dev/null
        tmux new-session -d -s $session_name -c $PWD
    end

    if set -q TMUX
        tmux switch-client -t $session_name
    else
        tmux attach-session -t $session_name
    end
end
