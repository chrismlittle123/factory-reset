#!/usr/bin/env zsh

# Application Installation Script - Run this in iTerm2 with oh-my-zsh
# This script installs all the applications and development tools

set -e  # Exit on any error

echo "📱 Application Installation - Run in iTerm2 with oh-my-zsh"
echo "This script installs all applications and development environments"
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


# Ensure Homebrew is available
if ! command -v brew &> /dev/null; then
    error "Homebrew not found. Please run ./scripts/bash_terminal/install-foundation.sh first"
    exit 1
fi

info "Step 1: Installing Google Chrome..."
brew install --cask google-chrome

info "Step 2: Installing 1Password..."
brew install --cask 1password

info "Step 4: Installing Node.js..."
brew install node

info "Step 5: Installing Docker..."
brew install --cask docker

info "Step 6: Installing AWS CLI..."
brew install awscli

info "Step 7: Installing Cursor..."
brew install --cask cursor

info "Step 8: Installing Sublime Text..."
brew install --cask sublime-text

info "Step 9: Installing TablePlus..."
brew install --cask tableplus

info "Step 10: Installing NordVPN..."
brew install --cask nordvpn


info "Step 11: Installing additional zsh plugins..."
# Install useful zsh plugins if they don't exist
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    log "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    log "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

info "Step 12: Updating .zshrc with plugins..."
# Add plugins to .zshrc if not already there
if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    log "Adding plugins to .zshrc..."
    # Create a temporary file with the updated plugins
    cat > /tmp/zsh_plugins << 'EOF'

# Plugins
plugins=(
    git
    brew
    macos
    node
    npm
    python
    docker
    aws
    zsh-autosuggestions
    zsh-syntax-highlighting
)
EOF
    
    # Insert plugins after ZSH_THEME line
    if grep -q "ZSH_THEME=" ~/.zshrc; then
        sed -i.bak '/ZSH_THEME=/r /tmp/zsh_plugins' ~/.zshrc
        rm /tmp/zsh_plugins
        log "Added plugins to .zshrc"
    fi
fi

echo ""
echo "🎉 Application installation complete!"
echo ""
warn "Manual steps still required:"
log "1. Install Cursor extensions (Python, TypeScript, Rainbow CSV)"
log "2. Configure AWS CLI: aws configure"
log "3. Set up GitHub SSH keys: ./scripts/zsh_terminal/setup-github.sh"
log "4. Set up folders and Finder: ./scripts/zsh_terminal/setup-folders.sh"
log "5. Add Google Calendars to Apple Calendars"
log "6. Import Chrome bookmarks from files/bookmarks.json"
echo ""
info "Restart your terminal or run 'source ~/.zshrc' to reload configuration" 