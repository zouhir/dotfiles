# Agent Instructions

## Overview

Personal dotfiles for two machines, managed with chezmoi: a MacBook and a Fedora Workstation Framework Desktop. Everything uses the **TokyoNight Night** color scheme. No work configuration belongs in this public repo.

## Layout

`.chezmoiroot` points chezmoi at `home/`. Everything outside `home/` is repo documentation.

- `home/dot_config/<tool>/` — tool configs, using chezmoi's naming (`dot_`, `private_`, `.tmpl`)
- `home/.chezmoidata/packages.yaml` — OS-level packages: Homebrew and dnf/Flatpak
- `home/dot_config/mise/config.toml` — CLI tools and runtimes for both machines
- `home/.chezmoiscripts/{common,darwin,fedora}/` — setup scripts, numbered by run order

## Adding a New Tool

1. Add a CLI tool or runtime to `home/dot_config/mise/config.toml`. Use `packages.yaml` only for GUI apps and things the OS must own, such as the shell.
2. Add its config under `home/dot_config/`.
3. Use a `.tmpl` file only when the two machines genuinely differ.

## Key Constraints

- Keep v2 small. Prefer upstream defaults, and don't copy settings that match them.
- Never commit secrets, private keys or host details. Resolve secrets at runtime with `op`.
- Do not modify the user name or email in `home/dot_gitconfig.tmpl`.
- New configs must use TokyoNight Night where applicable.
