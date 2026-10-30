# 🤖 Agent-Assisted Installation

Quetzal ships **no installer script**. You install it by asking an agent.

Copy the prompt below into any coding agent — OpenCode, Claude Code, Codex, Cursor, or anything else that can read files and edit configuration — and it does the setup for you.

---

## The prompt

```text
You are installing Quetzal and Kukulkán from https://github.com/RETBOT/quetzal.

Quetzal is an architect agent (writes code, reviews, plans).
Kukulkán is a cybersecurity mentor agent (read-only: teaches, never executes).

## Rules

1. Detect the client before doing anything: OpenCode, Claude Code, Codex, or other.
   If you can't tell, ask the user which one to configure.
2. Back up every config file you touch (`<file>.bak-<timestamp>`) before editing.
3. MERGE, never replace. Preserve the user's providers, models, MCP servers,
   permissions, themes, and unrelated agents.
4. Ask before overwriting an existing file or agent with the same name.
5. Never write secrets, API keys, or tokens. Never print them.
6. The paths below are current at the time this file was written. If one doesn't
   exist in the user's client version, check that client's current docs instead
   of guessing. Report any deviation.
7. When done, show the user a short table: what was installed, where, and how to verify.

## Step 1 — Get the files

Clone the repo to a temporary directory:

    git clone --depth 1 https://github.com/RETBOT/quetzal.git

Or read individual raw files from
`https://raw.githubusercontent.com/RETBOT/quetzal/main/<path>`.

The pieces that matter:

| Path | What it is |
|---|---|
| `quetzal/QUETZAL.md` | Quetzal system prompt (portable, no frontmatter) |
| `kukulkan/kukulkan.md` | Kukulkán system prompt (portable, no frontmatter) |
| `agents/sdd-*/agent.md` | 11 SDD sub-agent prompts (portable) |
| `skills/<name>/SKILL.md` | Skills: code-review, refactoring, sdd, testing |
| `workflows/*.md` | Optional workflow references |
| `presets/*.md` | Optional operating modes |

The prompts are client-agnostic. Only the wrapper changes per client.

## Step 2 — OpenCode (V2)

Config root: `~/.config/opencode` (`%USERPROFILE%\.config\opencode` on Windows).

### 2.1 Copy the prompts

    agent-defs/quetzal/QUETZAL.md
    agent-defs/kukulkan/kukulkan.md
    agent-defs/sdd-init/agent.md
    agent-defs/sdd-explore/agent.md
    agent-defs/sdd-propose/agent.md
    agent-defs/sdd-spec/agent.md
    agent-defs/sdd-design/agent.md
    agent-defs/sdd-tasks/agent.md
    agent-defs/sdd-apply/agent.md
    agent-defs/sdd-verify/agent.md
    agent-defs/sdd-archive/agent.md
    agent-defs/sdd-onboard/agent.md
    agent-defs/sdd-orchestrator/agent.md

### 2.2 Copy the skills

    skills/code-review/SKILL.md
    skills/refactoring/SKILL.md
    skills/sdd/SKILL.md
    skills/testing/SKILL.md

### 2.3 Merge into `opencode.json`

Add these entries under the existing `agents` key (create it if missing):

```json
{
  "agents": {
    "quetzal": {
      "system": "{file:./agent-defs/quetzal/QUETZAL.md}",
      "description": "Quetzal is a principal architect AI agent that brings discipline and strategic thinking to your development workflow.",
      "mode": "primary",
      "permissions": [
        { "action": "shell", "resource": "*", "effect": "allow" },
        { "action": "read", "resource": "*", "effect": "allow" },
        { "action": "edit", "resource": "*", "effect": "allow" },
        { "action": "subagent", "resource": "*", "effect": "allow" }
      ]
    },
    "kukulkan": {
      "system": "{file:./agent-defs/kukulkan/kukulkan.md}",
      "description": "Mentor de hacking ético y ciberseguridad; enseña paso a paso, diseña laboratorios autorizados y evalúa conocimientos.",
      "mode": "primary",
      "permissions": [
        { "action": "shell", "resource": "*", "effect": "deny" },
        { "action": "edit", "resource": "*", "effect": "deny" },
        { "action": "subagent", "resource": "*", "effect": "deny" },
        { "action": "external_directory", "resource": "*", "effect": "deny" },
        { "action": "websearch", "resource": "*", "effect": "ask" },
        { "action": "webfetch", "resource": "*", "effect": "ask" }
      ]
    }
  }
}
```

Add the SDD agents with the same shape:

| Agent | `mode` | `hidden` | Permissions |
|---|---|---|---|
| `sdd-init` | `subagent` | `true` | shell allow, read allow, edit deny |
| `sdd-explore` | `subagent` | `true` | read allow, edit deny |
| `sdd-propose` | `subagent` | `true` | read allow, edit deny |
| `sdd-spec` | `subagent` | `true` | read allow, edit deny |
| `sdd-design` | `subagent` | `true` | read allow, edit deny |
| `sdd-tasks` | `subagent` | `true` | read allow, edit deny |
| `sdd-apply` | `subagent` | `true` | shell allow, read allow, edit allow |
| `sdd-verify` | `subagent` | `true` | shell allow, read allow, edit deny |
| `sdd-archive` | `subagent` | `true` | read allow, edit deny |
| `sdd-onboard` | `subagent` | `true` | shell allow, read allow, edit allow |
| `sdd-orchestrator` | `primary` | `false` | shell allow, read allow, edit allow, subagent allow |

Each one uses `"system": "{file:./agent-defs/<agent>/agent.md}"` and a short
`description`. Do not set `temperature` or `tools` on V2 agents: those are V1
fields and are ignored.

