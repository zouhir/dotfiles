function cat --description 'Replace cat with bat'
  if command -qa bat
	  abbr -a cat 'bat'
  end
  if command -qa batcat
    abbr -a cat 'batcat'
  end
end