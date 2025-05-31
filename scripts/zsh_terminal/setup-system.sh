#!/usr/bin/env zsh

# System Configuration Script
# This script automates various system settings and configurations

set -e  # Exit on any error

echo "⚙️  System Configuration"
echo "This script configures various system settings"
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

# Configure Dock
info "Configuring Dock..."
# Remove all apps from dock
defaults write com.apple.dock persistent-apps -array

# Add specific apps to dock
dock_apps=(
    "/System/Applications/Finder.app"
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

for app in "${dock_apps[@]}"; do
    if [ -e "$app" ]; then
        defaults write com.apple.dock persistent-apps -array-add "{\"tile-type\"=\"file-tile\";\"tile-data\"={\"file-data\"={\"_CFURLString\"=\"$app\";\"_CFURLStringType\"=0;}};}"
    else
        warn "App not found: $app"
    fi
done

# Configure scroll direction
info "Configuring scroll direction..."
defaults write -g com.apple.swipescrolldirection -bool false

# Import Chrome bookmarks
info "Importing Chrome bookmarks..."
if [ -f "files/bookmarks.html" ]; then
    # Create AppleScript to import bookmarks
    cat > /tmp/import_bookmarks.scpt << 'EOF'
tell application "Google Chrome"
    activate
    delay 1
    tell application "System Events"
        keystroke "o" using {command down}
        delay 1
        keystroke "files/bookmarks.html"
        delay 1
        keystroke return
    end tell
end tell
EOF
    osascript /tmp/import_bookmarks.scpt
    rm /tmp/import_bookmarks.scpt
else
    warn "bookmarks.html not found in files directory"
fi

# Restart Dock to apply changes
killall Dock

echo ""
echo "🎉 System configuration complete!"
echo ""
warn "Manual steps still required:"
log "1. Log into 1Password"
log "2. Set up iCloud for Desktop"
log "3. Install Numbers from Mac App Store"
log "4. Add Google Calendars to Apple Calendars"
echo "" 