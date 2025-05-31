#!/bin/zsh

# Make scripts executable
chmod +x scripts/zsh_terminal/*.sh

# Run install-apps.sh
echo "Installing applications..."
./scripts/zsh_terminal/install-apps.sh

# Run system configuration
echo "Configuring system settings..."
./scripts/zsh_terminal/setup-system.sh

echo "All scripts completed successfully!" 