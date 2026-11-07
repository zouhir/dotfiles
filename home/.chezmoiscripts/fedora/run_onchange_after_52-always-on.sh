#!/bin/bash
set -euo pipefail

# Resume is unreliable on this hardware and the box should stay reachable.
# Masking also covers the login screen, which has its own suspend timer.
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
