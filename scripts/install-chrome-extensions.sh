#!/bin/bash

# Install Chrome extensions via managed policy
# Usage: sudo ./install-chrome-extensions.sh

if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo: sudo $0"
    exit 1
fi

CHROME_POLICY_DIR="/Library/Managed Preferences"
CHROME_POLICY_FILE="$CHROME_POLICY_DIR/com.google.Chrome.plist"

# Extension IDs
ONEPASSWORD_ID="aeblfdkhhhdcdjpifhhbdiojplfjncoa"

echo "Installing Chrome extension policy..."
mkdir -p "$CHROME_POLICY_DIR"

cat > "$CHROME_POLICY_FILE" << EOF
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

echo "✓ 1Password extension configured"

echo ""
echo "Restarting Chrome..."
pkill -x "Google Chrome" 2>/dev/null && sleep 1
open -a "Google Chrome"

echo ""
echo "=== Done! ==="
echo ""
echo "Remember to enable dark mode in cloud consoles:"
echo "  AWS: Click gear icon (⚙) → Visual mode → Dark"
echo "  GCP: Settings → Preferences → Appearance → Dark"
