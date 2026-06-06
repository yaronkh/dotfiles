#!/bin/bash
#
# Bootstrap the local Claude secrets file from the tracked template.
# etczsh/zshrc sources ~/.config/claude/secrets.env, and claude/settings.json
# references the exported vars via ${VAR} expansion.
#
# Idempotent: NEVER overwrites an existing secrets.env (it holds your real,
# already-filled-in tokens). Only seeds the file on a fresh node.

set -e

# ~/.config/claude is created (mode 0700) by the dotbot `create` directive,
# which runs before this shell step.
SECRETS_DIR="$HOME/.config/claude"
SECRETS_FILE="$SECRETS_DIR/secrets.env"
TEMPLATE="$HOME/dotfiles/claude/secrets.env.example"

if [ -f "$SECRETS_FILE" ]; then
    echo "$SECRETS_FILE already exists; leaving it untouched."
else
    cp "$TEMPLATE" "$SECRETS_FILE"
    chmod 600 "$SECRETS_FILE"
    echo "created $SECRETS_FILE from template -- edit it and fill in your real tokens."
fi
