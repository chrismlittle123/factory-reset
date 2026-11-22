#!/usr/bin/env zsh

# Install the personal AWS CLI config: one IAM Identity Center (SSO) session
# and a profile per account. No access keys are written; credentials come
# from `aws sso login` and expire on their own.

set -e

SCRIPT_DIR="${0:A:h}"
SRC="$SCRIPT_DIR/../../files/aws-config"
DEST="$HOME/.aws/config"

mkdir -p "$HOME/.aws"

if [[ -f "$DEST" ]] && ! cmp -s "$SRC" "$DEST"; then
    BACKUP="$DEST.bak.$(date +%Y%m%d%H%M%S)"
    cp "$DEST" "$BACKUP"
    echo "Existing ~/.aws/config backed up to $BACKUP"
fi

cp "$SRC" "$DEST"
echo "Installed ~/.aws/config with profiles: $(aws configure list-profiles 2>/dev/null | tr '\n' ' ')"
echo "Sign in (once, covers every profile): aws sso login --sso-session personal"
