function prompt_seg_context
    # TokyoNight purple: #9d7cd8
    # Shows user@host when over SSH, nothing when local
    if test -n "$SSH_CONNECTION"; or test -n "$SSH_CLIENT"; or test -n "$SSH_TTY"
        set_color 9d7cd8
        echo -n (whoami)@(hostname -s)
        set_color normal
    end
end
