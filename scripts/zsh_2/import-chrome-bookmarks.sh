#!/bin/bash

# Path to Chrome bookmarks file
BOOKMARKS_FILE="../../files/bookmarks.html"
CHROME_DIR="$HOME/Library/Application Support/Google/Chrome/Default"

# Check if bookmarks file exists
if [ ! -f "$BOOKMARKS_FILE" ]; then
    echo "Error: Bookmarks file not found at $BOOKMARKS_FILE"
    exit 1
fi

# Check if Chrome is running
if pgrep -x "Google Chrome" > /dev/null; then
    echo "Please close Google Chrome before importing bookmarks"
    exit 1
fi

# Backup existing bookmarks
if [ -f "$CHROME_DIR/Bookmarks" ]; then
    echo "Backing up existing bookmarks..."
    cp "$CHROME_DIR/Bookmarks" "$CHROME_DIR/Bookmarks.backup"
fi

# Copy new bookmarks
echo "Importing new bookmarks..."
cp "$BOOKMARKS_FILE" "$CHROME_DIR/Bookmarks"

echo "Bookmarks imported successfully!"
echo "You can now open Chrome to see your imported bookmarks" 