function prompt_seg_git
    # TokyoNight: magenta #bb9af7, yellow #e0af68, green #9ece6a, red #f7768e
    set -l color_branch bb9af7
    set -l color_dirty e0af68
    set -l color_staged 9ece6a
    set -l color_conflict f7768e

    command git rev-parse --is-inside-work-tree 2>/dev/null >/dev/null
    or return

    set -l branch (command git branch --show-current 2>/dev/null)
    if test -z "$branch"
        set branch (command git rev-parse --short HEAD 2>/dev/null)
    end

    set_color $color_branch
    echo -n "on  $branch"
    set_color normal

    # Status indicators
    set -l info ""
    set -l git_status (command git status --porcelain=v1 2>/dev/null)

    # Staged
    set -l staged_count (string match -r '^[MADRC]' -- $git_status | count)
    if test $staged_count -gt 0
        set info $info(set_color $color_staged)"+$staged_count"(set_color normal)
    end

    # Modified/untracked
    set -l dirty_count (string match -r '^.[MD?]' -- $git_status | count)
    if test $dirty_count -gt 0
        set info $info(set_color $color_dirty)"!$dirty_count"(set_color normal)
    end

    # Conflicts
    set -l conflict_count (string match -r '^[UDA][UDA]' -- $git_status | count)
    if test $conflict_count -gt 0
        set info $info(set_color $color_conflict)"=$conflict_count"(set_color normal)
    end

    # Ahead/behind
    set -l ab (command git rev-list --left-right --count HEAD...@'{u}' 2>/dev/null)
    if test $status -eq 0
        set -l parts (string split \t -- $ab)
        set -l ahead $parts[1]
        set -l behind $parts[2]
        test "$ahead" -gt 0; and set info $info(set_color $color_staged)"⇡$ahead"(set_color normal)
        test "$behind" -gt 0; and set info $info(set_color $color_conflict)"⇣$behind"(set_color normal)
    end

    if test -n "$info"
        echo -n " [$info]"
    end
end
