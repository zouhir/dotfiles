# work-example — private dotfiles repo template

Starter layout for a **second, private** dotfiles repo that lives alongside the public one on a work machine. Host it on your employer's internal git (not public GitHub — per the data-egress policy).

## Setup on the work laptop

```sh
# 1. Clone both repos as siblings
git clone git@github.com:zouhir/dotfiles.git      ~/Projects/dotfiles
git clone <internal-git>/dotfiles-work.git        ~/Projects/dotfiles-work

# 2. Stow the public one first, then the work one (work layers on top)
cd ~/Projects/dotfiles       && stow -t "$HOME" fish ssh git   # etc.
cd ~/Projects/dotfiles-work  && stow -t "$HOME" fish ssh git
```

The work repo NEVER overwrites files owned by the public repo — it only writes to drop-in paths that the public configs already source.

## What goes where

| Public repo owns | Work repo drops into |
|---|---|
| `~/.config/fish/config.fish` | `~/.config/fish/conf.d/work.fish` (auto-sourced) |
| `~/.config/fish/functions/*.fish` (non-colliding names) | `~/.config/fish/functions/work_*.fish` |
| `~/.ssh/config` | `~/.ssh/config.d/work` (via `Include config.d/*`) |
| `~/.gitconfig` | `~/.config/git/work.conf` (via `includeIf gitdir:~/work/`) |

## Committing without cross-contamination

You are always `cd`'d inside exactly one repo. `git status` only sees that repo's tree, so there is no way to accidentally stage work files into the public repo.

A belt-and-braces habit: `git remote -v` before `git push` on anything touching work config. The remote URL makes it obvious which repo you're pushing to.

## Triggers and conventions assumed by the public repo

- **Git**: `includeIf "gitdir:~/work/"` fires when the repo you're in lives under `~/work/`. Keep work clones there.
- **SSH**: `Include config.d/*` — any filename works, but prefer one file per logical group (`work-bastion`, `work-k8s`, etc.) so removal is easy.
- **Fish**: `conf.d/*.fish` is auto-sourced in lexical order; `functions/*.fish` is lazy-loaded by function name.

## Files in this template

See the adjacent `fish/`, `ssh/`, `git/` directories for starter content. Copy the whole `work-example/` tree into your new private repo, rename it, and edit.
