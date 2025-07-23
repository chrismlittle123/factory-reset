#!/bin/zsh

# Make scripts executable
chmod +x scripts/zsh/*.sh

# Run install-apps.sh
echo "Installing applications..."
./scripts/zsh/install-apps.sh

# Run system configuration scripts
echo "Configuring system settings..."
./scripts/zsh/configure-dock.sh

echo "All scripts completed successfully!" 