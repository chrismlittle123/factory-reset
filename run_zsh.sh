#!/bin/zsh

# Make scripts executable
chmod +x scripts/zsh_terminal/*.sh

# Run install-apps.sh
echo "Installing applications..."
./scripts/zsh_terminal/install-apps.sh

echo "All scripts completed successfully!" 