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

# 6. Chrome Extensions (opened in Chrome for a one-click "Add to Chrome")
# Chrome doesn't allow installing Web Store extensions from the command line on
# unmanaged Macs, so open each missing extension's store page instead.
echo "[6/6] Opening Chrome extensions to install..."
CHROME_EXTENSIONS_DIR="$HOME/Library/Application Support/Google/Chrome/Default/Extensions"

# "id|name" pairs. Each ID is verified against its Chrome Web Store page.
CHROME_EXTENSIONS=(
    "aeblfdkhhhdcdjpifhhbdiojplfjncoa|1Password – Password Manager"
    "gighmmpiobklfepjocnamgkkbiglidom|AdBlock — block ads across the web"
    "cmedhionkhpnakcndndgjdbohmhepckk|Adblock for Youtube™"
    "khncfooichmfjbepaaaebmommgaepoid|Unhook - Remove YouTube Recommended & Shorts"
    "neibhohkbmfjninidnaoacabkjonbahn|Hide Google AI Overviews"
)

# Remove the policy file left by the old force-install approach (Chrome ignored it)
OLD_POLICY_FILE="/Library/Managed Preferences/com.google.Chrome.plist"
if [ -f "$OLD_POLICY_FILE" ] && sudo -n true 2>/dev/null; then
    sudo rm -f "$OLD_POLICY_FILE"
fi

if [ ! -d "/Applications/Google Chrome.app" ]; then
    fail "Google Chrome not installed"
else
    OPENED=""
    for entry in "${CHROME_EXTENSIONS[@]}"; do
        ext_id="${entry%%|*}"
        ext_name="${entry#*|}"
        if [ -d "$CHROME_EXTENSIONS_DIR/$ext_id" ]; then
            pass "$ext_name already installed"
        else
            open -a "Google Chrome" "https://chromewebstore.google.com/detail/$ext_id"
            OPENED+="        - $ext_name"$'\n'
        fi
    done
    if [ -n "$OPENED" ]; then
        skip "Click \"Add to Chrome\" in each tab that just opened:"
        printf "%s" "$OPENED"
    fi
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
    echo "Note: Some steps need finishing by hand (sudo, or adding Chrome extensions). See ⚠ above."
else
    echo "All settings applied and verified successfully!"
fi
