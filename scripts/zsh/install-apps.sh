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
    error "Homebrew not found. Please run ./scripts/bash/install-foundation.sh first"
    exit 1
fi

info "Step 1: Installing Google Chrome..."
brew install --cask google-chrome

info "Step 2: Installing 1Password..."
brew install --cask 1password

info "Step 3: Installing Claude..."
brew install --cask claude

info "Step 4: Installing Node.js..."
brew install node

info "Step 5: Installing Docker (via Colima)..."
brew install colima docker docker-compose
log "Starting Colima VM..."
colima start

info "Step 6: Installing AWS CLI..."
brew install awscli

info "Step 7: Installing Google Cloud CLI..."
brew install --cask google-cloud-sdk

info "Step 8: Installing VS Code..."
brew install --cask visual-studio-code

info "Step 9: Installing Sublime Text..."
brew install --cask sublime-text

info "Step 10: Installing Slack..."
brew install --cask slack

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
    gcloud
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
log "Application installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Configure AWS CLI with: aws configure"
echo "  3. Configure GCloud CLI with: gcloud init"
echo "  4. Sign into 1Password, Chrome, and Slack"
echo "  5. Enable dark mode in cloud consoles:"
echo "     - AWS: Click gear icon (⚙) → Visual mode → Dark"
echo "     - GCP: Settings → Preferences → Appearance → Dark"
echo ""
echo "Docker (Colima) commands:"
echo "  colima start    # Start Docker VM"
echo "  colima stop     # Stop Docker VM"
echo "  docker ps       # Works as normal"
