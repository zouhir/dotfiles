#!/bin/bash
set -euo pipefail

# Claude Code keeps itself updated after this.
export PATH="$HOME/.local/bin:$PATH"
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash
