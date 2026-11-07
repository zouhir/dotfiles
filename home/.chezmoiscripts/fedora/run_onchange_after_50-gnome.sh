#!/bin/bash
set -euo pipefail

dconf load / <<'DCONF'
[org/gnome/desktop/interface]
color-scheme='prefer-dark'

[org/gnome/desktop/peripherals/keyboard]
delay=uint32 225
repeat-interval=uint32 30

[org/gnome/desktop/session]
idle-delay=uint32 600

[org/gnome/settings-daemon/plugins/power]
sleep-inactive-ac-type='nothing'
sleep-inactive-battery-type='nothing'

[org/gnome/mutter]
dynamic-workspaces=false
edge-tiling=true

[org/gnome/desktop/wm/preferences]
num-workspaces=9

[org/gnome/mutter/keybindings]
toggle-tiled-left=['<Control><Alt>Left']
toggle-tiled-right=['<Control><Alt>Right']

[org/gnome/desktop/wm/keybindings]
toggle-maximized=['<Control><Alt>Return']
move-to-monitor-left=['<Control><Alt><Super>Left']
move-to-monitor-right=['<Control><Alt><Super>Right']
switch-to-workspace-left=['<Super>Page_Up']
switch-to-workspace-right=['<Super>Page_Down']
switch-to-workspace-1=['<Super>1']
switch-to-workspace-2=['<Super>2']
switch-to-workspace-3=['<Super>3']
switch-to-workspace-4=['<Super>4']
switch-to-workspace-5=['<Super>5']
switch-to-workspace-6=['<Super>6']
switch-to-workspace-7=['<Super>7']
switch-to-workspace-8=['<Super>8']
switch-to-workspace-9=['<Super>9']

[org/gnome/shell/keybindings]
switch-to-application-1=@as []
switch-to-application-2=@as []
switch-to-application-3=@as []
switch-to-application-4=@as []
switch-to-application-5=@as []
switch-to-application-6=@as []
switch-to-application-7=@as []
switch-to-application-8=@as []
switch-to-application-9=@as []
DCONF
