#!/usr/bin/env zsh

# Claude Code Plugins Installation Script
# Wires up the Claude Code plugins and MCP servers we want on every machine.
# Run AFTER install-dev-tools.sh (which installs the claude-code CLI itself).

set -e

echo "🧩 Claude Code Plugins"
echo "Configuring marketplaces, plugins, and MCP servers"
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()   { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info()  { echo -e "${BLUE}[STEP]${NC} $1"; }

# Preconditions
if ! command -v claude &> /dev/null; then
    error "claude CLI not found. Run ./scripts/zsh/install-dev-tools.sh first."
    exit 1
fi

if ! command -v npx &> /dev/null; then
    error "npx not found (Node.js missing). Run ./scripts/zsh/install-apps.sh first."
    exit 1
fi

# --- context7 ---
# Upstash's library-docs MCP server. Distributed as an npm package, not a Claude
# Code marketplace plugin — so we register it via `claude mcp add`.
info "Step 1: Registering context7 MCP server..."
claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp || warn "context7 MCP server already registered"

log "Claude Code plugins installed."
log "Open a new Claude Code session (or run /reload-plugins in an existing one) to pick them up."
