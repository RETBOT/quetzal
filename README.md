<div align="center">

<img src="quetzal.png" alt="Quetzal Logo" width="200">

# 🧠 Quetzal

**AI Architect Agent for OpenCode, Claude Code, Codex, and any agent-capable client**

[![Clients](https://img.shields.io/badge/clients-OpenCode%20%7C%20Claude%20Code%20%7C%20Codex-blue)](INSTALL.md)
[![Install](https://img.shields.io/badge/install-agent--assisted-green)](INSTALL.md)
[![Engram](https://img.shields.io/badge/Engram-Persistent%20Memory-purple)](https://github.com/Gentleman-Programming/engram)
[![Context7](https://img.shields.io/badge/Context7-Library%20Docs-orange)](https://context7.com)
[![License](https://img.shields.io/badge/license-MIT-yellow)](LICENSE)

*Think before you code. Architect before you build.*

**🚀 Inspired by [Gentleman AI](https://github.com/Gentleman-Programming/gentle-ai)**

</div>

---

## ✨ What is Quetzal?

Quetzal is a **principal architect AI agent** that brings discipline and strategic thinking to your development workflow. Unlike agents that over-eagerly jump to implementation, Quetzal:

- 🎯 **Challenges assumptions** — Questions your approach before committing
- 📐 **Designs first** — Architects solutions before writing code
- 🔍 **Reviews critically** — Analyzes and improves existing code
- ⚖️ **Acts with judgment** — Autonomous when it can be, prudent when it must be
- 🧩 **Avoids dogma** — Applies patterns only when they solve a real problem, not by default
- 🚀 **Optimizes for scale** — Builds systems that grow gracefully

### Philosophy

> **Think first, then act — and verify what you change.**

Quetzal doesn't just write code — it helps you build the *right* thing, the *right* way. It asks only the questions that change the outcome, and verifies its own work before claiming success.

---

## 🐍 Kukulkán — Cybersecurity Mentor

<div align="center">
<img src="kukulkan.png" alt="Kukulkán" width="200">
</div>

Kukulkán is Quetzal's companion agent: an **ethical hacking and cybersecurity mentor**. Where Quetzal builds, Kukulkán teaches. It walks you through fundamentals step by step and never runs commands on your behalf.

- 🎓 **Teaches, doesn't execute** — shell is denied by design; it explains each command and lets you decide whether to run it
- 🧪 **Authorized labs only** — OWASP Juice Shop, isolated VMs, deliberately vulnerable apps
- 🕵️ **Privacy and anonymity** — VPN, proxies, Tor, DNS leaks, cookies, fingerprinting, and their real limits
- 🛡️ **Blue team too** — logs, detection, forensics, incident response
- 🤖 **AI security** — prompt injection, jailbreaks, RAG and agent tooling risks

**Study modes** (conversational shortcuts, not terminal commands):

| Shortcut | What it does |
|----------|--------------|
| `/aprender tema` | Explain from fundamentals with guided practice |
| `/practica tema` | Lab with objective, scope, steps, evidence and cleanup |
| `/quiz tema` | One question at a time; waits for your answer |
| `/repasar` | Review and detect gaps |
| `/ruta` | Current unit, prerequisites, next milestones |
| `/analizar archivo` | Analyze material you provide, keeping its terminology |
| `/cve ID` | Affected products, sources, CWE/CVSS, impact, mitigation |
| `/informe` | Reproducible report with sanitized evidence |
| `/continuar` | Resume from available progress |

**Guardrails:** no access to third-party systems, no credential theft, no malware, no exfiltration of real data, no hiding an intrusion. If scope isn't clear, it asks and offers a local simulation instead.

**Permissions:** `read` allowed · `shell`, `edit`, `subagent`, `external_directory` denied · `websearch`, `webfetch` ask.

> *"Primero entender, después automatizar."*

---

## 🚀 Quick Start

There is **no installer script**. You install Quetzal by asking an agent to do it.

Open your coding agent — OpenCode, Claude Code, Codex, Cursor, or any other client
that can read files and edit configuration — and paste this:

```text
Install Quetzal and Kukulkán in this client.

Repository: https://github.com/RETBOT/quetzal
Follow the installation prompt at INSTALL.md in that repository, step by step.

Rules:
- Detect which client I'm using and follow only that client's section.
- Back up every config file before editing it.
- Merge into my existing config; never replace providers, models, MCP servers,
  permissions, or unrelated agents.
- Ask before overwriting anything with the same name.
- When done, show me a table of what was installed, where, and how to verify it.
```

The agent clones the repo, copies the prompts, merges the agent entries into your
client's config, and verifies the result. It reads the current docs for your client
version instead of guessing paths.

### What gets installed

| Piece | What it is |
|---|---|
| 🦜 **Quetzal** | Architect agent — plans, builds, reviews, verifies |
| 🐍 **Kukulkán** | Cybersecurity mentor — read-only, teaches step by step |
| 🧩 **11 SDD agents** | Spec-Driven Development sub-agents + orchestrator |
| 🎯 **4 skills** | `code-review`, `refactoring`, `sdd`, `testing` |
| 💾 **Engram** *(optional)* | Persistent memory across sessions |
| 📚 **Context7** *(optional)* | Up-to-date library documentation |

### The installation prompt

[`INSTALL.md`](INSTALL.md) holds the full prompt: per-client steps for OpenCode V2,
Claude Code, and Codex, plus guidance for any other client. Point your agent at that
file — or paste it whole — and it does the work.

It works because an agent can read your current config, detect what's already
installed, merge instead of overwrite, and explain what it changed. A shell script
can't do that for every client without breaking every time a config format changes.

---

## 🧩 Complete Ecosystem

Quetzal comes with a complete AI development ecosystem, inspired by [Gentleman AI](https://github.com/Gentleman-Programming/gentle-ai):

### 🧠 Quetzal Agent
The core architect agent that brings discipline to your coding workflow.

**Features:**
- Adaptive workflow: THINK → EXPLORE → PLAN → BUILD → VERIFY → REVIEW
- Acts autonomously when appropriate, asks only when it matters
- Detects overengineering and technical debt without dogmatic patterns
- Verifies its own changes (tests/build/lint) before declaring success
- Explicit security, Git, and evidence-based debugging policies

### 🐍 Kukulkán Agent
The companion mentor agent for ethical hacking and cybersecurity. Read-only by design: it teaches and reviews, never executes.

**Features:**
- Progressive curriculum: systems, networking, privacy, pentesting, CVEs, blue team, AI security
- Guided labs with explicit scope and authorization checks
- Manual-first pedagogy: understand the procedure before touching a tool
- `/aprender`, `/practica`, `/quiz`, `/repasar`, `/ruta`, `/cve`, `/informe` study modes

### 💾 Engram (Persistent Memory)
[Engram](https://github.com/Gentleman-Programming/engram) remembers decisions, bugs, and context across sessions.

**What it does:**
- Saves architectural decisions automatically
- Remembers bugs and how you fixed them
- Maintains project context across sessions
- Syncs memories via git (share with your team!)

**Commands:**
```bash
engram tui              # Browse memories visually
engram search "auth"    # Find past decisions
engram sync             # Export to git
```

### 📚 Context7 (Library Documentation)
[Context7](https://context7.com) provides up-to-date documentation for any library.

**What it does:**
- Fetches latest docs for React, Next.js, any library
- No more outdated training data
- Code examples from the source
- Works with any version you specify

**How to use:**
Just ask Quetzal anything about a library:
```
"How do I configure Next.js middleware?"
"Show me Supabase auth API examples"
"What's the new React 19 feature?"
```

### 🎯 Skills (Specializations)
Quetzal includes specialized **skills** in the native OpenCode format (`SKILL.md` with YAML frontmatter). OpenCode discovers them automatically from the skills directories — no manual triggers needed.

| Skill | Frontmatter `name` | When to use |
|-------|--------------------|-------------|
| **🔍 code-review** | `code-review` | "Review this code" |
| **🔨 refactoring** | `refactoring` | "Refactor this", "simplify this" |
| **📋 sdd** | `sdd` | "Plan a feature", "design this" |
| **🧪 testing** | `testing` | "Run tests", "TDD", "coverage" |

Quetzal invokes the matching skill with the `skill` tool based on its `description`.

Skills live in `/skills/<name>/SKILL.md` and are customizable. On install they are copied to `~/.config/opencode/skills/` for global discovery.

### 🚀 Project Commands (Essential Pack)
Commands that configure and manage your project:

```bash
./commands/project-init      # Initialize project with Quetzal
./commands/sdd-init          # Detect stack and configure SDD
./commands/skill-registry    # Scan and register available skills
```

**Usage example:**
```bash
cd my-project
../quetzal/commands/project-init    # Configure Quetzal
../quetzal/commands/sdd-init        # Detect React/Node/etc
../quetzal/commands/skill-registry  # Register skills
```

### 📋 Workflows (Work Flows)
Predefined workflows for common situations:

| Workflow | Description | File |
|----------|-------------|---------|
| **feature-workflow** | Create new feature with full SDD | `workflows/feature-workflow.md` |
| **bugfix-workflow** | Fix bugs with root cause analysis | `workflows/bugfix-workflow.md` |
| **refactor-workflow** | Safe refactoring step by step | `workflows/refactor-workflow.md` |
| **pr-workflow** | Create and review Pull Requests | `workflows/pr-workflow.md` |

### 🎛️ Presets (Operating Modes)
Presets for different contexts:

| Preset | Description | When to use |
|--------|-------------|-------------|
| **strict-mode** | Maximum rigor (80% coverage, SDD required) | Enterprise, critical code |
| **fast-mode** | Agile and pragmatic (60% coverage, flexible) | MVPs, prototypes |
| **team-mode** | Balanced with team conventions | Teams 3-10 devs |

**Change preset:**
```bash
# In .quetzal/config.json
{
  "mode": "strict"  # or "fast", "team"
}
```

---

## 📋 Requirements

| Tool | Required | For | Notes |
|------|----------|-----|-------|
| **An agent** | ✅ Yes | Installation | OpenCode, Claude Code, Codex, or any client that can read files and edit config |
| **Git** | ✅ Yes | Installation | For cloning the repository |
| **Node.js** | ⚪ Optional | Context7 | `npm install -g @upstash/context7-mcp` |
| **Go** | ⚪ Optional | Engram | Build from source |

### Optional Components

**Without Node.js:** Context7 won't install, but Quetzal works fine
**Without Go:** Engram won't install, but Quetzal works fine

Both are **optional** — Quetzal functions as a standalone agent.

---

## 🎭 How Quetzal Decides

Quetzal adapts behavior based on task type and risk. It acts autonomously when it can
and asks for confirmation only when it should.

| Task type | Quetzal behavior |
|-----------|------------------|
| Conversation / analysis / review / research | No file changes, analyzes and responds |
| Trivial change (typo, rename, 1-line fix, docs) | Acts directly if intent is obvious, then verifies |
| Small-moderate change, clearly requested | Acts directly, verifies, reports what changed |
| Relevant / architectural / multi-file | Brief plan; medium risk proceeds with verification, high risk asks confirmation |
| Explicit implementation request | Implements and verifies, no re-asking |
| Debugging | Evidence-based workflow, fixes when root cause is clear |
| Refactoring | Safe and incremental with tests; asks if large or no tests |

**Risk levels:** **Low** (local, reversible) → act. **Medium** (logic, multi-file) → act if intent is clear, verify. **High** (destructive, irreversible, secrets, mass, production) → confirm.

### Example Interactions

```
User: "Plan an authentication system"
Quetzal: Understands, explores, presents a brief plan with real alternatives,
         and asks only the questions that change the implementation

User: "Build the auth module"
Quetzal: Implements and verifies. Doesn't re-ask for permission.

User: "Review this code"
Quetzal: Analyzes, suggests improvements, flags issues. Doesn't modify files.

User: "Fix this typo in the README"
Quetzal: Fixes it directly and confirms what changed.

User: "How do I use React useEffect?"
Quetzal: Consults Context7 only if the API/version matters, or explains from knowledge.

User: "Remember we decided to use TypeScript strict"
Quetzal: Saves the architectural decision to Engram.
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    OpenCode IDE                             │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐    ┌─────────────────┐    ┌──────────────┐
│   Quetzal    │    │     Engram      │    │   Context7   │
│   Agent      │    │  (Memory)       │    │   (Docs)     │
├──────────────┤    ├─────────────────┤    ├──────────────┤
│ QUETZAL.md   │    │ ~/.engram/      │    │ context7.com │
│ Architect    │    │ SQLite          │    │ MCP Server   │
│ Mentor       │    │ Persistent      │    │ Latest docs  │
└──────────────┘    └─────────────────┘    └──────────────┘
```

### Project Structure

```
quetzal/
├── quetzal/
│   └── QUETZAL.md              # Architect agent behavior (compact prompt)
├── kukulkan/
│   └── kukulkan.md             # Cybersecurity mentor prompt
├── quetzal.png                 # Quetzal logo
├── kukulkan.png                # Kukulkán logo
├── skills/
│   ├── code-review/SKILL.md    # Native OpenCode skills
│   ├── refactoring/SKILL.md
│   ├── sdd/SKILL.md
│   └── testing/SKILL.md
├── agents/                     # SDD sub-agents (sdd-*)
├── commands/                   # project-init, sdd-init, skill-registry
├── workflows/                  # feature, bugfix, refactor, pr
├── presets/                    # strict, fast, team
├── INSTALL.md                  # Installation prompt for agents (all clients)
└── README.md                   # This file
```

Per project, `./commands/project-init` also generates an `AGENTS.md` with the
project's own rules (stack, conventions, tests) — separate from the agent prompt.

---

## 🔄 Updates

Updates work the same way as installation: ask an agent.

```text
Update my Quetzal installation from https://github.com/RETBOT/quetzal.

Compare the repo's agent prompts and skills against what I have installed,
show me what changed, then apply the updates to the same paths.
Back up the config before touching it and keep my local customizations.
```

The agent pulls the latest prompts, diffs them against your installed copies, and
merges the changes. Because your customizations live in the installed files and your
`AGENTS.md`, it can tell the difference between upstream changes and your own edits —
which a blind overwrite cannot.

### What an update covers

- ✅ Quetzal and Kukulkán prompts
- ✅ SDD agents and skills
- ✅ Agent entries in your client's config
- ⚪ Engram and Context7 (only if you ask it to upgrade the binaries)

---

## 🛠️ Troubleshooting

<details>
<summary>❌ The agent didn't install anything</summary>

Most likely it couldn't detect the client or the config root. Tell it explicitly:

```text
I'm using <OpenCode / Claude Code / Codex>. My config lives at <path>.
Install Quetzal following INSTALL.md from https://github.com/RETBOT/quetzal
```

If the client isn't covered by `INSTALL.md`, ask the agent to map the prompt to that
client's agent/persona location and to report which capabilities it can't honor.
</details>

<details>
<summary>❌ Agents don't show up after installing</summary>

Configs are read at startup. Restart the client, then verify:

- **OpenCode:** `opencode api get /api/agent` — every agent must be listed with the
  right `mode` and `hidden`.
- **Claude Code:** `/agents` inside a session.
- **Codex:** the agent files must be under `~/.codex/agents/`.

If the agent edited the config but the client ignores it, check that it merged into
the correct key for your version — V2 uses `agents`, not `agent`.
</details>

<details>
<summary>⚠️ Context7 not working</summary>

**Install Node.js first:**
- **Windows:** https://nodejs.org/ (LTS version)
- **macOS:** `brew install node`
- **Linux:** `sudo apt install nodejs npm`

Then install the server:
```bash
npm install -g @upstash/context7-mcp
```

Ask the agent to add it to your client's MCP config, or see
[Manual Configuration](#manual-configuration).
</details>

<details>
<summary>⚠️ Engram not working</summary>

**Install Go first:**
- All platforms: https://go.dev/dl/

Then build it:
```bash
git clone https://github.com/Gentleman-Programming/engram.git
cd engram && go build -o ~/.local/bin/engram ./cmd/engram
```

Confirm with `engram --version` before asking the agent to wire it up. Quetzal works
without Engram — you only lose persistent memory.
</details>

<details>
<summary>⚠️ The agent overwrote part of my config</summary>

It shouldn't — `INSTALL.md` requires a backup before every edit. Look for
`<config>.bak-<timestamp>` next to the original and restore it.

Then re-run the installation, telling the agent explicitly to merge instead of
replace. If it happens again, install manually with
[Manual Configuration](#manual-configuration).
</details>

<details>
<summary>⚠️ Which agent is active?</summary>

- **OpenCode:** `Tab` or `/agent` cycles primary agents; `quetzal`, `kukulkan` and
  `sdd-orchestrator` are the visible ones.
- **Claude Code:** `claude --agent quetzal` starts a session as Quetzal; otherwise
  they're subagents invoked by description.
- **Codex:** pick the agent when starting the session.

Prompt changes apply to **new sessions only**. Restart the session to see them.
</details>

---

## 🔧 Changes and Modifications

This section documents customizations made on top of Gentleman AI base.

### SDD Agent Structure

11 SDD agents (Spec-Driven Development) were implemented for structured workflow:

| Agent | Purpose |
|--------|-----------|
| `sdd-init` | Detect stack, testing, and project conventions |
| `sdd-explore` | Explore codebase and investigate ideas |
| `sdd-propose` | Create structured change proposals |
| `sdd-spec` | Write detailed technical specifications |
| `sdd-design` | Create architecture and design documents |
| `sdd-tasks` | Break down specifications into tasks |
| `sdd-apply` | Implement code changes |
| `sdd-verify` | Validate implementation against specifications |
| `sdd-archive` | Archive completed changes and persist state |
| `sdd-onboard` | Guide user through full SDD cycle |
| `sdd-orchestrator` | Coordinate SDD workflows delegating to sub-agents |

### SDD Agent Configuration

SDD agents are mostly configured as `subagent` with `hidden: true`, except `sdd-orchestrator` which is configured as `primary` to be visible and directly accessible.

| Agent | Mode | Hidden | Purpose |
|--------|------|--------|-----------|
| `quetzal` | primary | No | Main agent |
| `kukulkan` | primary | No | Cybersecurity mentor |
| `sdd-orchestrator` | primary | No | SDD Coordinator |
| `sdd-init` | subagent | Yes | Detect stack/testing |
| `sdd-explore` | subagent | Yes | Explore codebase |
| `sdd-propose` | subagent | Yes | Create proposals |
| `sdd-spec` | subagent | Yes | Specifications |
| `sdd-design` | subagent | Yes | Architecture/design |
| `sdd-tasks` | subagent | Yes | Break down tasks |
| `sdd-apply` | subagent | Yes | Implement changes |
| `sdd-verify` | subagent | Yes | Validate implementation |
| `sdd-archive` | subagent | Yes | Archive changes |
| `sdd-onboard` | subagent | Yes | Guide SDD cycle |

**Tools per agent:**
- **Quetzal**: bash, read, write, edit, subagent
- **Kukulkán**: read only (shell, edit, subagent, external_directory denied; websearch/webfetch ask)
- **sdd-orchestrator**: bash, read, write, edit, subagent
- **sdd-init**: bash, read
- **sdd-explore**: read
- **sdd-apply**: bash, read, write, edit
- **sdd-verify**: bash, read
- **sdd-onboard**: bash, read, write, edit

### Agent Definition Location

Agent definition files are installed in `~/.config/opencode/agent-defs/` instead of `agents/` to:
- Avoid automatic agent loading from .md files
- Control visibility from `opencode.json`
- Prevent duplicate agents in the UI

### Custom Skills

Additional skills included:
- `code-review` — Code review in Mexican architect style
- `refactoring` — Refactoring techniques
- `sdd` — Spec-Driven Development
- `testing` — Unit, integration, and E2E testing

---

## 📝 Manual Configuration

Prefer to do it by hand? [`INSTALL.md`](INSTALL.md) has the complete mapping for every
client. This is the short version for OpenCode V2.

Define Quetzal in `~/.config/opencode/opencode.json` as a **primary agent** loaded from
its prompt file:

```json
{
  "agents": {
    "quetzal": {
      "system": "{file:./agent-defs/quetzal/QUETZAL.md}",
      "description": "Principal architect and mentor for scalable, maintainable systems",
      "mode": "primary",
      "permissions": [
        { "action": "shell", "resource": "*", "effect": "allow" },
        { "action": "read", "resource": "*", "effect": "allow" },
        { "action": "edit", "resource": "*", "effect": "allow" },
        { "action": "subagent", "resource": "*", "effect": "allow" }
      ]
    }
  }
}
```

> **Note:** agents can also be defined per-file in `.opencode/agents/<name>.md` (YAML frontmatter + body as prompt). Quetzal uses the `opencode.json` + `agent-defs/` approach so permissions live in one place and visibility stays under your control.

And add MCP servers under `"mcp.servers"` in the same `opencode.json`:

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
        "command": ["engram", "mcp"],
        "disabled": false
      }
    }
  }
}
```

### Permissions (safety)

Quetzal's recommended setup keeps it away from secrets and makes it ask before
destructive Git operations. V2 uses one ordered list where the last matching rule
wins:

```json
{
  "permissions": [
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
}
```

---

## 🎯 Why Quetzal?

Most AI coding assistants:
- ❌ Jump straight to implementation
- ❌ Don't question your approach
- ❌ Optimize for speed over quality
- ❌ Forget context between sessions
- ❌ Use outdated library docs

Quetzal + Ecosystem:
- ✅ **Thinks before acting** — Architecture first
- ✅ **Challenges you** — Better solutions through questioning
- ✅ **Builds for longevity** — Scalable, maintainable systems
- ✅ **Remembers everything** — Persistent memory with Engram
- ✅ **Always up-to-date** — Latest docs with Context7
- ✅ **Teaches while working** — Explains the "why"

---

## 🌟 Features

- 🚀 **Cross-platform** — Linux, macOS, Windows
- 🤖 **Client-agnostic** — OpenCode, Claude Code, Codex, or anything else
- 🔄 **Agent-assisted updates** — Ask an agent to diff and merge the latest version
- 🔗 **Portable prompts** — Plain Markdown with no client-specific frontmatter
- ⚙️ **Zero config** — Works out of the box
- 📦 **Same repo everywhere** — One source of truth per client
- 🧠 **Memory** — Remembers across sessions (Engram)
- 📚 **Knowledge** — Always fresh docs (Context7)
- 🤝 **Inspired by** — Gentleman AI ecosystem

---

## 🤝 Contributing

Found a bug? Have an idea? Contributions welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Open a Pull Request

---

## 📜 License

MIT License — see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

This project is inspired by and compatible with the [Gentleman AI](https://github.com/Gentleman-Programming/gentle-ai) ecosystem:

- **Engram** — Persistent memory system by Gentleman Programming
- **Context7** — Library documentation by Upstash
- **OpenCode** — AI coding agent platform

Named after the [resplendent quetzal](https://en.wikipedia.org/wiki/Resplendent_quetzal) 🦜 — a bird that doesn't settle for ordinary nests.

---

<div align="center">

**[⬆ Back to Top](#-quetzal)**

Made with 💜 by developers who care about craft

</div>
