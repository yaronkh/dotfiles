---
name: nvmesh_fetch_logs
description: Fetch and extract NVMesh CI/QA logs for a Jira ticket — looks up Jira, finds the Jenkins build or log path, SSHes to mtv1, and extracts the relevant .tgz archive(s) to ~/temp/<TICKET-ID>/
---

Fetch logs for the NVMesh Jira ticket provided in `args` (e.g. `NVMESH-1234`).

## Step 1 — Validate input

If `args` is empty or not a valid ticket ID matching `NVMESH-\d+`, stop immediately and say:

> Please provide a ticket ID, e.g. `/nvmesh_fetch_logs NVMESH-1234`

## Step 2 — Fetch the Jira ticket

Call `mcp__jira__jira_get_issue` with the ticket ID. Read the full description and all comments. Scan for a Jenkins job URL (typically a URL containing `jenkins` or `blossom`).

## Step 3 — Determine Case A or B

### Case A — Jenkins URL found

1. Call `mcp__MaaS-Blossom-Jenkins__get_build_details` with the Jenkins job URL.
2. Extract from the build details:
   - The collected logs directory path — must start with `/auto` (e.g. `/auto/nvmesh_jenkins/jenkins/logs/<uuid>/<uuid_1>`). **Use this path, not any path from the Jira description** — the Jira may be stale.
   - The failing node hostname (e.g. `nvme186`, `nvme1136`).
3. If `MaaS-Blossom-Jenkins` is unavailable, fall back: use `WebFetch` to fetch the Jenkins build page and extract the same two fields from the page content.

### Case B — No Jenkins URL

Read the logs directory path and failing node hostname directly from the Jira ticket description or comments. They are mentioned explicitly.

**In both cases:** if the logs path starts with `/data`, skip it and warn the user — `/data` paths are not accessible on mtv1.

## Step 4 — SSH to mtv1 and locate archives

Use Bash with `dangerouslyDisableSandbox: true`.

```bash
ssh mtv1 "sudo find <LOGS_DIR> -maxdepth 2 -name '*.tgz' | grep <NODE_HOSTNAME>"
```

If no `.tgz` matches, list all files in the directory so the user can decide:

```bash
ssh mtv1 "sudo ls -lh <LOGS_DIR>"
```

## Step 5 — Create local destination

```bash
mkdir -p ~/temp/<TICKET_ID>
```

## Step 6 — Stream archives to local machine and extract

For each matching `.tgz`, stream it from mtv1 directly to the local machine using `sudo cat` over SSH (avoids permission issues with scp), then extract locally.

```bash
ssh mtv1 "sudo cat <TGZ_PATH>" > ~/temp/<TICKET_ID>/<TGZ_FILENAME>
```

Then extract locally with `dangerouslyDisableSandbox: true`:

```bash
cd ~/temp/<TICKET_ID> && tar -xzf <TGZ_FILENAME>
```

## Step 7 — Report

Print a summary:

> Extracted `<TGZ_FILENAME>` to `~/temp/<TICKET_ID>/` locally.
> Path: `~/temp/<TICKET_ID>/<extracted_dir>/`

If multiple archives were extracted, list each one.
