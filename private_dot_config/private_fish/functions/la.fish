
function la --description 'Use exa to list all directory content inlined, including dotfiles'
  exa -a --group-directories-first $argv;
end