#!/bin/bash
#
# Install Claude Code and restore the plugins/marketplaces declared in
# ~/.claude/settings.json (symlinked from dotfiles/claude/settings.json).
#
# Idempotent: re-running installs missing pieces and self-updates the binary.
# MCP servers (jira, jenkins) need no install here -- they run via `npx -y` at
# runtime and are defined in the symlinked settings.json.

set -e

# --- binary (native installer; lands in ~/.local/bin/claude) ---------------
if command -v claude >/dev/null 2>&1; then
    echo "claude already installed ($(command -v claude)); updating..."
    claude update || true
else
    curl -fsSL https://claude.ai/install.sh | bash
fi

# Make claude reachable in this non-interactive shell.
export PATH="$HOME/.local/bin:$PATH"

# --- marketplaces ----------------------------------------------------------
# claude-plugins-official is built in; only the third-party one must be added.
claude plugin marketplace add obra/superpowers || true

# --- plugins (scope: user) -------------------------------------------------
for plugin in \
    superpowers@superpowers-dev \
    clangd-lsp@claude-plugins-official \
    coderabbit@claude-plugins-official; do
    echo "installing plugin ${plugin}..."
    claude plugin install "${plugin}" --scope user || true
done

echo "claude code setup complete."
