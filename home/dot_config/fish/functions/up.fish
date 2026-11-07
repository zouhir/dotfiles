function up --description 'Update dotfiles, OS packages, CLI tools and editor plugins'
    chezmoi update
    or return

    switch (uname)
        case Darwin
            brew update
            and brew upgrade
        case Linux
            sudo dnf upgrade --refresh -y
            and flatpak update -y --noninteractive
    end
    or return

    mise self-update -y
    mise upgrade
    nvim --headless '+Lazy! sync' +qa
    echo
end
