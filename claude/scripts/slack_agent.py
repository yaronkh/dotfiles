#!/usr/bin/env python3
"""
Claude Slack Agent — listens for @mentions and DMs, runs claude -p, replies in thread.
"""

import os
import re
import subprocess
import threading
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler

SLACK_BOT_TOKEN = os.environ["SLACK_BOT_TOKEN"]
SLACK_APP_TOKEN = os.environ["SLACK_APP_TOKEN"]
CLAUDE_TIMEOUT = int(os.getenv("CLAUDE_TIMEOUT", "300"))  # seconds

app = App(token=SLACK_BOT_TOKEN)


def strip_mention(text: str) -> str:
    return re.sub(r"<@[A-Z0-9]+>", "", text).strip()


def run_claude(task: str) -> str:
    try:
        result = subprocess.run(
            ["claude", "-p", task, "--dangerously-skip-permissions"],
            capture_output=True,
            text=True,
            timeout=CLAUDE_TIMEOUT,
            env={**os.environ},
        )
        output = result.stdout.strip()
        if result.returncode != 0 and not output:
            output = result.stderr.strip() or "Claude exited with no output."
        return output or "Done (no output)."
    except subprocess.TimeoutExpired:
        return f"Timed out after {CLAUDE_TIMEOUT}s."
    except Exception as e:
        return f"Error running Claude: {e}"


def handle_task(say, channel, thread_ts, task):
    say(text=":hourglass_flowing_sand: Working on it...", channel=channel, thread_ts=thread_ts)
    result = run_claude(task)
    # Slack message limit is 3000 chars per block
    if len(result) > 2900:
        result = result[:2900] + "\n…(truncated)"
    say(text=result, channel=channel, thread_ts=thread_ts)


@app.event("app_mention")
def on_mention(event, say):
    task = strip_mention(event.get("text", ""))
    if not task:
        say(text="What would you like me to do?", thread_ts=event["ts"])
        return
    thread_ts = event.get("thread_ts") or event["ts"]
    t = threading.Thread(target=handle_task, args=(say, event["channel"], thread_ts, task), daemon=True)
    t.start()


@app.event("message")
def on_dm(event, say):
    # Only handle DMs (channel_type == "im"), ignore bot messages
    if event.get("channel_type") != "im" or event.get("bot_id"):
        return
    task = event.get("text", "").strip()
    if not task:
        return
    thread_ts = event.get("thread_ts") or event["ts"]
    t = threading.Thread(target=handle_task, args=(say, event["channel"], thread_ts, task), daemon=True)
    t.start()


if __name__ == "__main__":
    print("Starting Claude Slack Agent...")
    handler = SocketModeHandler(app, SLACK_APP_TOKEN)
    handler.start()
