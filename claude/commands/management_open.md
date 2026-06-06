---
description: Open the NVMesh management UI on nvme31 in a visible browser, logged in as admin
allowed-tools: Bash
---

Open the NVMesh management web UI (`http://nvme31:4000`) in a **visible** Chrome
window and log in as `admin`/`admin`.

Run the script below with the **Bash tool**, and you MUST set
`dangerouslyDisableSandbox: true` — `nvme31` is not in the network allowlist, and
Chrome additionally needs to write its profile and create sockets, all of which
the sandbox blocks. Launch it in the background (it intentionally stays alive to
keep the window open).

The pyenv `nvim` venv has Playwright installed; activate it first. Playwright
drives the system `google-chrome` (`channel="chrome"`) with an isolated profile,
so it won't collide with any already-running Chrome session.

```bash
export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)" 2>/dev/null; eval "$(pyenv virtualenv-init -)" 2>/dev/null
pyenv activate nvim 2>/dev/null
rm -rf /tmp/claude/nvme31_chrome_profile
nohup python -u "$HOME/.claude/scripts/nvme31_management_open.py" \
  >/tmp/claude/management_open.log 2>&1 &
disown
sleep 14
echo "--- log ---"; cat /tmp/claude/management_open.log
```

After it runs, confirm the log shows `logged in, final url: http://nvme31:4000/`
(redirected away from `/login` = success) and tell the user the window is open.
Overrides via env vars if needed: `MGMT_URL`, `MGMT_USER`, `MGMT_PASSWORD`.
