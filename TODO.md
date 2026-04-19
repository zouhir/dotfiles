# Dotfiles TODO

## SSH hardening

- [x] **Scope `ForwardAgent`.** Default `no` on `Host *`; enabled only for `github.com` and `yoyo`.
- [ ] **Mosh.** Add `brew "mosh"` for UDP / roaming-survivable remote shells. Useful on flaky connections or when suspending the laptop mid-session.

## Tmux

- [ ] **Session persistence.** tmux-resurrect + tmux-continuum (or a lighter alternative) so remote sessions restore after reboot. Auto-save every 15 min; auto-restore on tmux start.
- [ ] **Prune unused fish functions.** `fp.fish`, `fr.fish` — orphans from the old session-space binds. (`fs.fish` is kept: powers `prefix + s`.) Remove once confirmed unused elsewhere.

## Modern CLI upgrades

- [ ] **Brewfile additions.** `atuin` (SQL shell history — **local-only on work machines** to comply with data-egress policy; sync only on personal), `mise` (unified Node/Python/Go/Rust version manager; replaces fnm), `eza` (modern ls), `gh` (GitHub CLI). All improve SSH portability and day-to-day ergonomics.
