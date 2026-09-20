# Agent Instructions

## Overview

Minimal dotfiles repo for macOS (primary) and Linux. Uses GNU Stow for symlink management. Everything uses the **TokyoNight Night** color scheme. **No Homebrew** — on macOS, CLI tools are installed from upstream release binaries / official scripts; on Linux, via apt/dnf/pacman.

## Layout

- `install.sh` — one-shot provisioning for a new machine
- `update.sh` — pull, re-stow, and upgrade every managed tool (`dotup` in fish)
- `lib.sh` — shared helpers, sourced by both; all install logic lives here
- `macos-defaults.sh` — macOS system preferences

## Stow Convention

Each top-level directory is a stow package that mirrors `$HOME`. Paths must follow this structure:

```
tool/.config/tool/config-file
```

For example, `fish/.config/fish/config.fish` symlinks to `~/.config/fish/config.fish`. Exceptions:

- Git: `git/.gitconfig` (maps to `~/.gitconfig`)
- SSH: `ssh/.ssh/config` (maps to `~/.ssh/config`)
- Codex: `codex/.codex/config.toml` is **copied**, not symlinked — the Codex CLI rewrites its own config, so `seed_codex_config` only installs it when `~/.codex/config.toml` is absent. Not a stow package.

## Adding a New Tool

When adding a new tool config, you must:

1. Create the stow directory with the correct path structure (see above)
2. Add the package name to the `STOW_PACKAGES` array in `lib.sh` (install.sh and update.sh both iterate it)
3. Add the tool to the package installers in `lib.sh`:
   - **macOS** (`install_macos_tools`): add a `fetch_gh <bin> <owner/repo> <asset-regex>` line for a tool with a prebuilt release binary, or a dedicated `install_<tool>` function for script/source installs
   - **Linux** (`install_linux_tools`): add it to the apt/dnf/pacman install lines, or `fetch_gh` it when the distros don't package it
4. If the config can collide with a real file on a fresh machine, add it to `CONFIG_TARGETS` / `HOME_TARGETS` in `install.sh` so it gets backed up

`fetch_gh` and the `install_<tool>` functions honour `UPGRADE=1` (set by `update.sh`): they re-resolve the latest release and compare it against the tag recorded in `~/.local/share/dotfiles/versions`. Anything new must go through them so it stays updatable, and must leave tools living outside `~/.local/bin` alone (see `dotfiles_owns`).

## Key Constraints

- Do not modify `git/.gitconfig` user name/email — those are personal
- SSH work-specific configurations MUST be placed in `~/.ssh/config.local` (this file is excluded from the repository)
- New configs must use TokyoNight Night theme where applicable
- macOS is the primary target; Linux support uses apt, dnf, and pacman
- Stow packages are flat — one top-level directory per tool, no nesting
- `iterm2/.config/iterm2/prefs/` is iTerm2's live prefs folder: iTerm2 writes `com.googlecode.iterm2.plist` back to it. Keep it XML (`plutil -convert xml1`) so diffs stay readable, and never hand-edit it while iTerm2 is running. It must stay a subdirectory — iTerm2 owns `~/.config/iterm2` itself (live socket, app-support symlinks), so that path must never be stowed over or backed up.
