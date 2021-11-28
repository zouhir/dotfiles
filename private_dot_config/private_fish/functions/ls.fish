function ls --description 'Replace ls with exa and list dir content inline, grouping child directories first'
  exa --group-directories-first $argv;
end