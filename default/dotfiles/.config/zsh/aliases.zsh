#Aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

{% if computer_type == "work" %}
{% set file_contents = lookup('file', playbook_dir + '/work/dotfiles/.config/zsh/aliases.zsh') %}
{{ file_contents }}
{% endif %}