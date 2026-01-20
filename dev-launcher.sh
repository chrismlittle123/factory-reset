#!/bin/bash

# dev-launcher.sh - Launch multiple repos in iTerm2 split panes with claude

GITHUB_DIR="$HOME/Documents/GitHub"
START_CMD="claude --dangerously-skip-permissions"

# Check for fzf
if ! command -v fzf &> /dev/null; then
    echo "fzf not found. Install with: brew install fzf"
    exit 1
fi

# Find all git repos and let user select with fzf
selected=$(find "$GITHUB_DIR" -maxdepth 3 -name ".git" -type d 2>/dev/null | \
    sed 's/\/.git$//' | \
    sed "s|$GITHUB_DIR/||" | \
    sort | \
    fzf --multi --reverse --preview "ls -la $GITHUB_DIR/{}" \
        --header "Select projects (TAB to multi-select, ENTER to confirm)")

# Exit if nothing selected
if [ -z "$selected" ]; then
    echo "No projects selected."
    exit 0
fi

# Convert to array
projects=()
while IFS= read -r line; do
    projects+=("$line")
done <<< "$selected"

count=${#projects[@]}
echo "Launching $count project(s)..."

# Build the AppleScript to open iTerm2 with split panes
osascript <<EOF
tell application "iTerm2"
    activate

    -- Create new window with first project
    set newWindow to (create window with default profile)

    tell newWindow
        tell current tab
            -- For 4 panes, create a 2x2 grid
            if $count = 4 then
                -- Start with session 1 (top-left)
                -- Split horizontally to create right column
                tell session 1
                    set rightSession to (split horizontally with default profile)
                end tell
                -- Split top-left vertically to create bottom-left
                tell session 1
                    set bottomLeftSession to (split vertically with default profile)
                end tell
                -- Split top-right vertically to create bottom-right
                tell rightSession
                    set bottomRightSession to (split vertically with default profile)
                end tell
            else if $count = 2 then
                -- Just split horizontally for 2 panes
                tell session 1
                    split horizontally with default profile
                end tell
            else if $count = 3 then
                -- Split horizontally, then split left vertically
                tell session 1
                    split horizontally with default profile
                end tell
                tell session 1
                    split vertically with default profile
                end tell
            else if $count > 4 then
                -- For more than 4, use a simple grid approach
                set cols to 2
                set rows to ($count + 1) div 2

                -- First create the columns
                tell session 1
                    split horizontally with default profile
                end tell

                -- Split left column for additional rows
                repeat with r from 2 to rows
                    tell session 1
                        split vertically with default profile
                    end tell
                end repeat

                -- Split right column for additional rows
                repeat with r from 2 to (($count + 1) div 2)
                    tell session 2
                        split vertically with default profile
                    end tell
                end repeat
            end if

            -- Send commands to each session
            set projectList to {"${projects[0]}"$(printf ', "%s"' "${projects[@]:1}")}
            repeat with i from 1 to count of sessions
                if i ≤ (count of projectList) then
                    set projectPath to item i of projectList
                    tell item i of sessions
                        write text "cd \"$GITHUB_DIR/" & projectPath & "\" && $START_CMD"
                    end tell
                end if
            end repeat
        end tell
    end tell
end tell
EOF

echo "Done! Launched: ${projects[*]}"
