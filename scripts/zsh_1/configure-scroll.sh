#!/usr/bin/env zsh

# Scroll Direction Configuration Script
# This script configures the scroll direction to be reversed (natural scrolling disabled)

set -e  # Exit on any error

echo "⚙️  Configuring Scroll Direction"
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

# Configure scroll direction
info "Configuring scroll direction..."
defaults write -g com.apple.swipescrolldirection -bool false

echo ""
echo "🎉 Scroll direction configuration complete!" 