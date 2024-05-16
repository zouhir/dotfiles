#!/bin/bash

if [[ $OSTYPE == "darwin"* ]]; then
    # Install CommandLineTools if not installed.
    if pkgutil --pkgs=com.apple.pkg.CLTools_Executables >/dev/null; then
            echo "macOS CommandLineTools are installed."
        echo CommandLineTools: $(pkgutil --pkg-info=com.apple.pkg.CLTools_Executables | awk '/version:/ {print $2}')
    else
        echo "Installing macOS CommandLineTools."
        echo "The script will continue once installation is finished . . ."
        xcode-select --install &> /dev/null
        until pkgutil --pkgs=com.apple.pkg.CLTools_Executables >/dev/null; do
        sleep 2
    done
    fi
fi

if [[ $OSTYPE == "darwin"* ]]; then
    # Install python3 if not installed.
    if python3 --version >/dev/null 2>&1; then
        echo "python3 is installed."
    else
        echo "Error python3 is not installed."
        exit 1
    fi

    # Install pip if not installed.
    if python3 -m pip -V >/dev/null 2>&1; then
        echo "pip is installed."
    else
        echo "pip is not installed."
        exit 1
    fi

    # Install Ansible if not installed.
    if ansible --version >/dev/null 2>&1; then
        echo "Ansible is installed."
    else
        echo "Installing Ansible."
        python3 -m pip install ansible
    fi

    # Ensure pip binaies install location is in path.
    # Get python version.
    py_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    pip_path="$HOME/Library/Python/$py_version/bin"

    if [ -d "$pip_path" ]; then
        echo "PIP_PATH exists: $pip_path"
        export PATH="$pip_path:$PATH"
    else
        echo "PIP_PATH does not exist: $pip_path"
        exit 1
    fi

    if [ -d "/opt/homebrew" ]; then
        if [ ! "$(command -v brew)" ]; then
            eval $(/opt/homebrew/bin/brew shellenv)
        fi
    else
        if [ ! "$(command -v brew)" ]; then
            echo "Homebrew is not installed."
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            eval $(/opt/homebrew/bin/brew shellenv)
        fi
    fi
else
    # Update the package list
    sudo apt-get update 
    sudo apt-get install ansible
fi

ask_computer_type() {
    local type
    while true; do
        read -p "What type of computer are you provisioning? (personal/work)? " type
            case $type in personal|work)
                export COMPUTER_TYPE="$type"
                return
                ;;
            *)
                echo "Invalid input. Please enter 'personal' or 'work'."
                ;;
        esac
    done
}

ask_computer_kind() {
    local kind
    while true; do
        read -p "What kind of computer are you provisioning? (client/server)? " kind
            case $kind in client|server)
                export COMPUTER_KIND="$kind"
                return
                ;;
            *)
                echo "Invalid input $kind. Please enter 'client' or 'server'."
                ;;
        esac
    done
}

if [ -z "${COMPUTER_TYPE}" ]; then
    ask_computer_type
fi

if [ -z "${COMPUTER_KIND}" ]; then
    ask_computer_kind
fi

if [ -z "${WORK_DOTFILES_URL}" ]; then
    read -p "Enter the URL for work dotfiles repo: " WORK_DOTFILES_URL
    export WORK_DOTFILES_URL
fi

ansible-galaxy collection install community.general

ansible-playbook tasks.yml --ask-become-pass -e "computer_type=${COMPUTER_TYPE}" -e "computer_kind=${COMPUTER_KIND}" -e "work_dotfiles_url=${WORK_DOTFILES_URL}" -e "py_version=${py_version}" -t "dotfiles"

# ansible-playbook tasks.yml --ask-become-pass -e "computer_type=${COMPUTER_TYPE}" -e "computer_kind=${COMPUTER_KIND}" -e "work_dotfiles_url=${WORK_DOTFILES_URL}" -e "py_version=${py_version}"