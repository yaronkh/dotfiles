#!/bin/bash
#
# Install Google Chrome -- the system browser Playwright drives (channel="chrome")
# for the /management_open Claude command (claude/scripts/nvme31_management_open.py).
# Idempotent; works on apt (Debian/Ubuntu) and dnf (RHEL) nodes.

set -e

if command -v google-chrome >/dev/null 2>&1; then
    echo "google-chrome already installed ($(command -v google-chrome)); skipping."
    exit 0
fi

if command -v apt-get >/dev/null 2>&1; then
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
        | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg
    sudo chmod go+r /etc/apt/keyrings/google-chrome.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
        | sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null
    sudo apt-get update
    sudo apt-get install -y google-chrome-stable
elif command -v dnf >/dev/null 2>&1; then
    sudo tee /etc/yum.repos.d/google-chrome.repo >/dev/null <<'EOF'
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
    sudo dnf install -y google-chrome-stable
else
    echo "no supported package manager (apt/dnf) found; install google-chrome manually" >&2
    exit 1
fi

echo "google-chrome installed: $(google-chrome --version)"
