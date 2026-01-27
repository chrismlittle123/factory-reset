#!/bin/bash

# Get folder name from current directory
FOLDER_NAME="${PWD##*/}"

# Get git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" ($BRANCH)"
    fi
fi

# Output: folder in cyan, branch in red
echo -e "\033[36m${FOLDER_NAME}\033[0m\033[31m${GIT_BRANCH}\033[0m"
