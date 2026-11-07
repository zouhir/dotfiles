#!/bin/bash
set -euo pipefail

# Matches the Mac: Ctrl+N switches workspace and Cmd+N reaches the app, where
# Linux browsers expect Ctrl+N. Cmd+C/V/X use Insert keys so terminals stay safe.
sudo mkdir -p /etc/keyd
sudo tee /etc/keyd/default.conf >/dev/null <<'KEYD'
[ids]
*

[meta]
c = C-insert
v = S-insert
x = S-delete
1 = C-1
2 = C-2
3 = C-3
4 = C-4
5 = C-5
6 = C-6
7 = C-7
8 = C-8
9 = C-9

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
