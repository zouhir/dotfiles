function fr --description "Fuzzy pick from recently opened projects"
    set -l projects_dir "$HOME/Projects"
    set -l recents_file "$HOME/.local/share/tmux-recent-projects"

    if not test -f $recents_file; or test -z "$(cat $recents_file | string trim)"
        echo "No recent projects. Use 'fp' to open a project first."
        return 1
    end

    # Filter out deleted projects, show in recency order (--no-sort)
    set -l project (while read -l line
        if test -d "$projects_dir/$line"
            echo $line
        end
    end <$recents_file | fzf --prompt="Recent: " --no-sort --preview="ls -la $projects_dir/{}")

    if test -z "$project"
        return 0
    end

    set -l project_path "$projects_dir/$project"

    # Bump to top of recents
    set -l tmp (mktemp)
    echo $project >$tmp
    grep -v "^$project\$" $recents_file >>$tmp
    head -n 50 $tmp >$recents_file
    rm -f $tmp

    # Create session if it doesn't exist
    if not tmux has-session -t=$project 2>/dev/null
        tmux new-session -d -s $project -c $project_path
    end

    # Switch or attach depending on context
    if set -q TMUX
        tmux switch-client -t $project
    else
        tmux attach-session -t $project
    end
end
