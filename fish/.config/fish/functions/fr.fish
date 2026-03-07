function fr --description "Fuzzy pick from recently opened projects"
    if not set -q ZELLIJ
        echo "Not inside Zellij. Run 'zd' to start a session first."
        return 1
    end

    set -l projects_dir "$HOME/Projects"
    set -l recents_file "$HOME/.local/share/zellij-recent-projects"

    if not test -f $recents_file; or test -z (cat $recents_file | string trim)
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

    # Jump to existing tab or create new one
    zellij action go-to-tab-name $project 2>/dev/null
    or zellij action new-tab --name $project --cwd $project_path
end
