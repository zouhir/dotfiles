set -g fish_greeting

set -gx EDITOR nvim
set -gx LESS '-R -i -M'

test -x /opt/homebrew/bin/brew; and /opt/homebrew/bin/brew shellenv | source
fish_add_path ~/.local/bin

type -q mise; and mise activate fish | source

if status is-interactive
    type -q starship; and starship init fish | source
    type -q zoxide; and zoxide init fish | source
    type -q fzf; and fzf --fish | source
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

# Search
abbr -a ff 'fd --type f --hidden'
abbr -a rg 'rg --smart-case --hidden'
