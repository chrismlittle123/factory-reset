#!/usr/bin/env zsh

# Development Tools Installation Script
# This script installs development tools and global packages

set -e  # Exit on any error

echo "🛠️  Development Tools Installation"
echo "This script installs development tools and global packages"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

info() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Ensure Node.js is available
if ! command -v node &> /dev/null; then
    error "Node.js not found. Please run ./scripts/zsh/install-apps.sh first"
    exit 1
fi

info "Step 1: Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

info "Step 2: Installing UV..."
brew install uv

info "Step 3: Installing GitHub CLI..."
brew install gh

log "Development tools installation completed!"
