#!/bin/bash

echo "Starting ZSH Phase 2 configuration..."

# Function to check if a script exists and is executable
check_script() {
    if [ ! -f "$1" ]; then
        echo "Error: Script not found: $1"
        return 1
    fi
    if [ ! -x "$1" ]; then
        echo "Error: Script not executable: $1"
        return 1
    fi
    return 0
}

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$SCRIPT_DIR/scripts/zsh_2"

# Change to the scripts directory
cd "$SCRIPTS_DIR" || exit 1


# Import Chrome bookmarks
echo -e "\n=== Importing Chrome Bookmarks ==="
if check_script "./import-chrome-bookmarks.sh"; then
    ./import-chrome-bookmarks.sh
else
    echo "Skipping Chrome bookmarks import..."
fi

# Install Cursor extensions
echo -e "\n=== Installing Cursor Extensions ==="
if check_script "./install-cursor-extensions.sh"; then
    ./install-cursor-extensions.sh
else
    echo "Skipping Cursor extensions installation..."
fi

echo -e "\nZSH Phase 2 configuration completed!"
