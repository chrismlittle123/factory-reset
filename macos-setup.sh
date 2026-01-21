#!/bin/bash

# macOS Factory Reset Setup Script
# Configures preferred system settings after a fresh install

set -e

echo "=== macOS Setup Script ==="
echo ""

# 1. Scroll Direction (disable natural scrolling)
echo "[1/4] Setting scroll direction..."
defaults write NSGlobalDomain com.apple.swipeScrollDirection -bool true
echo "      ✓ Natural scrolling enabled"

# 2. Disable startup sound (requires sudo - will prompt for password)
echo "[2/4] Disabling startup sound..."
if sudo -n true 2>/dev/null; then
    sudo nvram StartupMute=%01
    echo "      ✓ Startup sound muted"
else
    echo "      ⚠ Requires sudo. Run manually: sudo nvram StartupMute=%01"
fi

# 3. Screenshots location
echo "[3/4] Setting screenshots location..."
SCREENSHOTS_DIR="$HOME/Documents/Screenshots"
if [ ! -d "$SCREENSHOTS_DIR" ]; then
    mkdir -p "$SCREENSHOTS_DIR"
    echo "      ✓ Created $SCREENSHOTS_DIR"
fi
defaults write com.apple.screencapture location "$SCREENSHOTS_DIR"
killall SystemUIServer 2>/dev/null || true
echo "      ✓ Screenshots will save to $SCREENSHOTS_DIR"

# 4. Wallpaper
echo "[4/4] Setting wallpaper..."
WALLPAPER="$HOME/Library/Application Support/com.apple.mobileAssetDesktop/Ventura Graphic.heic"
WALLPAPER_FALLBACK="/System/Library/Desktop Pictures/Ventura Graphic.heic"
if [ -f "$WALLPAPER" ]; then
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
    echo "      ✓ Wallpaper set to Ventura Graphic"
elif [ -f "$WALLPAPER_FALLBACK" ]; then
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER_FALLBACK\""
    echo "      ✓ Wallpaper set to Ventura Graphic (system)"
else
    echo "      ⚠ Ventura Graphic wallpaper not found"
fi

echo ""
echo "=== Setup Complete ==="
echo "Note: Some changes may require logging out or restarting to take effect."
