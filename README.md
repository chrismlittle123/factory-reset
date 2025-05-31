# factory-reset

## Getting Started

### **Fresh Mac Setup**

If you're on a completely fresh Mac, download this repository first to your Downloads:

- https://github.com/chrismlittle123/factory-reset

In MacOS terminal run:

```bash
run_bash.sh
```

Then in iTerm run:

```bash
run_zsh.sh
```

---

## What This Does

**Phase 1: Foundation**
- Installs Homebrew (package manager)
- Installs git
- Installs iTerm2 (for later use)
- Installs and configures oh-my-zsh

# ZSH 1

**Phase 2: Applications & Development Tools**
- Google Chrome, 1Password, Cursor, Sublime Text
- Python (via pyenv), Node.js, Docker, AWS CLI
- TablePlus, NordVPN, VS Code
- Development tools: jq, tree, wget, curl

**Phase 3: System Configuration**
- Runs script to configure Dock
- Runs script to configure scroll
- Runs script to import Bookmarks to Chrome

## Manual Steps After Installation

- Log into 1Password
- Log into Gmail and Github in Chrome
- Add 1Password Google Chrome Extension
- Set up GitHub SSH keys: `./scripts/zsh_terminal/setup-github.sh`
- Set up iCloud for Desktop
- Install Numbers from App Store
- Add Google Calendars to Apple Calendars
- Configure AWS CLI: `aws configure`

# ZSH 2

- Imports Chrome bookmarks from `files/bookmarks.html`
- Installs Cursor extensions: Python, TypeScript, Rainbow CSV

