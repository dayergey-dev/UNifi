#!/usr/bin/env bash
# Setup script for installing MCP servers used by this project:
#   - UniFi Network MCP   (PyPI: unifi-network-mcp)
#   - SonicWall MCP       (GitHub: gensecai/sonicwall-mcp-server)
#   - Synology MCP        (GitHub: atom2ueki/mcp-server-synology)
#
# Usage: ./setup.sh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENDOR_DIR="${ROOT_DIR}/vendor"
mkdir -p "${VENDOR_DIR}"

echo "==> Installing uv (Python package manager)"
pip install uv

echo "==> Installing UniFi Network MCP from PyPI"
pip install unifi-network-mcp

echo "==> Installing SonicWall MCP server"
if [ ! -d "${VENDOR_DIR}/sonicwall-mcp-server" ]; then
  git clone https://github.com/gensecai/sonicwall-mcp-server.git "${VENDOR_DIR}/sonicwall-mcp-server"
fi
( cd "${VENDOR_DIR}/sonicwall-mcp-server" && npm install )

echo "==> Installing Synology MCP server"
if [ ! -d "${VENDOR_DIR}/mcp-server-synology" ]; then
  git clone https://github.com/atom2ueki/mcp-server-synology.git "${VENDOR_DIR}/mcp-server-synology"
fi
( cd "${VENDOR_DIR}/mcp-server-synology" && pip install -r requirements.txt )

echo "==> Done. MCP servers installed under ${VENDOR_DIR} and via pip."
