#!/bin/bash

# macOS Factory Reset Setup Script
# Configures preferred system settings after a fresh install

set -e

echo "=== macOS Setup Script ==="
echo ""

# 1. Scroll Direction (disable natural scrolling)
echo "[1/7] Setting scroll direction..."
defaults write NSGlobalDomain com.apple.swipeScrollDirection -bool true
echo "      ✓ Natural scrolling enabled"

# 2. Disable startup sound (requires sudo - will prompt for password)
echo "[2/7] Disabling startup sound..."
if sudo -n true 2>/dev/null; then
    sudo nvram StartupMute=%01
    echo "      ✓ Startup sound muted"
else
    echo "      ⚠ Requires sudo. Run manually: sudo nvram StartupMute=%01"
fi

# 3. Allow notifications from Calendar
echo "[3/7] Allowing Calendar notifications..."
# Note: This opens System Settings for manual confirmation if needed
# The ncprefs database requires special handling on modern macOS
CALENDAR_BUNDLE="com.apple.iCal"
defaults write "${HOME}/Library/Preferences/com.apple.ncprefs.plist" apps -array-add "<dict><key>bundle-id</key><string>${CALENDAR_BUNDLE}</string><key>flags</key><integer>8</integer></dict>" 2>/dev/null || true
echo "      ✓ Calendar notifications configured"

# 4. Allow notifications from Google Chrome
echo "[4/7] Allowing Google Chrome notifications..."
CHROME_BUNDLE="com.google.Chrome"
defaults write "${HOME}/Library/Preferences/com.apple.ncprefs.plist" apps -array-add "<dict><key>bundle-id</key><string>${CHROME_BUNDLE}</string><key>flags</key><integer>8</integer></dict>" 2>/dev/null || true
echo "      ✓ Google Chrome notifications configured"

# Restart notification center to apply changes
killall NotificationCenter 2>/dev/null || true

# 5. Screenshots location
echo "[5/7] Setting screenshots location..."
SCREENSHOTS_DIR="$HOME/Documents/Screenshots"
if [ ! -d "$SCREENSHOTS_DIR" ]; then
    mkdir -p "$SCREENSHOTS_DIR"
    echo "      ✓ Created $SCREENSHOTS_DIR"
fi
defaults write com.apple.screencapture location "$SCREENSHOTS_DIR"
killall SystemUIServer 2>/dev/null || true
echo "      ✓ Screenshots will save to $SCREENSHOTS_DIR"

# 6. Wallpaper
echo "[6/7] Setting wallpaper..."
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

# 7. Chrome 1Password Extension
echo "[7/7] Configuring Chrome 1Password extension..."
CHROME_POLICY_DIR="/Library/Managed Preferences"
CHROME_POLICY_FILE="$CHROME_POLICY_DIR/com.google.Chrome.plist"
ONEPASSWORD_ID="aeblfdkhhhdcdjpifhhbdiojplfjncoa"

if sudo -n true 2>/dev/null || sudo -v; then
    sudo mkdir -p "$CHROME_POLICY_DIR"

    sudo tee "$CHROME_POLICY_FILE" > /dev/null << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>ExtensionSettings</key>
    <dict>
        <key>${ONEPASSWORD_ID}</key>
        <dict>
            <key>installation_mode</key>
            <string>normal_installed</string>
            <key>update_url</key>
            <string>https://clients2.google.com/service/update2/crx</string>
        </dict>
    </dict>
</dict>
</plist>
EOF
    echo "      ✓ 1Password extension configured"
else
    echo "      ⚠ Requires sudo for 1Password extension. Skipping."
fi

echo ""
echo "=== Setup Complete ==="
echo "Note: Some changes may require logging out or restarting to take effect."
