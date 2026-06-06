#!/bin/bash
#
# Install the GitHub CLI (gh) -- used by Claude Code for PR/issue/repo ops.
# rg, fd, jq are handled via install_me/packages_*.txt; gh needs its own repo.
# Idempotent and works on apt (Debian/Ubuntu) and dnf (RHEL) nodes.

set -e

if command -v gh >/dev/null 2>&1; then
    echo "gh already installed ($(command -v gh)); skipping."
    exit 0
fi

if command -v apt-get >/dev/null 2>&1; then
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update
    sudo apt-get install -y gh
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y 'dnf-command(config-manager)'
    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install -y gh
else
    echo "no supported package manager (apt/dnf) found; install gh manually" >&2
    exit 1
fi

echo "gh installed: $(gh --version | head -1)"
