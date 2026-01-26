#!/bin/bash

# Nuclear option: Remove ALL Chrome extensions, then reinstall only 1Password
# Usage: sudo ./remove-dark-reader.sh

if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo: sudo $0"
    exit 1
fi

CURRENT_USER="${SUDO_USER:-$USER}"
CHROME_DIR="/Users/$CURRENT_USER/Library/Application Support/Google/Chrome"
CHROME_POLICY_FILE_1="/Library/Managed Preferences/com.google.Chrome.plist"
CHROME_POLICY_FILE_2="/Library/Google/Chrome/Managed Preferences/com.google.Chrome.plist"
ONEPASSWORD_ID="aeblfdkhhhdcdjpifhhbdiojplfjncoa"

echo "=== NUCLEAR OPTION: Removing ALL Chrome extensions ==="
echo ""

# Step 1: Force quit Chrome completely
echo "Step 1: Force quitting Chrome..."
pkill -9 -x "Google Chrome" 2>/dev/null
pkill -9 -f "Google Chrome Helper" 2>/dev/null
pkill -9 -f "Google Chrome" 2>/dev/null
sleep 3
echo "✓ Chrome killed"

# Step 2: Delete BOTH managed preferences files
echo "Step 2: Removing ALL Chrome policy files..."
rm -f "$CHROME_POLICY_FILE_1"
rm -f "$CHROME_POLICY_FILE_2"
echo "✓ Both policy files deleted"

# Step 3: Delete ALL extensions folders (for all profiles)
echo "Step 3: Deleting all extension folders..."
find "$CHROME_DIR" -type d -name "Extensions" -exec rm -rf {} + 2>/dev/null
echo "✓ All extension folders deleted"

# Step 4: Delete extension state directories
echo "Step 4: Clearing extension state..."
find "$CHROME_DIR" -type d -name "Extension State" -exec rm -rf {} + 2>/dev/null
find "$CHROME_DIR" -type d -name "Extension Rules" -exec rm -rf {} + 2>/dev/null
find "$CHROME_DIR" -type d -name "Extension Scripts" -exec rm -rf {} + 2>/dev/null
echo "✓ Extension state cleared"

# Step 5: Clean extension data from Preferences files in all profiles
echo "Step 5: Cleaning preferences files..."
find "$CHROME_DIR" -name "Preferences" -o -name "Secure Preferences" | while read pref_file; do
    if [ -f "$pref_file" ]; then
        python3 << PYTHON
import json
import os

pref_path = "$pref_file"
try:
    with open(pref_path, 'r') as f:
        data = json.load(f)

    modified = False

    # Clear extensions settings
    if 'extensions' in data:
        if 'settings' in data['extensions']:
            data['extensions']['settings'] = {}
            modified = True
        if 'toolbarOrder' in data['extensions']:
            data['extensions']['toolbarOrder'] = []
            modified = True

    if modified:
        with open(pref_path, 'w') as f:
            json.dump(data, f)
        print(f"  ✓ Cleaned: {pref_path}")
except Exception as e:
    print(f"  - Could not clean {pref_path}: {e}")
PYTHON
    fi
done

# Step 6: Delete Local Extension Settings
echo "Step 6: Clearing local extension settings..."
find "$CHROME_DIR" -type d -name "Local Extension Settings" -exec rm -rf {} + 2>/dev/null
find "$CHROME_DIR" -type d -name "Sync Extension Settings" -exec rm -rf {} + 2>/dev/null
find "$CHROME_DIR" -type d -name "Managed Extension Settings" -exec rm -rf {} + 2>/dev/null
echo "✓ Local extension settings cleared"

# Step 7: Now reinstall ONLY 1Password via policy (in BOTH locations)
echo "Step 7: Installing 1Password extension policy..."

# Create policy in first location
mkdir -p "/Library/Managed Preferences"
cat > "$CHROME_POLICY_FILE_1" << EOF
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
echo "✓ 1Password policy installed"

# Step 8: Relaunch Chrome
echo "Step 8: Relaunching Chrome..."
sleep 2
sudo -u "$CURRENT_USER" open -a "Google Chrome"

echo ""
echo "=== DONE ==="
echo "All extensions have been removed."
echo "1Password will be installed automatically when Chrome starts."
echo ""
echo "You may need to reinstall other extensions manually (Claude, Loom, etc.)"
