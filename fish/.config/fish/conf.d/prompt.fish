# Custom prompt: local overrides via functions/local/
# Fish autoloading picks local/{fn}.fish over functions/{fn}.fish
# To override any segment on a specific machine:
#   cp ~/.config/fish/functions/prompt_seg_path.fish ~/.config/fish/functions/local/prompt_seg_path.fish
#   edit to taste

set -l local_fn_path $__fish_config_dir/functions/local
if test -d $local_fn_path; and not contains $local_fn_path $fish_function_path
    set -g fish_function_path $local_fn_path $fish_function_path
end
