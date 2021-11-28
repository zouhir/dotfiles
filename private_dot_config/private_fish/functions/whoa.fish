function whoa --description 'Use the popular Time & Eric universe mindblown gif to express surprise and interest'
	if command -qs gif-for-cli; and test -f ~/.config/fish/assets/whoa.gif
        gif-for-cli --display-mode=256 ~/.config/fish/assets/whoa.gif
    else
        echo "file required to play the expression was not found."
    end
end