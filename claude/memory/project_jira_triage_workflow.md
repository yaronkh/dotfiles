---
name: jira-triage-workflow
description: Step-by-step procedure to follow whenever the user brings a Jira ticket for triage
metadata:
  type: project
---

When the user provides a Jira ticket (e.g. NVMESH-8885), follow these steps in order:

1. **Open the Jira ticket** via the REST API (`jirasw.nvidia.com`) and check if there is a Jenkins job URL in the description or comments.

**Case A — Jenkins job exists (CI failure):**

2. **Open the Jenkins job** via the MaaS-Blossom-Jenkins MCP (`get_build_details`) and extract:
   - The collected logs directory from the Jenkins badge (e.g. `/auto/nvmesh_jenkins/jenkins/logs/<uuid>/<uuid_1>`). **Always use the path from Jenkins, not from the Jira description** — the Jira may have a different/stale path.
   - Which node(s) caused the failure (from the error message, e.g. `nvme186.mtl.nbulabs.nvidia.com`)

**Case B — No Jenkins job (manual QA test failure):**

2. **Read the Jira ticket** to extract the logs directory and failing node directly from the ticket description/comments. These will be mentioned explicitly in the ticket.

3. **SSH to mtv1** and use `sudo` to navigate to the logs directory. Find all files whose name starts with or includes the failing node's hostname (e.g. `nvme1136`).
   - **IMPORTANT:** Only use log paths that start with `/auto` on mtv1. Ignore any paths starting with `/data` — those are not accessible.

4. **Create a directory** named after the Jira ticket under `/home/ykahanovitch/temp/` (e.g. `/home/ykahanovitch/temp/NVMESH-8885`).

5. **Copy and extract** the relevant `.tgz` file(s) into that directory.

**Why:** This is the user's standard CI failure triage procedure — go from Jira → Jenkins → logs → local extraction for analysis.

**How to apply:** Any time the user says "I have a Jira" or pastes a Jira URL, immediately start this workflow without waiting to be asked.
