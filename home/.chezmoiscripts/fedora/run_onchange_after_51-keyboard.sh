#!/bin/bash
set -euo pipefail

# Matches the Mac: Super acts as Cmd, so Cmd+T/W/L/1-9 reach apps as the Ctrl
# shortcuts Linux expects. Cmd+C/V/X use Insert keys so terminals stay safe.
# Tapping Super alone still opens the app launcher.
sudo mkdir -p /etc/keyd
sudo tee /etc/keyd/default.conf >/dev/null <<'KEYD'
[ids]
*

[main]
leftmeta = overload(cmd, leftmeta)

[cmd:C]
c = C-insert
v = S-insert
x = S-delete
left = home
right = end
up = C-home
down = C-end
space = leftmeta
tab = swapm(app_switch, M-tab)
` = M-`
pageup = M-pageup
pagedown = M-pagedown

# Holds Super while Cmd is down, so the switcher stays open across Tab presses.
[app_switch:M]
tab = M-tab

# Ctrl+Alt+Cmd+arrows still move windows between monitors.
[control+alt+cmd]
left = C-A-M-left
right = C-A-M-right

[control]
1 = M-1
2 = M-2
3 = M-3
4 = M-4
5 = M-5
6 = M-6
7 = M-7
8 = M-8
9 = M-9
KEYD
sudo systemctl enable --now keyd
sudo keyd reload
