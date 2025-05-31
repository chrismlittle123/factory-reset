#!/bin/bash

echo "Installing Cursor extensions..."

# List of extensions to install
EXTENSIONS=(
    "ms-python.python"
    "ms-vscode.vscode-typescript-next"
    "mechatroner.rainbow-csv"
)

# Check if Cursor is installed
if ! command -v cursor &> /dev/null; then
    echo "Error: Cursor is not installed or not in PATH"
    exit 1
fi

# Install each extension
for extension in "${EXTENSIONS[@]}"; do
    echo "Installing $extension..."
    cursor --install-extension "$extension"
done

echo "Cursor extensions installation completed!" 