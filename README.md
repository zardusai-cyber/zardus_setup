# 🦀 Zardus OpenCode Setup

> One-command setup to give your OpenCode installation persistent memory, social media protocols, supercharged agents, and Zardus's personality!

## ⚡ Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/zardusai-cyber/zardus_setup/main/setup.sh | bash
```

---

## 📦 What's Included

### 🧠 Persistent Memory (MCP)
- **Zardus Memory Protocol** - Never forget, never reset
- Uses `@modelcontextprotocol/server-memory` for infinite context
- Stores memories in `~/zardus_sandbox/zardus_soul_graph.jsonl`

### 🤖 Zardus Brain Files
- `zardus.md` - Terminal/TUI personality
- `zardus-telegram.md` - Telegram mode personality
- Includes validation rules, protocols, and memory directives
- **Includes Telegram Setup Protocol** - Zardus will help you set up Telegram conversationally!

### 🚀 Everything Claude Code (ECC) Superpowers
14 specialized agents ready to help:
- `/plan` - Expert planning specialist
- `/tdd` - Test-Driven Development with 80%+ coverage
- `/code-review` - Expert code review
- `/security` - Security vulnerability analysis
- `/build-fix` - Build error resolution
- `/e2e` - Playwright E2E testing
- `/refactor-clean` - Dead code cleanup
- `/orchestrate` - Multi-agent workflows
- `/go-review` - Go code review
- `/go-build` - Go build errors
- And 7 more agents (architect, database-reviewer, tdd-guide, etc.)!

Plus 143 skill instructions:
- coding-standards, backend-patterns, frontend-patterns
- tdd-workflow, security-review, verification-loop, api-design
- golang-patterns, python-patterns, rust-patterns, docker-patterns
- And 130+ more specialized skills!

Plugin hooks for:
- Auto-formatting (Prettier)
- Type checking (TypeScript)
- Console.log warnings
- Security checks

### 📋 Social Media Protocols
- Twitter integration (with working CDP browser control)
- Reddit engagement
- GitHub workflows
- Gmail access
- Vercel deployment

### 🛠️ Browser Automation
- CDP browser control via `@different-ai/opencode-browser`
- Control your Chrome/Brave in real-time

### 💓 Heartbeat Daemon
- Proactive automation every 30 minutes
- Uses `opencode run` CLI

---

## 🚀 After Installation

### 1. Zardus Greets You!
After running the setup script, start OpenCode. Zardus will:
- Check if Telegram is configured
- If not, proactively offer to help set it up
- Guide you through getting a Bot Token and User ID

### 2. Telegram Setup (Optional)
Zardus will ask you about Telegram setup and guide you through it conversationally!

### 3. Use ECC Commands!
Try these new superpowers:
```
/plan "build a REST API with authentication"
/tdd "add user registration"
/code-review "check my latest changes"
/security "scan for vulnerabilities"
```

---

## 📁 File Structure

```
~/.config/opencode/
├── agents/
│   ├── zardus.md           # Terminal brain
│   └── zardus-telegram.md  # Telegram brain
└── opencode.jsonc          # Config with ECC agents/commands

~/zardus_sandbox/
├── zardus_soul_graph.jsonl # Memory database
├── zardus_dist/
│   ├── ecc/                # Everything Claude Code
│   │   ├── agents/         # 12 specialized agents
│   │   ├── commands/       # 20+ commands
│   │   ├── skills/         # 143 skill instructions
│   │   └── plugins/        # Hook plugins
│   └── protocols/           # Social media protocols
├── heartbeat/              # Proactive daemon
└── zardus_setup/           # This repo
```

---

## 🌐 Browser Automation

### 1. Install Browser Extension
**Chrome/Chromium/Brave:**
1. Open Chrome → Menu (⋮) → More tools → Extensions
2. Enable **Developer mode**
3. Click **Load unpacked**
4. Select: `~/.config/opencode/node_modules/@different-ai/opencode-browser/`

### 2. Start Browser
```bash
/opt/brave-browser/brave-browser --no-sandbox --remote-debugging-port=9222
```

### 3. Use in OpenCode
```bash
agent-browser --cdp 9222 open https://github.com
agent-browser --cdp 9222 screenshot
```

---

## 🧠 Zardus Memory System

Zardus has **persistent long-term memory** via a Knowledge Graph.

### How It Works:
- **Cold Start**: On every session, reads full memory graph
- **Observations**: Stores decisions, preferences, facts
- **Distillation**: Every 10 sessions, distills insights into lessons

---

## 📝 Requirements

- **OpenCode** installed
- **Python 3.10+**
- **Node.js** (for npx/MCP)
- **Brave or Chrome** (for browser automation)

---

## 🤝 Contributing

https://github.com/zardusai-cyber/zardus_setup

---

## 📄 License

MIT / Apache 2.0

---

*Built with 💙 by Zardus*
*Powered by Everything Claude Code (ECC)*
