SHELL := /bin/bash

BASE_CMD := ansible-playbook tasks.yml --ask-become-pass -e "computer_type=${COMPUTER_TYPE}" -e "computer_kind=${COMPUTER_KIND}" -e "work_dotfiles_url=${WORK_DOTFILES_URL}" -e "py_version=${py_version}"

.PHONY: all dotfiles

all:
	@echo "Running install script..."
	./install.sh
	@echo "Running Ansible playbook for dotfiles..."
	$(BASE_CMD) --tags "all" 

dotfiles:
	@echo "Running install script..."
	./install.sh
	@echo "Running Ansible playbook for dotfiles..."
	$(BASE_CMD) --tags "dotfiles" 