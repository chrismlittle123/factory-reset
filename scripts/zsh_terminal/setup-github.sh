#!/bin/zsh

# Set Git global configuration
git config --global user.name "Christopher Little"
git config --global user.email "christopher.little.personal@gmail.com"

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t ed25519 -C "christopher.little.personal@gmail.com" -f ~/.ssh/id_ed25519 -N ""
fi

# Start ssh-agent in the background
eval "$(ssh-agent -s)"

# Add SSH key to ssh-agent
ssh-add ~/.ssh/id_ed25519

# Display the public key
echo "Your SSH public key is:"
cat ~/.ssh/id_ed25519.pub
echo "\nPlease add this key to your GitHub account at https://github.com/settings/keys"
