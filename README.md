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

Then complete the Chrome prerequisites and run GitHub setup (see Step 3 below).

## Scripts (Run in Order)

### Step 1: Foundation (run in macOS Terminal)

```bash
./run_bash.sh
```

Installs Homebrew, git, iTerm2, oh-my-zsh, and applies custom `.zshrc`.

**Switch to iTerm2 for the remaining steps.**

### Step 2: Everything else (run in iTerm2)

```bash
./run_zsh.sh
```

Runs, in order:

- **Applications** (`install-apps.sh`) — Google Chrome, 1Password, Claude, Node.js, Docker (Colima), AWS CLI, Google Cloud CLI, VS Code, Sublime Text, Slack, Obsidian, Telegram, and zsh plugins.
- **Development tools** (`install-dev-tools.sh`) — Claude Code CLI, Python 3.13, UV, GitHub CLI, fzf, and jq. Also installs the Claude Code statusline (`statusline.sh` → `~/.claude/`) and registers it in `~/.claude/settings.json`.
- **macOS system settings** (`macos-setup.sh`) — scroll direction, startup sound, notifications (Calendar, Chrome), screenshots location, wallpaper, and Chrome extensions (1Password, AdBlock, Adblock for YouTube, Unhook) force-installed via managed policy. Each setting is verified; some steps require sudo.
- **Dock** (`configure-dock.sh`) — removes all dock apps and adds: Chrome, iTerm, Sublime Text, Slack, Telegram, VS Code, Obsidian, 1Password, Claude.

### Step 3: GitHub Setup (run separately, after Chrome is ready)

First complete these manual prerequisites:

1. Set Google Chrome as the default browser
2. Add the 1Password extension to Chrome and sign in
3. Log into GitHub in Chrome

Then run:

```bash
./setup-github.sh
```

Configures git user, generates an SSH key, authenticates with GitHub CLI, and uploads the SSH key.

## Project Structure

```
factory-reset/
├── run_bash.sh                       # Orchestrator: foundation (macOS Terminal)
├── run_zsh.sh                        # Orchestrator: apps, dev tools, macOS settings, dock (iTerm2)
├── macos-setup.sh                    # macOS system settings with verification
├── setup-github.sh                   # Git + SSH + GitHub auth (run separately)
├── statusline.sh                     # Claude Code terminal statusline
├── iphone-apps.md                    # Manual checklist for restoring an iPhone
├── files/
│   ├── .zshrc                        # Custom zsh configuration
│   └── bookmarks_*.html              # Chrome bookmarks export for manual import
└── scripts/
    ├── bash/
    │   └── install-foundation.sh     # Homebrew, git, iTerm2, oh-my-zsh
    └── zsh/
        ├── install-apps.sh           # Applications and cloud CLIs
        ├── install-dev-tools.sh      # Dev tools and language runtimes
        └── configure-dock.sh         # Dock configuration
```

## Manual Steps After Installation

1. Log into 1Password
2. Log into Gmail and GitHub in Chrome
3. Import Chrome bookmarks from `files/bookmarks_*.html` (most recent export)
4. Configure AWS CLI: `aws configure`
5. Configure GCloud CLI: `gcloud init`

## Notes

- Scripts are designed to run in sequence: `run_bash.sh` in default Terminal, `run_zsh.sh` in iTerm2, then `setup-github.sh` once Chrome is ready
- All installations use Homebrew for consistency
- The dock configuration removes all existing apps and adds only the specified ones
- GitHub setup configures git with: Christopher Little (christopher.little.personal@gmail.com)