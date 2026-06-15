# dotfiles

Minimal dotfiles for macOS (and Linux) — fish shell, Neovim, Git, and terminal tools.

## What's included

- **fish** — Shell config, abbreviations, and fuzzy project switcher functions
- **nvim** — Neovim config ([LazyVim](https://www.lazyvim.org/)) with TypeScript, Rust, HTML/CSS support
- **git** — Git config with [delta](https://github.com/dandavison/delta) for diffs
- **ghostty** — [Ghostty](https://ghostty.org/) terminal config
- **lazygit** — [Lazygit](https://github.com/jesseduffield/lazygit) config
- **starship** — [Starship](https://starship.rs/) prompt
- **tmux** — Terminal multiplexer config

Everything uses the **TokyoNight Night** color scheme.

## Fresh Mac Setup

On a brand-new Mac with nothing installed:

```bash
# Install Xcode Command Line Tools (gives you git, make, and a compiler)
xcode-select --install

# Clone and run the install script
git clone https://github.com/zouhir/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles && bash install.sh
```

**No Homebrew required.** On macOS the install script pulls each CLI tool
directly from upstream — prebuilt release binaries into `~/.local/bin`, the Go
toolchain into `~/.local/go`, fish via its signed `.pkg`, and [GNU Stow](https://www.gnu.org/software/stow/)
built from source. On Linux it uses the native package manager (apt/dnf/pacman).

The install script will:
- Install CLI tools (fish, neovim, tmux, fzf, fd, ripgrep, bat, delta, lazygit,
  gh, jq, zoxide, direnv, starship, fnm, go, stow) — no Homebrew on macOS
- Set fish as the default shell
- Symlink configs using GNU Stow
- Install Node.js LTS via [fnm](https://github.com/Schniz/fnm)

> **Tip:** export a `GITHUB_TOKEN` before running on macOS to avoid GitHub's
> unauthenticated API rate limit while resolving release downloads.

## Applications (GUI)

GUI apps are not installed by the script — grab them manually:

- [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads)
- [Ghostty](https://ghostty.org/) — terminal
- [Visual Studio Code](https://code.visualstudio.com/)
- [Claude](https://claude.ai/download) — desktop app
- [1Password](https://1password.com/downloads/mac) + [1Password CLI](https://developer.1password.com/docs/cli/get-started/)
- [Google Chrome](https://www.google.com/chrome/) · [Firefox](https://www.mozilla.org/firefox/)
- [Rectangle Pro](https://rectangleapp.com/pro) — window management
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Spotify](https://www.spotify.com/download/)

## Manual setup

If you prefer not to use the install script (tools already installed):

```bash
stow -v -t $HOME fish git ssh ghostty lazygit starship nvim tmux
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
│   └── .config/fish/
│       ├── config.fish # Main config, abbreviations
│       ├── functions/  # fs (session switcher), t (tmux project helper)
│       └── conf.d/     # fzf, rustup
├── git/                # Git config + global gitignore
├── ghostty/            # Ghostty terminal config
├── lazygit/            # Lazygit config
├── starship/           # Starship prompt config
├── tmux/               # Tmux config
└── nvim/               # Neovim config (LazyVim)
```

## License

MIT
