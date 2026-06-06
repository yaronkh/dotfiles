#!/usr/bin/env python
"""Open the NVMesh management UI on nvme31 in a visible Chrome window and log in.

Uses Playwright driving the system Chrome (channel="chrome") with an isolated
persistent profile so it does NOT merge into / get killed by the user's already
running Chrome session. Keeps the window open after login.

Requires: pyenv `nvim` venv (has playwright). Must be run with the Claude
sandbox disabled (nvme31 is not allowlisted; Chrome also needs profile + socket
access).
"""
import os
import time

from playwright.sync_api import sync_playwright

URL = os.environ.get("MGMT_URL", "http://nvme31:4000/login")
USER = os.environ.get("MGMT_USER", "admin")
PASSWORD = os.environ.get("MGMT_PASSWORD", "admin")
PROFILE = os.environ.get("MGMT_PROFILE", "/tmp/claude/nvme31_chrome_profile")
KEEP_OPEN_SECONDS = int(os.environ.get("MGMT_KEEP_OPEN", "7200"))

p = sync_playwright().start()
ctx = p.chromium.launch_persistent_context(
    PROFILE,
    channel="chrome",
    headless=False,
    no_viewport=True,
    args=["--no-sandbox", "--disable-dev-shm-usage", "--start-maximized"],
)
page = ctx.pages[0] if ctx.pages else ctx.new_page()
page.goto(URL, wait_until="domcontentloaded", timeout=30000)
page.wait_for_timeout(1500)

for sel in ['input[name*="user" i]', 'input[id*="user" i]',
            'input[type="text"]', 'input[type="email"]']:
    if page.locator(sel).count() > 0:
        page.locator(sel).first.fill(USER)
        break
for sel in ['input[type="password"]']:
    if page.locator(sel).count() > 0:
        page.locator(sel).first.fill(PASSWORD)
        break
for sel in ['button[type="submit"]', 'input[type="submit"]',
            'button:has-text("Login")', 'button:has-text("Sign In")', 'button']:
    if page.locator(sel).count() > 0:
        page.locator(sel).first.click()
        break

try:
    page.wait_for_timeout(5000)
    print("logged in, final url:", page.url, flush=True)
except Exception as e:  # noqa: BLE001
    print("post-login wait error:", e, flush=True)

print(f"keeping browser open for {KEEP_OPEN_SECONDS}s...", flush=True)
time.sleep(KEEP_OPEN_SECONDS)
