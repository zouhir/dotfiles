#!/bin/bash
set -euo pipefail

# Let the iGPU map all but 8 GiB of RAM for local models. AMD defaults to half.
# Needs a reboot. Skipped on anything but the Framework Desktop.
grep -qi framework /sys/class/dmi/id/sys_vendor 2>/dev/null || exit 0
grep -qi desktop /sys/class/dmi/id/product_name 2>/dev/null || exit 0

ram_kib="$(awk '/MemTotal/ {print $2}' /proc/meminfo)"
pages=$(((ram_kib - 8 * 1024 * 1024) / 4))
echo "options ttm pages_limit=$pages" | sudo tee /etc/modprobe.d/ttm.conf >/dev/null
sudo dracut -f
