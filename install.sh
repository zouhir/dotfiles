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

    # Check if Ansible is installed
    if command -v ansible >/dev/null 2>&1; then
        echo "Ansible is already installed at $(which ansible)."
    else
        echo "Ansible is not installed. Installing with pip3..."

        # Ensure pip3 is available
        if python3 -m pip -V >/dev/null 2>&1; then
            echo "pip3 is installed."
        else
            echo "pip3 is not installed. Installing pip3..."
            python3 -m ensurepip --upgrade || { echo "Failed to install pip3."; exit 1; }
            python3 -m pip install --upgrade pip
        fi

        # Install Ansible using pip3
        python3 -m pip install --user ansible || { echo "Failed to install Ansible."; exit 1; }

        # Ensure the pip3 binaries path is in PATH
        pip_path=$(python3 -m site --user-base)/bin
        if [ -d "$pip_path" ]; then
            if ! echo "$PATH" | grep -q "$pip_path"; then
                echo "Adding $pip_path to PATH."
                export PATH="$pip_path:$PATH"
            fi
        else
            echo "Error: pip3 binaries path not found at $pip_path."
            exit 1
        fi

        echo "Ansible installation completed."
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

if [ -z "${WORK_DOTFILES_URL}" ] && [ "${COMPUTER_TYPE}" == "work" ]; then
    read -p "Enter the URL for work dotfiles repo: " WORK_DOTFILES_URL
    export WORK_DOTFILES_URL
fi

ansible-galaxy collection install community.general