#!/bin/bash

# macOS Factory Reset Setup Script
# Configures preferred system settings after a fresh install

set -e

echo "=== macOS Setup Script ==="
echo ""

PASS=0
FAIL=0
SKIP=0

pass() {
    echo "      ✓ $1"
    PASS=$((PASS + 1))
}

fail() {
    echo "      ✗ $1"
    FAIL=$((FAIL + 1))
}

skip() {
    echo "      ⚠ $1"
    SKIP=$((SKIP + 1))
}

# 1. Scroll Direction (enable natural scrolling)
echo "[1/7] Setting scroll direction..."
defaults write NSGlobalDomain com.apple.swipeScrollDirection -bool false
ACTUAL=$(defaults read NSGlobalDomain com.apple.swipeScrollDirection 2>/dev/null)
if [ "$ACTUAL" = "0" ]; then
    pass "Traditional (mouse-style) scrolling enabled"
else
    fail "Natural scrolling not set (got: $ACTUAL)"
fi

# 2. Disable startup sound (requires sudo)
echo "[2/7] Disabling startup sound..."
if sudo -n true 2>/dev/null; then
    sudo nvram StartupMute=%01
    ACTUAL=$(sudo nvram StartupMute 2>/dev/null | awk '{print $2}')
    if [ "$ACTUAL" = "%01" ]; then
        pass "Startup sound muted"
    else
        fail "Startup sound not muted (got: $ACTUAL)"
    fi
else
    skip "Requires sudo. Run manually: sudo nvram StartupMute=%01"
fi

# 3. Allow notifications from Calendar
echo "[3/7] Allowing Calendar notifications..."
CALENDAR_BUNDLE="com.apple.iCal"
defaults write "${HOME}/Library/Preferences/com.apple.ncprefs.plist" apps -array-add "<dict><key>bundle-id</key><string>${CALENDAR_BUNDLE}</string><key>flags</key><integer>8</integer></dict>" 2>/dev/null || true
ACTUAL=$(defaults read "${HOME}/Library/Preferences/com.apple.ncprefs.plist" apps 2>/dev/null | grep -c "$CALENDAR_BUNDLE" || true)
if [ "$ACTUAL" -gt 0 ]; then
    pass "Calendar notifications configured"
else
    fail "Calendar notifications not found in ncprefs"
fi

# 4. Allow notifications from Google Chrome
echo "[4/7] Allowing Google Chrome notifications..."
CHROME_BUNDLE="com.google.Chrome"
defaults write "${HOME}/Library/Preferences/com.apple.ncprefs.plist" apps -array-add "<dict><key>bundle-id</key><string>${CHROME_BUNDLE}</string><key>flags</key><integer>8</integer></dict>" 2>/dev/null || true
ACTUAL=$(defaults read "${HOME}/Library/Preferences/com.apple.ncprefs.plist" apps 2>/dev/null | grep -c "$CHROME_BUNDLE" || true)
if [ "$ACTUAL" -gt 0 ]; then
    pass "Google Chrome notifications configured"
else
    fail "Google Chrome notifications not found in ncprefs"
fi

# Restart notification center to apply changes
killall NotificationCenter 2>/dev/null || true

# 5. Screenshots location
echo "[5/7] Setting screenshots location..."
SCREENSHOTS_DIR="$HOME/Documents/Screenshots"
if [ ! -d "$SCREENSHOTS_DIR" ]; then
    mkdir -p "$SCREENSHOTS_DIR"
fi
defaults write com.apple.screencapture location "$SCREENSHOTS_DIR"
killall SystemUIServer 2>/dev/null || true
ACTUAL=$(defaults read com.apple.screencapture location 2>/dev/null)
if [ "$ACTUAL" = "$SCREENSHOTS_DIR" ] && [ -d "$SCREENSHOTS_DIR" ]; then
    pass "Screenshots will save to $SCREENSHOTS_DIR"
else
    fail "Screenshots location not set correctly (got: $ACTUAL)"
fi

# 6. Wallpaper
echo "[6/7] Setting wallpaper..."
WALLPAPER="$HOME/Library/Application Support/com.apple.mobileAssetDesktop/Ventura Graphic.heic"
WALLPAPER_FALLBACK="/System/Library/Desktop Pictures/Ventura Graphic.heic"
WALLPAPER_SET=""
if [ -f "$WALLPAPER" ]; then
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
    WALLPAPER_SET="$WALLPAPER"
elif [ -f "$WALLPAPER_FALLBACK" ]; then
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER_FALLBACK\""
    WALLPAPER_SET="$WALLPAPER_FALLBACK"
fi

if [ -n "$WALLPAPER_SET" ]; then
    ACTUAL=$(osascript -e 'tell application "System Events" to get picture of desktop 1' 2>/dev/null)
    if [ "$ACTUAL" = "$WALLPAPER_SET" ]; then
        pass "Wallpaper set to Ventura Graphic"
    else
        fail "Wallpaper not set correctly (got: $ACTUAL)"
    fi
else
    fail "Ventura Graphic wallpaper not found"
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
    if sudo test -f "$CHROME_POLICY_FILE" && sudo grep -q "$ONEPASSWORD_ID" "$CHROME_POLICY_FILE"; then
        pass "1Password extension configured"
    else
        fail "1Password policy file not written correctly"
    fi
else
    skip "Requires sudo for 1Password extension"
fi

echo ""
echo "=== Results ==="
echo "  Passed:  $PASS"
echo "  Failed:  $FAIL"
echo "  Skipped: $SKIP"
echo ""
if [ "$FAIL" -gt 0 ]; then
    echo "⚠ Some settings failed verification. Review output above."
elif [ "$SKIP" -gt 0 ]; then
    echo "Note: Some steps were skipped (require sudo). Re-run with sudo access to complete."
else
    echo "All settings applied and verified successfully!"
fi
