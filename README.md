# dotfiles

Minimal dotfiles for macOS (and Linux) — fish shell, Neovim, Git, and terminal tools.

## What's included

- **fish** — Shell config, abbreviations, and fuzzy project switcher functions
- **nvim** — Neovim config ([LazyVim](https://www.lazyvim.org/)) with TypeScript, Rust, HTML/CSS support
- **git** — Git config with [delta](https://github.com/dandavella/delta) for diffs
- **ghostty** — [Ghostty](https://ghostty.org/) terminal config
- **lazygit** — [Lazygit](https://github.com/jesseduffield/lazygit) config
- **starship** — [Starship](https://starship.rs/) prompt

Everything uses the **TokyoNight Night** color scheme.

## Install

```bash
git clone https://github.com/zouhir/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh
```

The install script will:
- Install packages via Homebrew (macOS) or apt/dnf/pacman (Linux)
- Set fish as the default shell
- Symlink configs using [GNU Stow](https://www.gnu.org/software/stow/)
- Install Node.js LTS via [fnm](https://github.com/Schniz/fnm)

## Manual setup

If you prefer not to use the install script:

```bash
brew install fish go fnm stow
stow -v -t $HOME fish git ghostty lazygit starship nvim
fnm install --lts
```

## Personalization

After cloning, update `git/.gitconfig` with your own name and email:

```gitconfig
[user]
    name = your-name
    email = your-email@example.com
```

## Structure

```
dotfiles/
├── install.sh          # Bootstrap script
├── fish/               # Fish shell config
│   └── config.fish     # Main config, abbreviations
│   └── functions/      # fp, fr, fs, zd (project switcher)
│   └── conf.d/         # fzf, rustup
├── git/                # Git config + global gitignore
├── ghostty/            # Ghostty terminal config
├── lazygit/            # Lazygit config
├── starship/           # Starship prompt config
└── nvim/               # Neovim config (LazyVim)
```

## License

MIT
