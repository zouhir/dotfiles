# dotfiles

Personal setup for a MacBook and a Fedora Workstation Framework Desktop, managed with [chezmoi](https://www.chezmoi.io/). Uses fish, Ghostty, Neovim (LazyVim), mise and 1Password, all in TokyoNight Night.

## Install

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply zouhir
```

This installs packages, tools and configs, then applies system settings. It asks for your password when needed, and Homebrew may ask to install the Xcode Command Line Tools.

## After sign-in

These steps can't be scripted:

1. Open 1Password and sign in.
2. In **Settings → Developer**, turn on the SSH agent and CLI integration.
3. Restore SSH host details:

   ```bash
   op read "op://Private/ssh-hosts/notesPlain" > ~/.ssh/config.local
   chmod 600 ~/.ssh/config.local
   ```

4. On macOS, create nine desktops in Mission Control so `Ctrl+1–9` works.
5. On Fedora, reboot so the GPU memory limit applies.

API keys stay in 1Password and load at runtime, for example:

```bash
op run --env-file=.env.op -- your-command
```

## Update

```bash
up
```

This pulls dotfiles, then upgrades OS packages, mise tools and Neovim plugins.

## Change something

| To change | Edit |
|---|---|
| CLI tools and runtimes | `home/dot_config/mise/config.toml` |
| GUI apps and OS packages | `home/.chezmoidata/packages.yaml` |
| macOS settings | `home/.chezmoiscripts/darwin/` |
| Fedora settings | `home/.chezmoiscripts/fedora/` |

Then run `chezmoi apply`. VS Code settings use its built-in Settings Sync.

## Window management

Fedora mirrors Rectangle Pro's default shortcuts where GNOME supports them natively.

| Action | Mac and Fedora |
|---|---|
| Left or right half | `Ctrl+Alt+←` / `→` |
| Maximize | `Ctrl+Alt+Return` |
| Next display | `Ctrl+Alt+Cmd+←` / `→` |
| Switch workspace | `Ctrl+1–9` |

Quarters and thirds need a GNOME extension and aren't installed by default. [Tactile](https://extensions.gnome.org/extension/4548/tactile/) supports current GNOME.

## License

MIT
