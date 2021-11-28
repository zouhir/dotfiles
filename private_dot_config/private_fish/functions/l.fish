
function l --description 'Use exa to list directory content as a tabel, grouping child directories first'
  exa -lah --time-style='long-iso' --group-directories-first $argv;
end