# Agent Instructions

## Overview

Minimal dotfiles repo for macOS (primary) and Linux. Uses GNU Stow for symlink management. Everything uses the **TokyoNight Night** color scheme.

## Stow Convention

Each top-level directory is a stow package that mirrors `$HOME`. Paths must follow this structure:

```
tool/.config/tool/config-file
```

For example, `fish/.config/fish/config.fish` symlinks to `~/.config/fish/config.fish`. Git is an exception — it uses `git/.gitconfig` (maps to `~/.gitconfig`).

## Adding a New Tool

When adding a new tool config, you must:

1. Create the stow directory with the correct path structure (see above)
2. Add the `stow -v -t "$HOME" toolname` line in `install.sh`
3. Add the package to the brew install line (macOS) AND the apt/dnf/pacman install lines (Linux) in `install.sh`

## Key Constraints

- Do not modify `git/.gitconfig` user name/email — those are personal
- New configs must use TokyoNight Night theme where applicable
- macOS is the primary target; Linux support uses apt, dnf, and pacman
- Stow packages are flat — one top-level directory per tool, no nesting
