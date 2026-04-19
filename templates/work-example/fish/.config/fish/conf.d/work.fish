# Work-only fish config — auto-sourced by fish because it lives in conf.d/.
# Runs AFTER the public config.fish, so anything set here wins.

# Work proxies (uncomment and fill in)
# set -x HTTP_PROXY  http://proxy.corp.example:3128
# set -x HTTPS_PROXY $HTTP_PROXY
# set -x NO_PROXY    localhost,127.0.0.1,.corp.example

# Work PATH additions
# fish_add_path "$HOME/.work/bin"

# Work abbreviations
# abbr -a kw 'kubectl --context=work'
# abbr -a vpn 'sudo corp-vpn connect'

# Work-only env (API tokens, endpoints — keep out of public dotfiles)
# set -x CORP_ARTIFACTORY https://artifactory.corp.example

# Point starship at the work-only config (no git modules, since work isn't git-based).
# The public ~/.config/starship.toml stays untouched; this var just redirects starship.
set -gx STARSHIP_CONFIG $HOME/.config/starship-work.toml
