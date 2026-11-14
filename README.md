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

On the Mac, Rectangle Pro handles window snapping with its default shortcuts. Fedora runs KDE Plasma with its own defaults.

## Keyboard

On Fedora, [keyd](https://github.com/rvaiya/keyd) makes Super behave like Cmd: `Cmd+<key>` reaches apps as `Ctrl+<key>`, and Ctrl stays Ctrl for the terminal. `Cmd+C`/`V`, `Cmd+←`/`→` and `Cmd+Space` work as on the Mac, and tapping Super alone still opens the app launcher.

## License

MIT
