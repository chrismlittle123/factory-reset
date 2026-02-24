# factory-reset

A comprehensive macOS setup automation tool for configuring a fresh Mac with development tools and applications.

## Quick Start

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

## Scripts (Run in Order)

### Step 1: Foundation (run in macOS Terminal)

```bash
./scripts/bash/install-foundation.sh
```

Installs Homebrew, git, iTerm2, oh-my-zsh, and applies custom `.zshrc`.

**Switch to iTerm2 for the remaining steps.**

### Step 2: Applications

```bash
./scripts/zsh/install-apps.sh
```

Installs Google Chrome, 1Password, Claude, Node.js, Docker (Colima), AWS CLI, Google Cloud CLI, VS Code, Sublime Text, Slack, and zsh plugins.

### Step 3: Development Tools

```bash
./scripts/zsh/install-dev-tools.sh
```

Installs Claude Code CLI, Python 3.13, UV, and GitHub CLI.

### Step 4: GitHub Setup

```bash
./setup-github.sh
```

Configures git user, generates SSH key, authenticates with GitHub CLI, and uploads the SSH key.

### Step 5: macOS System Settings

```bash
./macos-setup.sh
```

Configures scroll direction, startup sound, notifications (Calendar, Chrome), screenshots location, wallpaper, and Chrome 1Password extension. Each setting is verified after being applied. Some steps require sudo.

### Step 6: Dock Configuration

```bash
./scripts/zsh/configure-dock.sh
```

Removes all dock apps and adds: Chrome, iTerm, Sublime Text, Slack, VS Code, 1Password, Claude.

## Project Structure

```
factory-reset/
├── run_bash.sh                       # Orchestrator: runs step 1
├── run_zsh.sh                        # Orchestrator: runs steps 2, 3, 6
├── macos-setup.sh                    # macOS system settings with verification
├── setup-github.sh                   # Git + SSH + GitHub auth
├── files/
│   ├── .zshrc                        # Custom zsh configuration
│   └── bookmarks.html                # Chrome bookmarks for manual import
└── scripts/
    ├── bash/
    │   └── install-foundation.sh     # Homebrew, git, iTerm2, oh-my-zsh
    ├── zsh/
    │   ├── install-apps.sh           # Applications and cloud CLIs
    │   ├── install-dev-tools.sh      # Dev tools and language runtimes
    │   └── configure-dock.sh         # Dock configuration
    └── dev-launcher.sh               # Launch repos in iTerm2 split panes
```

## Manual Steps After Installation

1. Log into 1Password
2. Log into Gmail and GitHub in Chrome
3. Import Chrome bookmarks from `files/bookmarks.html`
4. Configure AWS CLI: `aws configure`
5. Configure GCloud CLI: `gcloud init`

## Notes

- Scripts are designed to run in sequence: step 1 in default Terminal, steps 2-6 in iTerm2
- All installations use Homebrew for consistency
- The dock configuration removes all existing apps and adds only the specified ones
- GitHub setup configures git with: Christopher Little (christopher.little.personal@gmail.com)