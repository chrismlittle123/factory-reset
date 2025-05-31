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

**Phase 2: Applications & Development Tools**
- Google Chrome, 1Password, Cursor, Sublime Text
- Python (via pyenv), Node.js, Docker, AWS CLI
- TablePlus, NordVPN, VS Code
- Development tools: jq, tree, wget, curl

**Phase 3: System Configuration**
- Runs scripts to configure Dock and set scroll direction



## Manual Steps After Installation

- Log into 1Password
- Set up iCloud for Desktop
- Set up GitHub SSH keys: `./scripts/zsh_terminal/setup-github.sh`
- Install Cursor extensions: Python, TypeScript, Rainbow CSV
- Configure AWS CLI: `aws configure`
- Add Google Calendars to Apple Calendars
- Import Chrome bookmarks from `files/bookmarks.html`
- Install Numbers from Mac App Store

- Remove all apps from Dock bar except for:

------------------------------------------------------------------------------------
- Finder
- System Settings
- Google Chrome
- Cursor
- iTerm
- Sublime Text
- Docker
- 1Password
- TablePlus
- Numbers
- NordVPN

## Cursor Extensions

- Python
- Typescript
- Rainbow CSV

