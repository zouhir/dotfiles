function fs --description "Fuzzy search Zellij tabs in the current session"
    if not set -q ZELLIJ
        echo "Not inside Zellij. Run 'zd' to start a session first."
        return 1
    end

    zellij action launch-or-focus-plugin "session-manager" --floating
end
