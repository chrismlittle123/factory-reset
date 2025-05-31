#!/bin/bash

# Foundation Installation Script - Run this in default macOS Terminal
# This script installs the basic tools needed before switching to iTerm2 + oh-my-zsh

set -e  # Exit on any error

echo "🏗️  Foundation Setup - Run in default macOS Terminal"
echo "This script installs the basic tools needed before using iTerm2 + oh-my-zsh"
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

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This script is designed for macOS only."
    exit 1
fi

info "Step 1: Installing Homebrew..."
if ! command -v brew &> /dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    else
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    fi
else
    log "Homebrew already installed"
fi

info "Step 2: Installing git..."
brew install git

info "Step 3: Installing iTerm2..."
brew install --cask iterm2

info "Step 4: Installing oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    log "oh-my-zsh already installed"
fi

info "Step 5: Setting up initial zsh configuration..."
# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    log "Backed up existing .zshrc"
fi

# Copy our custom .zshrc
if [ -f "files/.zshrc" ]; then
    cp "files/.zshrc" "$HOME/.zshrc"
    log "Applied custom .zshrc configuration"
else
    warn "files/.zshrc not found - you'll need to configure zsh manually"
fi

echo ""
echo "🎉 Foundation setup complete!"
echo ""