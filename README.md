# factory-reset

A comprehensive macOS setup automation tool for configuring a fresh Mac with development tools and applications.

## Getting Started

### **Fresh Mac Setup**

If you're on a completely fresh Mac, download this repository first to your Downloads:

- https://github.com/chrismlittle123/factory-reset

In macOS Terminal run:

```bash
./run_bash.sh
```

After the foundation setup completes, switch to iTerm2 and run:

```bash
./run_zsh.sh
```

---

## What This Does

### **Phase 1: Foundation** (run_bash.sh in Terminal)
- Installs Homebrew (package manager)
- Installs git
- Installs iTerm2 (terminal replacement)
- Installs and configures oh-my-zsh
- Applies custom .zshrc configuration

### **Phase 2: Applications & Development Tools** (run_zsh.sh in iTerm2)

**Applications:**
- Google Chrome
- 1Password (password manager)
- Cursor (AI-powered editor)
- Sublime Text
- Docker
- TablePlus (database client)
- NordVPN
- Slack
- Notion

**Development Tools:**
- Node.js
- AWS CLI
- Zsh plugins (autosuggestions, syntax highlighting)

### **Phase 3: System Configuration**
- Configures macOS Dock with installed applications
- Provides scripts for GitHub SSH setup

## Project Structure

```
factory-reset/
├── run_bash.sh         # Phase 1 entry point (run in Terminal)
├── run_zsh.sh          # Phase 2 entry point (run in iTerm2)
├── files/
│   ├── bookmarks.html  # Chrome bookmarks for manual import
│   └── .zshrc          # Custom zsh configuration
└── scripts/
    ├── bash/
    │   └── install-foundation.sh  # Homebrew, git, iTerm2, oh-my-zsh
    └── zsh/
        ├── install-apps.sh        # All applications and dev tools
        ├── configure-dock.sh      # macOS dock configuration
        └── setup-github.sh        # GitHub SSH key setup
```

## Manual Steps After Installation

### Required Steps:
1. **Log into 1Password**
2. **Log into Gmail and GitHub in Chrome**
3. **Reverse scroll direction** (System Settings > Trackpad)
4. **Add 1Password Chrome Extension**
5. **Set up GitHub SSH keys**: 
   ```bash
   ./scripts/zsh/setup-github.sh
   ```
   Then add the displayed key to GitHub Settings > SSH Keys
6. **Configure AWS CLI**: 
   ```bash
   aws configure
   ```
7. **Import Chrome bookmarks** from `files/bookmarks.html`

### Optional Steps:
- Set up iCloud for Desktop sync
- Install Numbers from App Store
- Install Cursor extensions: Python, TypeScript, Rainbow CSV
- Add Google Calendars to Apple Calendar

## Notes

- The scripts are designed to run in sequence: Phase 1 in default Terminal, then Phase 2 in iTerm2
- All installations use Homebrew for consistency
- The dock configuration removes all existing apps and adds only the specified ones
- GitHub setup configures git with: Christopher Little (christopher.little.personal@gmail.com)