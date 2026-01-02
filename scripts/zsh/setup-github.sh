#!/bin/zsh

# GitHub Setup Script
# This script configures git, generates SSH keys, and authenticates with GitHub

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

info() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Ensure GitHub CLI is available
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found. Please run ./scripts/zsh/install-dev-tools.sh first"
    exit 1
fi

info "Step 1: Setting Git global configuration..."
git config --global user.name "Christopher Little"
git config --global user.email "christopher.little.personal@gmail.com"

info "Step 2: Generating SSH key..."
# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_ed25519 ]; then
    log "Generating new SSH key..."
    ssh-keygen -t ed25519 -C "christopher.little.personal@gmail.com" -f ~/.ssh/id_ed25519 -N ""
else
    log "SSH key already exists"
fi

info "Step 3: Starting ssh-agent and adding key..."
# Start ssh-agent in the background
eval "$(ssh-agent -s)"

# Add SSH key to ssh-agent
ssh-add ~/.ssh/id_ed25519

info "Step 4: Authenticating with GitHub CLI..."
# Authenticate with GitHub (will open browser for OAuth)
gh auth login --web --git-protocol ssh

info "Step 5: Uploading SSH key to GitHub..."
# Upload SSH key to GitHub account
gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname) - $(date +%Y-%m-%d)"

info "Step 6: Configuring git credential helper..."
# Configure git to use gh as credential helper
gh auth setup-git

log "GitHub setup complete!"
echo ""
echo "You can verify the setup by running: gh auth status"
