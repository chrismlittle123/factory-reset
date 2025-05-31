#!/usr/bin/env zsh

# Dock Configuration Script
# This script configures the macOS dock with specific applications in a specific order

set -e  # Exit on any error

echo "⚙️  Configuring Dock"
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

# Check for dockutil, install if missing
if ! command -v dockutil &> /dev/null; then
    info "dockutil not found. Installing via Homebrew..."
    brew install dockutil
fi

# Remove all non-default apps from the Dock
info "Removing all non-default apps from Dock..."
dockutil --remove all --no-restart

# List of apps to add (in order)
dock_apps=(
    "/System/Applications/System Settings.app"
    "/Applications/Google Chrome.app"
    "/Applications/Cursor.app"
    "/Applications/iTerm.app"
    "/Applications/Sublime Text.app"
    "/Applications/Docker.app"
    "/Applications/1Password.app"
    "/Applications/TablePlus.app"
    "/Applications/Numbers.app"
    "/Applications/NordVPN.app"
)

# Add each app if it exists
for app in "${dock_apps[@]}"; do
    if [ -e "$app" ]; then
        dockutil --add "$app" --no-restart
        log "Added to dock: $(basename "$app")"
    else
        warn "App not found: $app"
    fi
done

# Restart Dock to apply changes
killall Dock

echo ""
echo "🎉 Dock configuration complete!" 