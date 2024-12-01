SHELL := /bin/bash

BASE_CMD := source ./install.sh && \
    echo "Computer Type: $$COMPUTER_TYPE" && \
    echo "Computer Kind: $$COMPUTER_KIND" && \
    test -n "$$COMPUTER_TYPE" || (echo "COMPUTER_TYPE is not set"; exit 1) && \
    test -n "$$COMPUTER_KIND" || (echo "COMPUTER_KIND is not set"; exit 1) && \
    ansible-playbook tasks.yml \
    -e "computer_type=$$COMPUTER_TYPE" \
    -e "computer_kind=$$COMPUTER_KIND" \
    -e "work_dotfiles_url=$$WORK_DOTFILES_URL" \
    -e "py_version=$$py_version"


.PHONY: all dotfiles

all:
	@echo "Running complete ansible playbook"
	$(BASE_CMD) --ask-become-pass --tags "all"

dotfiles:
	@echo "Running Ansible playbook for dotfiles..."
	$(BASE_CMD) --tags "dotfiles"
