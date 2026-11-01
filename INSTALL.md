# 🤖 Agent-Assisted Installation

Quetzal ships **no installer script**. You install it by asking an agent.

Copy the prompt below into any coding agent — OpenCode, Claude Code, Codex, Cursor, or anything else that can read files and edit configuration — and it does the setup for you.

---

## The prompt

```text
You are installing Quetzal and Kukulkán from https://github.com/RETBOT/quetzal.

Quetzal is an architect agent (writes code, reviews, plans).
Kukulkán is a cybersecurity mentor agent (read-only: teaches, never executes).
They are backed by two read-only helpers: codebase-explorer and independent-reviewer.

This repository is on the v2.1 architecture: two principal agents, two scoped
helpers, and skills loaded on demand. Do NOT install the legacy `sdd-*` agents or
the `sdd` skill unless I explicitly ask for them. Read docs/v2.1/MIGRATION.md and
docs/v2.1/LEGACY-SDD-RETIREMENT.md before you start.

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
| `agents/codebase-explorer/agent.md` | Read-only recon helper (portable) |
| `agents/independent-reviewer/agent.md` | Read-only review helper (portable) |
| `agents/sdd-*/agent.md` | 11 legacy SDD sub-agent prompts — see `docs/v2.1/LEGACY-SDD-RETIREMENT.md` |
| `skills/<name>/SKILL.md` | 17 active skills (4 general, 4 .NET, 4 web, 5 security) + `sdd` as legacy |
| `workflows/*.md` | Workflow references, including the active `engineering-loop.md` |
| `presets/*.md` | Optional operating modes |

The prompts are client-agnostic. Only the wrapper changes per client.

## Step 2 — OpenCode (V2)

Config root: `~/.config/opencode` (`%USERPROFILE%\.config\opencode` on Windows).

### 2.1 Copy the prompts

    agent-defs/quetzal/QUETZAL.md
    agent-defs/kukulkan/kukulkan.md
    agent-defs/codebase-explorer/agent.md
    agent-defs/independent-reviewer/agent.md

### 2.2 Copy the skills

    skills/code-review/SKILL.md
    skills/refactoring/SKILL.md
    skills/engineering-flow/SKILL.md
    skills/testing/SKILL.md
    skills/dotnet-efcore/SKILL.md
    skills/dotnet-maui/SKILL.md
    skills/dotnet-windows-forms/SKILL.md
    skills/aspnet-mvc/SKILL.md
    skills/react-frontend/SKILL.md
    skills/devextreme/SKILL.md
    skills/javascript-web/SKILL.md
    skills/api-design/SKILL.md
    skills/network-analysis/SKILL.md
    skills/web-api-pentest/SKILL.md
    skills/vulnerability-triage/SKILL.md
    skills/llm-security/SKILL.md
    skills/security-lab-design/SKILL.md

`dotnet-windows-forms` also needs its `references/` folder copied alongside `SKILL.md`,
or the skill will point at files that don't exist.

Optional, legacy only — skip unless the user explicitly wants the old SDD chain:

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
    skills/sdd/SKILL.md

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
    },
    "codebase-explorer": {
      "system": "{file:./agent-defs/codebase-explorer/agent.md}",
      "description": "Read-only reconnaissance helper: returns paths, lines, flow and dependencies. Never implements.",
      "mode": "subagent",
      "hidden": false,
      "permissions": [
        { "action": "read", "resource": "*", "effect": "allow" },
        { "action": "shell", "resource": "*", "effect": "deny" },
        { "action": "edit", "resource": "*", "effect": "deny" },
        { "action": "subagent", "resource": "*", "effect": "deny" },
        { "action": "external_directory", "resource": "*", "effect": "deny" }
      ]
    },
    "independent-reviewer": {
      "system": "{file:./agent-defs/independent-reviewer/agent.md}",
      "description": "Read-only review helper: returns findings without fixing them.",
      "mode": "subagent",
      "hidden": false,
      "permissions": [
        { "action": "shell", "resource": "*", "effect": "deny" },
        { "action": "shell", "resource": "git diff *", "effect": "allow" },
        { "action": "shell", "resource": "git status *", "effect": "allow" },
        { "action": "read", "resource": "*", "effect": "allow" },
        { "action": "edit", "resource": "*", "effect": "deny" },
        { "action": "subagent", "resource": "*", "effect": "deny" },
        { "action": "external_directory", "resource": "*", "effect": "deny" }
      ]
    }
  }
}
```

> **Rule order matters.** V2 evaluates permissions in order and the last matching rule
> wins, so the two `git` allows must come **after** the catch-all `shell` deny.
> Confirm the precedence in the installed version before trusting it (see
> `docs/v2.1/MIGRATION.md`, section 5).

Legacy SDD agents are **not** part of the v2.1 install. If the user explicitly wants
them, add them with the same shape using this table:

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

Quetzal must be able to invoke `kukulkan`, `codebase-explorer` and
`independent-reviewer`. There must be **no** permission granting
`sdd-orchestrator` in a v2.1 install.

> **Por qué `hidden: false` en los helpers.** La documentación upstream llama a
> estos helpers "agentes ocultos" (`hidden: true`), pero en OpenCode v2.2.5 un
> agente `hidden: true` desaparece por completo del catálogo que usa la tool
> `subagent`: ni siquiera puede ser lanzado por ID cuando el agente padre lo nombra
> en su prompt. Así, con `hidden: true`, Quetzal delegará silenciosamente al
> agente built-in `explore` en lugar del helper. Se verificó empíricamente. Usar
> `hidden: false` mantiene la restricción de no aparecer en el ciclo de agentes
> principales (eso lo garantiza `mode: subagent`), mientras los hace
> descubribles como subagentes. Si en una versión futura `hidden: true` deja de
> excluir del catálogo de delegación, se puede volver al `hidden: true`.

Todo agente usa `"system": "{file:./agent-defs/<agent>/agent.md}"` y una short
`description`. No pongas `temperature` ni `tools` en agentes V2; son campos V1
que se ignoran.

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

Helper subagents: same pattern, but their tool list is **read-only by construction**.

`~/.claude/agents/codebase-explorer.md`:

```markdown
---
name: codebase-explorer
description: Read-only codebase reconnaissance. Returns paths, lines, flow and dependencies. Never implements.
tools: Read, Glob, Grep
---
```

`~/.claude/agents/independent-reviewer.md`:

```markdown
---
name: independent-reviewer
description: Read-only independent review of a change. Returns findings without fixing them.
tools: Read, Glob, Grep, Bash
---
```

For `independent-reviewer`, `Bash` exists only to run `git diff` and `git status`.
Claude Code has no per-command tool filter in the agent frontmatter, so **check the
global `settings.json` permissions** and confirm the effective allow-list covers only
those two commands. If you can't confirm it, drop `Bash` entirely — the reviewer can
still read files, just not the diff.

Legacy SDD sub-agents, only if explicitly requested: `tools: Read, Glob, Grep, Bash`,
plus `Write, Edit` for `sdd-apply` and `sdd-onboard`.

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

Helper subagents: same pattern. Disable `features.shell_tool` on both — Codex custom
agents inherit the parent's sandbox, so a role definition is not a security boundary
by itself. For audit work, run the parent session with a `read-only` sandbox.

```toml
name = "codebase-explorer"
description = "Read-only codebase reconnaissance. Returns paths, lines, flow and dependencies. Never implements."
features.shell_tool = false
features.request_permissions_tool = false
developer_instructions = """
<content of agents/codebase-explorer/agent.md>
"""
```

```toml
name = "independent-reviewer"
description = "Read-only independent review of a change. Returns findings without fixing them."
features.shell_tool = false
features.request_permissions_tool = false
developer_instructions = """
<content of agents/independent-reviewer/agent.md>
"""
```

Without `shell_tool` the reviewer cannot run `git diff`, so you must paste the diff
into the request. Say so in the report instead of implying it inspected the change.

Legacy SDD sub-agents, only if explicitly requested: same pattern, disabling
`features.shell_tool` for the read-only ones (`sdd-explore`, `sdd-propose`,
`sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-archive`).

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
