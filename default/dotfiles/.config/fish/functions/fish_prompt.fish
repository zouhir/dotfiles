function fish_prompt
    set_color cyan
    if test "$SSH_CLIENT" = ""    # Check if connected via SSH
        echo -n (whoami) "@" (hostname | cut -d . -f 1) " "
        set_color yellow
        echo -n " " (prompt_pwd)
    else 
        echo -n "@" (hostname) " " 
    end

    # New Line with Unicode Character
    echo " ❯"  # Unicode character U+276F

    set_color green
    echo " \$ "

end