### 2.4 Safety permissions (recommended)

Add to the top-level `permissions` array (last matching rule wins):

```json
[
  { "action": "shell", "resource": "*", "effect": "allow" },
  { "action": "shell", "resource": "git commit *", "effect": "ask" },
  { "action": "shell", "resource": "git push *", "effect": "ask" },
  { "action": "shell", "resource": "git rebase *", "effect": "ask" },
  { "action": "shell", "resource": "git reset --hard *", "effect": "ask" },
  { "action": "read", "resource": "*", "effect": "allow" },
  { "action": "read", "resource": "**/.env", "effect": "deny" },
  { "action": "read", "resource": "**/.env.*", "effect": "deny" },
  { "action": "read", "resource": "**/credentials.json", "effect": "deny" },
  { "action": "read", "resource": "**/secrets/**", "effect": "deny" }
]
```

### 2.5 MCP servers (optional)

```json
{
  "mcp": {
    "servers": {
      "context7": {
        "type": "remote",
        "url": "https://mcp.context7.com/mcp",
        "disabled": false
      },
      "engram": {
        "type": "local",
        "command": ["engram", "mcp", "--tools=agent"],
        "disabled": false
      }
    }
  }
}
```

Only add `engram` if the binary is installed (`engram --version`). If not, tell
the user and skip it; Quetzal works without it.

### 2.6 Verify

    opencode api get /api/agent

Every agent above must be listed with the right `mode` and `hidden`.
Then `opencode mcp list` must report the servers as connected.

## Step 3 — Claude Code

Prompts become **subagents** in `~/.claude/agents/<name>.md`. The body is the
prompt verbatim; the frontmatter is the wrapper.

`~/.claude/agents/quetzal.md`:

```markdown
---
name: quetzal
description: Principal software architect. Plans before coding, reviews critically, verifies its own changes.
tools: Read, Write, Edit, Bash, Glob, Grep, Agent, WebFetch, WebSearch
---

<content of quetzal/QUETZAL.md>
```

`~/.claude/agents/kukulkan.md`:

```markdown
---
name: kukulkan
description: Ethical hacking and cybersecurity mentor. Teaches step by step, read-only by design.
tools: Read, Glob, Grep, WebSearch, WebFetch
---

<content of kukulkan/kukulkan.md>
```

SDD sub-agents: same pattern, `tools: Read, Glob, Grep, Bash`, plus `Write, Edit`
for `sdd-apply` and `sdd-onboard`.

Skills go to `~/.claude/skills/<name>/SKILL.md`.

Notes:
- Every file under `agents/` is a subagent. To run Quetzal as the main session
  agent, use `claude --agent quetzal`.
- Do not overwrite the user's `~/.claude/CLAUDE.md`. If they want Quetzal rules
  globally, ask first and append a short reference instead of pasting the prompt.

## Step 4 — Codex

Custom agents are standalone TOML files in `~/.codex/agents/<name>.toml`.

`~/.codex/agents/quetzal.toml`:

```toml
name = "quetzal"
description = "Principal software architect. Plans before coding, reviews critically, verifies its own changes."
model_reasoning_effort = "high"
developer_instructions = """
<content of quetzal/QUETZAL.md>
"""
```

`~/.codex/agents/kukulkan.toml` — reduce capabilities instead of writing
permissions, because custom agents inherit the parent's sandbox:

```toml
name = "kukulkan"
description = "Ethical hacking and cybersecurity mentor. Teaches step by step, read-only by design."
features.shell_tool = false
features.request_permissions_tool = false
developer_instructions = """
<content of kukulkan/kukulkan.md>
"""
```

SDD sub-agents: same pattern. Disable `features.shell_tool` for the read-only
ones (`sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`,
`sdd-archive`).

Skills go to `~/.agents/skills/<name>/SKILL.md`.

MCP goes in `~/.codex/config.toml`:

```toml
[mcp_servers.context7]
url = "https://mcp.context7.com/mcp"

[mcp_servers.engram]
command = "engram"
args = ["mcp", "--tools=agent"]
```

Do not put the prompt in `~/.codex/AGENTS.md`; that file is for project-wide
rules and would make every session Quetzal.

## Step 5 — Any other client

The prompts are portable Markdown. Whatever the client is:

1. Put `quetzal/QUETZAL.md` or `kukulkan/kukulkan.md` in the client's
   agent/persona/prompt location, verbatim.
2. Map the client's tool names to the ones used in the prompt (shell, read,
   edit, subagent, web). If a tool doesn't exist, say so in the prompt wrapper
   instead of inventing one.
3. Add the safety rules the client supports (deny reads of `.env`, ask before
   `git push`).
4. Tell the user which capabilities the client can't honor.

## Step 6 — Project rules

Per project, create an `AGENTS.md` (OpenCode, Codex) or `CLAUDE.md` (Claude Code)
with the stack, conventions, and test commands. Quetzal reads it and it wins over
the global prompt for operational details. Keep it short and project-specific.

## Step 7 — Report

Finish with:

    Installed: <agents>, <skills>, <mcp servers>
    Config files changed: <paths> (backups: <paths>)
    Verify with: <commands>
    Not installed / not supported: <anything skipped and why>
```

---

## Why not a script?

A script has to know every client's config format, and those formats change. An
agent can read the current docs, detect what's already installed, merge instead of
overwrite, and explain what it did. That is the whole point of Quetzal.

---

## Manual installation

If you prefer to do it by hand, the tables above are the complete mapping. The
only non-obvious part is that `agent-defs/` holds prompt bodies with no
frontmatter: the metadata lives in `opencode.json`, so there is one source of
truth for permissions.
