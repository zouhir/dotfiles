function fp --description "Fuzzy pick a project and open it in a Zellij session"
    if set -q ZELLIJ
        echo "Already inside Zellij. Detach first (Ctrl+o d) or use a bare terminal."
        return 1
    end

    set -l projects_dir "$HOME/Projects"
    set -l recents_file "$HOME/.local/share/zellij-recent-projects"

    # Ensure recents file exists
    mkdir -p (dirname $recents_file)
    touch $recents_file

    # Pick a project with fzf
    set -l tmpfile (mktemp)
    fd --type d --max-depth 1 --base-directory $projects_dir \
        | sed 's|/$||' \
        | fzf --prompt="Project: " --preview="ls -la $projects_dir/{}" >$tmpfile
    set -l fzf_status $status
    set -l project (string trim < $tmpfile)
    rm -f $tmpfile

    if test $fzf_status -ne 0; or test -z "$project"
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

    # Attach to existing session or create a new one in the project dir
    cd $project_path
    zellij attach --create $project
end
