#!/bin/zsh

# Make scripts executable
chmod +x scripts/zsh/*.sh macos-setup.sh setup-github.sh

# Run install-apps.sh
echo "Installing applications..."
./scripts/zsh/install-apps.sh

# Run install-dev-tools.sh
echo "Installing development tools..."
./scripts/zsh/install-dev-tools.sh

# Apply macOS system settings (some steps require sudo)
echo "Applying macOS system settings..."
./macos-setup.sh

# Configure the Dock
echo "Configuring the Dock..."
./scripts/zsh/configure-dock.sh

echo ""
echo "All automated setup complete!"
echo ""
echo "Remaining manual steps before GitHub setup:"
echo "  1. Set Google Chrome as the default browser"
echo "  2. Add the 1Password extension to Chrome and sign in"
echo "  3. Log into GitHub in Chrome"
echo ""
echo "Then run: ./setup-github.sh"
