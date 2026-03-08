function fp --description "Fuzzy pick a project and open it in a tmux session"
    set -l projects_dir "$HOME/Projects"
    set -l recents_file "$HOME/.local/share/tmux-recent-projects"

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
