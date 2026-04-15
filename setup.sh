#!/usr/bin/env bash
# Setup script for installing MCP servers used by this project:
#   - UniFi Network MCP   (PyPI: unifi-network-mcp, requires Python >= 3.13)
#   - SonicWall MCP       (GitHub: gensecaihq/Sonicwall-MCP-Server, Node/TS, SSE transport)
#   - Synology MCP        (GitHub: atom2ueki/mcp-server-synology, Python stdio)
#
# Usage: ./setup.sh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENDOR_DIR="${ROOT_DIR}/vendor"
mkdir -p "${VENDOR_DIR}"

echo "==> Installing uv (Python package manager)"
pip install uv

echo "==> Installing UniFi Network MCP from PyPI (isolated, Python 3.13)"
# unifi-network-mcp requires aiounifi>=83 which requires Python >= 3.13.
# Use uv tool install to get an isolated venv on the correct interpreter.
uv tool install --python 3.13 unifi-network-mcp

echo "==> Installing SonicWall MCP server"
if [ ! -d "${VENDOR_DIR}/sonicwall-mcp-server" ]; then
  git clone https://github.com/gensecaihq/Sonicwall-MCP-Server.git \
    "${VENDOR_DIR}/sonicwall-mcp-server"
fi
(
  cd "${VENDOR_DIR}/sonicwall-mcp-server"
  npm install
  npx tsc
)

echo "==> Installing Synology MCP server"
if [ ! -d "${VENDOR_DIR}/mcp-server-synology" ]; then
  git clone https://github.com/atom2ueki/mcp-server-synology.git \
    "${VENDOR_DIR}/mcp-server-synology"
fi
(
  cd "${VENDOR_DIR}/mcp-server-synology"
  # --ignore-installed avoids conflicts with system-managed PyJWT on Debian.
  pip install --ignore-installed -r requirements.txt
)

cat <<'EOF'
==> Done.

Next steps:
  1. Fill in credentials in .mcp.json (or set them in your shell env before
     launching Claude Code).
  2. The SonicWall MCP uses SSE transport and must be started separately,
     e.g. from vendor/sonicwall-mcp-server:
         SONICWALL_HOST=... SONICWALL_USERNAME=... SONICWALL_PASSWORD=... \
         node dist/server-mcp-compliant.js
     or via docker:  docker compose up -d
  3. UniFi and Synology MCP servers are launched on demand by Claude Code
     using the stdio commands configured in .mcp.json.
EOF
