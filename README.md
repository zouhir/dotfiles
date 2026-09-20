# dotfiles

Minimal dotfiles for macOS (and Linux) — fish shell, Neovim, Git, and terminal tools.

## What's included

- **fish** — Shell config, abbreviations, and fuzzy project switcher functions
- **nvim** — Neovim config ([LazyVim](https://www.lazyvim.org/)) with TypeScript, Rust, HTML/CSS support
- **git** — Git config with [delta](https://github.com/dandavison/delta) for diffs
- **iterm2** — [iTerm2](https://iterm2.com/) settings (TokyoNight Night, JetBrainsMono Nerd Font)
- **lazygit** — [Lazygit](https://github.com/jesseduffield/lazygit) config
- **starship** — [Starship](https://starship.rs/) prompt
- **tmux** — Terminal multiplexer config
- **codex** — Seed config for the [Codex CLI](https://github.com/openai/codex)

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
  gh, jq, zoxide, direnv, starship, fnm, go, stow, **codex**) — no Homebrew on macOS
- Install JetBrainsMono Nerd Font and iTerm2, and point iTerm2 at the config in this repo
- Set fish as the default shell
- Symlink configs using GNU Stow
- Install Node.js LTS via [fnm](https://github.com/Schniz/fnm)

> **Tip:** export a `GITHUB_TOKEN` before running on macOS to avoid GitHub's
> unauthenticated API rate limit while resolving release downloads.

## Staying up to date

Without Homebrew there's no `brew upgrade`, so the repo brings its own:

```bash
dotup             # fish function, available after install
bash update.sh    # same thing, from anywhere
```

`update.sh` pulls this repo, re-runs `stow`, then re-resolves every managed tool
against its newest upstream release. It records the release tag of each tool it
installs in `~/.local/share/dotfiles/versions`, so a tool already on the latest
tag is skipped without downloading anything. It also refreshes Node LTS, syncs
Neovim plugins, and updates Claude Code if it's installed.

A tool that lives outside `~/.local/bin` (a distro package, or a leftover
Homebrew install) is reported and left alone rather than shadowed.

```bash
./update.sh --no-pull    # skip `git pull`
./update.sh --links      # only re-stow the symlinks
./update.sh --tools      # only refresh the installed tools
```

iTerm2 and the Claude desktop app keep themselves updated; everything else in
the GUI list below is manual.

## iTerm2

`iterm2/.config/iterm2/prefs/` is stowed to `~/.config/iterm2/prefs`, and
`install.sh` points iTerm2's *Load settings from a custom folder* at it:

```bash
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.config/iterm2/prefs"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
```

It has to be the `prefs/` subdirectory: iTerm2 itself owns `~/.config/iterm2`,
where it keeps a live socket and symlinks into its app support directory. That
directory is left alone; only `prefs` is added next to iTerm2's own entries.

Because `prefs` is a symlink into this repo, **anything you change in iTerm2's
settings UI is saved straight back here** and shows up in `git diff` — commit it
or throw it away with `git checkout iterm2`. `update.sh` re-serialises the plist
as XML afterwards so the diffs stay readable.

The profile is TokyoNight Night at JetBrainsMono Nerd Font 14, bar cursor, 10k
lines of scrollback, minimal tab bar, copy-on-select. Left Option sends `Esc+`
(word motions and Alt bindings); right Option stays Normal so `#`, `~` and
friends still type on non-US layouts.

One caveat: if iTerm2 is **running** the first time you run `install.sh`, it
still holds its old settings and may write them over the repo copy when it
quits. Quit iTerm2, reopen it, and `git checkout iterm2` if it clobbered
anything. `TokyoNightNight.itermcolors` sits next to the plist if you ever want
to import just the colors into another profile.

## Codex

The `codex` binary is installed from [openai/codex](https://github.com/openai/codex)
releases like any other tool, and `dotup` keeps it current.

Its config is the one exception to the symlink rule: Codex rewrites
`~/.codex/config.toml` itself (model picks, plugins, MCP servers), so
`codex/.codex/config.toml` is **copied** into place by `install.sh` only when
there's nothing there yet. Existing configs are never touched.

## Applications (GUI)

Installed by the script: **iTerm2** and **JetBrainsMono Nerd Font**. The rest are manual:

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
stow -v -t $HOME fish git ssh iterm2 lazygit starship nvim tmux
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
├── update.sh           # Pull, re-stow, and upgrade every managed tool
├── lib.sh              # Shared install/upgrade helpers
├── macos-defaults.sh   # macOS system preferences
├── fish/               # Fish shell config
│   └── .config/fish/
│       ├── config.fish # Main config, abbreviations
│       ├── functions/  # dotup (updater), fs (session switcher), t (tmux helper)
│       └── conf.d/     # fzf, rustup
├── git/                # Git config + global gitignore
├── iterm2/             # iTerm2 settings + TokyoNight color preset (prefs/)
├── codex/              # Codex CLI seed config (copied, not symlinked)
├── lazygit/            # Lazygit config
├── starship/           # Starship prompt config
├── tmux/               # Tmux config
└── nvim/               # Neovim config (LazyVim)
```

## License

MIT
