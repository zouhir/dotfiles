function prompt_seg_char
    set -l last_status $argv[1]
    test -z "$last_status"; and set last_status 0

    if test $last_status -eq 0
        set_color bb9af7
    else
        set_color f7768e
    end
    echo -n "❯ "
    set_color normal
end
