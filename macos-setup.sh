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

# 1. Scroll Direction (disable natural scrolling — use traditional/mouse-style)
echo "[1/6] Setting scroll direction..."
defaults write NSGlobalDomain com.apple.swipeScrollDirection -bool false
ACTUAL=$(defaults read NSGlobalDomain com.apple.swipeScrollDirection 2>/dev/null)
if [ "$ACTUAL" = "0" ]; then
    pass "Traditional (mouse-style) scrolling enabled"
else
    fail "Natural scrolling not set (got: $ACTUAL)"
fi

# 2. Disable startup sound (requires sudo)
echo "[2/6] Disabling startup sound..."
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
echo "[3/6] Allowing Calendar notifications..."
CALENDAR_BUNDLE="com.apple.iCal"
defaults write "${HOME}/Library/Preferences/com.apple.ncprefs.plist" apps -array-add "<dict><key>bundle-id</key><string>${CALENDAR_BUNDLE}</string><key>flags</key><integer>8</integer></dict>" 2>/dev/null || true
ACTUAL=$(defaults read "${HOME}/Library/Preferences/com.apple.ncprefs.plist" apps 2>/dev/null | grep -c "$CALENDAR_BUNDLE" || true)
if [ "$ACTUAL" -gt 0 ]; then
    pass "Calendar notifications configured"
else
    fail "Calendar notifications not found in ncprefs"
fi

# 4. Allow notifications from Google Chrome
echo "[4/6] Allowing Google Chrome notifications..."
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
echo "[5/6] Setting screenshots location..."
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

# 6. Chrome Extensions (force-installed via managed policy)
echo "[6/6] Configuring Chrome extensions..."
CHROME_POLICY_DIR="/Library/Managed Preferences"
CHROME_POLICY_FILE="$CHROME_POLICY_DIR/com.google.Chrome.plist"

# Extension IDs to force-install. Each is verified against its Chrome Web Store page.
ONEPASSWORD_ID="aeblfdkhhhdcdjpifhhbdiojplfjncoa"   # 1Password – Password Manager
ADBLOCK_ID="gighmmpiobklfepjocnamgkkbiglidom"      # AdBlock — block ads across the web
ADBLOCK_YT_ID="cmedhionkhpnakcndndgjdbohmhepckk"   # Adblock for Youtube™
UNHOOK_ID="khncfooichmfjbepaaaebmommgaepoid"       # Unhook - Remove YouTube Recommended & Shorts
HIDE_AI_OVERVIEWS_ID="neibhohkbmfjninidnaoacabkjonbahn"  # Hide Google AI Overviews

CHROME_EXTENSION_IDS=(
    "$ONEPASSWORD_ID"
    "$ADBLOCK_ID"
    "$ADBLOCK_YT_ID"
    "$UNHOOK_ID"
    "$HIDE_AI_OVERVIEWS_ID"
)

if sudo -n true 2>/dev/null || sudo -v; then
    sudo mkdir -p "$CHROME_POLICY_DIR"

    # Build the per-extension policy entries
    EXTENSION_ENTRIES=""
    for ext_id in "${CHROME_EXTENSION_IDS[@]}"; do
        EXTENSION_ENTRIES+="        <key>${ext_id}</key>
        <dict>
            <key>installation_mode</key>
            <string>normal_installed</string>
            <key>update_url</key>
            <string>https://clients2.google.com/service/update2/crx</string>
        </dict>
"
    done

    sudo tee "$CHROME_POLICY_FILE" > /dev/null << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>ExtensionSettings</key>
    <dict>
${EXTENSION_ENTRIES}    </dict>
</dict>
</plist>
EOF
    MISSING=""
    for ext_id in "${CHROME_EXTENSION_IDS[@]}"; do
        sudo grep -q "$ext_id" "$CHROME_POLICY_FILE" || MISSING+=" $ext_id"
    done
    if sudo test -f "$CHROME_POLICY_FILE" && [ -z "$MISSING" ]; then
        pass "Chrome extensions configured (${#CHROME_EXTENSION_IDS[@]}: 1Password, AdBlock, Adblock for YouTube, Unhook, Hide Google AI Overviews)"
    else
        fail "Chrome policy file missing extensions:${MISSING:-'(file not written)'}"
    fi
else
    skip "Requires sudo for Chrome extensions"
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
