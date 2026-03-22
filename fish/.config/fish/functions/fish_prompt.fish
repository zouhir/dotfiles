function fish_prompt
    set -l last_status $status

    # Line 1: path + context segments
    set -l seg_path (prompt_seg_path)
    set -l seg_context (prompt_seg_context)
    set -l seg_git (prompt_seg_git)
    set -l seg_env (prompt_seg_env)

    echo -n $seg_path
    test -n "$seg_context"; and echo -n " "$seg_context
    test -n "$seg_git"; and echo -n " "$seg_git
    test -n "$seg_env"; and echo -n " "$seg_env
    echo

    # Line 2: prompt character
    prompt_seg_char $last_status
end
