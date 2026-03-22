function prompt_seg_path
    # TokyoNight blue
    set -l color_path 7aa2f7

    set -l cwd (pwd)

    # If inside a git repo, show repo_name/relative_path
    set -l git_root (command git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$git_root"
        set -l repo_name (basename $git_root)
        set -l git_rel (string replace -- $git_root "" $cwd)
        if test -z "$git_rel"
            set cwd $repo_name
        else
            set cwd "$repo_name$git_rel"
        end
    else
        # Replace home prefix with ~
        set cwd (string replace -- $HOME "~" $cwd)
        # Truncate to last 3 components when outside git repos
        set -l parts (string split "/" $cwd)
        if test (count $parts) -gt 4
            set cwd "…/"(string join "/" $parts[-3..-1])
        end
    end

    set_color $color_path
    echo -n $cwd
    set_color normal
end
