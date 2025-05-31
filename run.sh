#!/bin/bash

# Factory Reset - Complete Setup Script
# Run this in default macOS Terminal to set up everything

echo "🚀 Factory Reset - Complete Mac Setup"
echo "This script will install and configure all your development tools in one go"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[✓]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
}

info() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This script is designed for macOS only."
    exit 1
fi

# ============================================================================
# PHASE 1: FOUNDATION
# ============================================================================

info "Phase 1: Installing Foundation Tools"
echo "Installing Homebrew, git, iTerm2, oh-my-zsh, and pyenv..."
echo ""

if [ -f "./scripts/bash_terminal/install-foundation.sh" ]; then
    chmod +x ./scripts/bash_terminal/install-foundation.sh
    ./scripts/bash_terminal/install-foundation.sh
    if [ $? -ne 0 ]; then
        error "Foundation installation failed. Exiting."
        exit 1
    fi
else
    error "install-foundation.sh not found!"
    exit 1
fi

echo ""
echo "============================================================================"

# ============================================================================
# PHASE 2: VERIFICATION
# ============================================================================

info "Phase 2: Verifying Foundation Setup"
echo "Checking that all foundation tools are properly installed..."
echo ""

if [ -f "./scripts/bash_terminal/verify-foundation.sh" ]; then
    chmod +x ./scripts/bash_terminal/verify-foundation.sh
    ./scripts/bash_terminal/verify-foundation.sh
    if [ $? -ne 0 ]; then
        error "Foundation verification failed. Please fix the issues and try again."
        exit 1
    fi
else
    error "verify-foundation.sh not found!"
    exit 1
fi

echo ""
echo "============================================================================"

# ============================================================================
# PHASE 3: APPLICATIONS
# ============================================================================

info "Phase 3: Installing Applications"
echo "Installing development tools, applications, and configurations..."
echo ""

if [ -f "./scripts/bash_terminal/install-apps.sh" ]; then
    chmod +x ./scripts/bash_terminal/install-apps.sh
    ./scripts/bash_terminal/install-apps.sh
    if [ $? -ne 0 ]; then
        error "Application installation failed."
        exit 1
    fi
else
    error "install-apps.sh not found!"
    exit 1
fi

echo ""
echo "============================================================================"

# ============================================================================
# COMPLETION
# ============================================================================

echo ""
echo "🎉 Factory Reset Complete!"
echo ""
log "All phases completed successfully:"
log "✓ Foundation tools installed and verified"
log "✓ Applications and development tools installed"
echo ""
info "Your Mac is now set up for development!"
echo ""
warn "IMPORTANT: You may need to restart your terminal or iTerm2 to use all new tools."
warn "Some applications may require additional manual setup."
echo ""
log "Happy coding! 🚀"
