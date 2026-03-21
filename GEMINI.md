# Agent Instructions

## Overview

Minimal dotfiles repo for macOS (primary) and Linux. Uses GNU Stow for symlink management. Everything uses the **TokyoNight Night** color scheme.

## Stow Convention

Each top-level directory is a stow package that mirrors `$HOME`. Paths must follow this structure:

```
tool/.config/tool/config-file
```

For example, `fish/.config/fish/config.fish` symlinks to `~/.config/fish/config.fish`. Git and SSH are exceptions:
- Git: `git/.gitconfig` (maps to `~/.gitconfig`)
- SSH: `ssh/.ssh/config` (maps to `~/.ssh/config`)

## Adding a New Tool

When adding a new tool config, you must:

1. Create the stow directory with the correct path structure (see above)
2. Add the `stow -v -t "$HOME" toolname` line in `install.sh`
3. Add the package to the brew install line (macOS) AND the apt/dnf/pacman install lines (Linux) in `install.sh`

## Key Constraints

- Do not modify `git/.gitconfig` user name/email — those are personal
- SSH work-specific configurations MUST be placed in `~/.ssh/config.local` (this file is excluded from the repository)
- New configs must use TokyoNight Night theme where applicable
- macOS is the primary target; Linux support uses apt, dnf, and pacman
- Stow packages are flat — one top-level directory per tool, no nesting
