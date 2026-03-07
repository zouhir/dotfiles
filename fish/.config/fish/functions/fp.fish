function fp --description "Fuzzy pick a project and open it as a Zellij tab"
    if not set -q ZELLIJ
        echo "Not inside Zellij. Run 'zd' to start a session first."
        return 1
    end

    set -l projects_dir "$HOME/Projects"
    set -l recents_file "$HOME/.local/share/zellij-recent-projects"

    # Ensure recents file exists
    mkdir -p (dirname $recents_file)
    touch $recents_file

    # Pick a project with fzf
    set -l project (fd --type d --max-depth 1 --base-directory $projects_dir | \
        sed 's|/$||' | \
        fzf --prompt="Project: " --preview="ls -la $projects_dir/{}")

    if test -z "$project"
        return 0
    end

    set -l project_path "$projects_dir/$project"

    # Log to recents (prepend, deduplicate, keep last 50)
    set -l tmp (mktemp)
    echo $project >$tmp
    if test -f $recents_file
        grep -v "^$project\$" $recents_file >>$tmp
    end
    head -n 50 $tmp >$recents_file
    rm -f $tmp

    # Jump to existing tab or create new one
    zellij action go-to-tab-name $project 2>/dev/null
    or zellij action new-tab --name $project --cwd $project_path
end
