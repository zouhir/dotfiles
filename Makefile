SHELL := /bin/bash

BASE_CMD := source ./install.sh && ansible-playbook tasks.yml -e "computer_type=${COMPUTER_TYPE}" -e "computer_kind=${COMPUTER_KIND}" -e "work_dotfiles_url=${WORK_DOTFILES_URL}" -e "py_version=${py_version}"

.PHONY: all dotfiles

all:
	@echo "Running install script..."
	./install.sh
	@echo "Running Ansible playbook for dotfiles..."
	$(BASE_CMD) --ask-become-pass --tags "all" 

dotfiles:
	@echo "Running install script..."
	./install.sh
	@echo "Running Ansible playbook for dotfiles..."
	$(BASE_CMD) --tags "dotfiles" 