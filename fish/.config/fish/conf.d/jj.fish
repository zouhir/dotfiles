# Merge main jj config with local private config
set -l config_main "$HOME/.jjconfig.toml"
set -l config_local "$HOME/.jjconfig.local.toml"

if test -f "$config_local"
    set -gx JJ_CONFIG "$config_main:$config_local"
else
    set -gx JJ_CONFIG "$config_main"
end
