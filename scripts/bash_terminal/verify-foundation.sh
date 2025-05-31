#!/bin/bash

# Foundation Verification Script
# Run this in iTerm2 to verify the foundation setup worked correctly

echo "🔍 Verifying Foundation Setup"
echo "This script checks that Homebrew, git, iTerm2, and oh-my-zsh are properly installed"
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
    echo -e "${BLUE}[INFO]${NC} $1"
}

ERRORS=0

# Check if running in iTerm2
info "Checking terminal environment..."
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    log "Running in iTerm2 ✓"
else
    warn "Not running in iTerm2 (detected: $TERM_PROGRAM)"
fi

# Check if zsh is the current shell
if [[ "$SHELL" == */zsh ]]; then
    log "Using zsh shell ✓"
else
    error "Not using zsh shell (current: $SHELL)"
    ((ERRORS++))
fi

# Check Homebrew
info "Checking Homebrew..."
if command -v brew &> /dev/null; then
    BREW_VERSION=$(brew --version | head -n1)
    log "Homebrew installed: $BREW_VERSION"
else
    error "Homebrew not found in PATH"
    ((ERRORS++))
fi

# Check git
info "Checking git..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    log "Git installed: $GIT_VERSION"
else
    error "Git not found"
    ((ERRORS++))
fi

# Check oh-my-zsh
info "Checking oh-my-zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Oh-my-zsh directory exists ✓"
    if [ -n "$ZSH" ]; then
        log "ZSH environment variable set: $ZSH"
    else
        warn "ZSH environment variable not set"
    fi
else
    error "Oh-my-zsh not found"
    ((ERRORS++))
fi

# Check .zshrc
info "Checking .zshrc configuration..."
if [ -f "$HOME/.zshrc" ]; then
    log ".zshrc file exists ✓"
    if grep -q "oh-my-zsh" "$HOME/.zshrc"; then
        log ".zshrc contains oh-my-zsh configuration ✓"
    else
        warn ".zshrc doesn't seem to have oh-my-zsh configuration"
    fi
    if grep -q "PYENV_ROOT" "$HOME/.zshrc"; then
        log ".zshrc contains pyenv configuration ✓"
    else
        warn ".zshrc doesn't contain pyenv configuration"
    fi
else
    error ".zshrc file not found"
    ((ERRORS++))
fi

# Check if iTerm2 is installed
info "Checking iTerm2 installation..."
if [ -d "/Applications/iTerm.app" ]; then
    log "iTerm2 application found ✓"
else
    warn "iTerm2 application not found in /Applications/"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "🎉 Foundation verification complete - All checks passed!"
    echo ""
    info "You're ready to proceed with application installation!"
    log "Next step: Run ./scripts/zsh_terminal/install-apps.sh"
else
    echo "❌ Foundation verification failed with $ERRORS error(s)"
    echo ""
    error "Please fix the errors above before proceeding"
    info "You may need to re-run: ./scripts/bash_terminal/install-foundation.sh"
    exit 1
fi 