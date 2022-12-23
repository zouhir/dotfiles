function bk_fish_prompt -d "Write out the prompt"
    
    # Print the last command status and time.
    set -l last_pipestatus $pipestatus
    set -l status_string (__fish_print_pipestatus "[" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)
    if test -n "$status_string"
        echo $status_string
    end

    set -l operator_color $fish_color_operator
    
    if test $status -ne 0
        set operator_color $fish_color_error
    end

    printf '%s in %s in %s%s%s\n❯%s ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color $operator_color) (set_color normal) 
end