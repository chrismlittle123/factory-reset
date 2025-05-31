# factory-reset

## Getting Started

### **Simple One-Command Setup**

If you already have this repository:

```bash
./run.sh
```

### **Fresh Mac Setup**

If you're on a completely fresh Mac, download this repository first:

```bash
# Download and extract
curl -L -o factory-reset.zip "https://github.com/yourusername/factory-reset/archive/refs/heads/main.zip"
unzip factory-reset.zip
cd factory-reset-main

# Run the setup
./run.sh
```

That's it! The script handles everything in one continuous process.

---

## What This Does

**Phase 1: Foundation**
- Installs Homebrew (package manager)
- Installs git
- Installs iTerm2 (for later use)
- Installs and configures oh-my-zsh

**Phase 2: Applications & Development Tools**
- Google Chrome, 1Password, Cursor, Sublime Text
- Python (via pyenv), Node.js, Docker, AWS CLI
- TablePlus, NordVPN, VS Code
- Development tools: jq, tree, wget, curl

**Phase 3: System Configuration**
- Creates ~/Development, ~/GitHub, ~/Screenshots folders
- Configures screenshots to save in ~/Screenshots
- Optimizes Finder and Dock settings
- Adds useful command-line aliases
- Creates desktop shortcuts

## Manual Steps After Installation

- Install Cursor extensions: Python, TypeScript, Rainbow CSV
- Configure AWS CLI: `aws configure`
- Set up GitHub SSH keys: `./scripts/bash_terminal/setup-github.sh`
- Add Google Calendars to Apple Calendars
- Import Chrome bookmarks from `files/bookmarks.json`
- Install Numbers from Mac App Store

---

## Programs Installed

- Google Chrome
- Cursor
- iTerm
- Sublime Text
- Docker
- 1Password
- TablePlus
- Numbers (manual install)
- NordVPN

## Cursor Extensions

- Python
- Typescript
- Rainbow CSV

