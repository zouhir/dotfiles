# Disable greeting
set -U fish_greeting

# Locale
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

# XDG directories
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CACHE_HOME "$HOME/.cache"

# Homebrew (macOS only)
if test (uname) = Darwin
    set -x HOMEBREW_PREFIX /opt/homebrew
    set -x HOMEBREW_NO_AUTO_UPDATE 1
    set -x HOMEBREW_NO_ANALYTICS 1
end

# Editor
set -x EDITOR nvim

# Pager (less) options: colors, case-insensitive search, verbose prompt
set -x LESS '-R -i -M'

# PATH
if test (uname) = Darwin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
end
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.local/bin"

# fnm (Node.js version manager)
if type -q fnm
    fnm env | source
end

# Zoxide (fast directory navigation)
if type -q zoxide
    zoxide init fish | source
end

# Direnv (per-directory environment variables)
if type -q direnv
    direnv hook fish | source
end

# Starship prompt
if type -q starship
    starship init fish | source
end

# fzf (fuzzy finder keybindings: Ctrl+R, Ctrl+T, Alt+C)
if type -q fzf
    fzf --fish | source
end

# --- Abbreviations ---
# Git
abbr -a g git
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gaa 'git add --all'
abbr -a gc 'git commit'
abbr -a gcm 'git commit -m'
abbr -a gca 'git commit --amend'
abbr -a gp 'git push'
abbr -a gpf 'git push --force-with-lease'
abbr -a gl 'git pull'
abbr -a gf 'git fetch'
abbr -a gco 'git checkout'
abbr -a gcb 'git checkout -b'
abbr -a gsw 'git switch'
abbr -a gswc 'git switch -c'
abbr -a gb 'git branch'
abbr -a gd 'git diff'
abbr -a gds 'git diff --staged'
abbr -a glog 'git log --oneline --graph'
abbr -a gst 'git stash'
abbr -a gstp 'git stash pop'
abbr -a grb 'git rebase'
abbr -a grbi 'git rebase -i'
abbr -a grs 'git restore'
abbr -a grss 'git restore --staged'
abbr -a gm 'git merge'
abbr -a gcp 'git cherry-pick'

# Common commands
abbr -a v nvim
abbr -a l 'ls -lah'
abbr -a md 'mkdir -p'
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'

# Homebrew
abbr -a bi 'brew install'
abbr -a bu 'brew update && brew upgrade'
abbr -a bs 'brew search'

# Search
abbr -a ff 'fd --type f --hidden'
abbr -a rg 'rg --smart-case --hidden'
