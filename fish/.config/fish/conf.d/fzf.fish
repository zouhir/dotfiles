# Use fd instead of find (respects .gitignore)
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'

# Ctrl+T: fuzzy file picker with bat preview
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_CTRL_T_OPTS '--preview "bat --color=always --style=numbers --line-range=:500 {}" --preview-window=right:60%'

# Alt+C: fuzzy cd with directory preview
set -x FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git'
set -x FZF_ALT_C_OPTS '--preview "ls -la {}"'

# TokyoNight Night colors (matches starship/delta theme)
set -x FZF_DEFAULT_OPTS "\
  --color=bg+:#292e42,bg:#1a1b26,spinner:#7dcfff,hl:#f7768e \
  --color=fg:#c0caf5,header:#f7768e,info:#bb9af7,pointer:#7dcfff \
  --color=marker:#9d7cd8,fg+:#c0caf5,prompt:#bb9af7,hl+:#f7768e \
  --color=selected-bg:#283457 \
  --border rounded --margin 0,1"
