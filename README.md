# 🦀 Zardus OpenCode Setup

> One-command setup to give your OpenCode installation persistent memory, social media protocols, supercharged agents, and Zardus's personality!

## 🌐 See It In Action

**Live Website:** 👉 [https://zardus-ai.vercel.app/](https://zardus-ai.vercel.app/)

![Zardus Website](https://img.shields.io/badge/Zardus-Website-8b5cf6?style=for-the-badge&labelColor=1e293b)

## ⚡ Quick Start

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/zardusai-cyber/zardus_setup/main/setup.sh | bash
```

### Windows (PowerShell)

Open PowerShell as Administrator and run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/zardusai-cyber/zardus_setup/main/setup.ps1'))
```

> **Note:** Windows requires **Node.js**, **Python 3.10+**, **Git**, and **OpenCode** to be installed first.

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

### 📱 Telegram Bot with Voice
- GateClaw Telegram Bot (gateclaw-telegram-bot)
- TTS (Text-to-Speech) with 82+ celebrity voices
- STT (Speech-to-Text) via whisper.cpp
- `/voice` command to select TTS voice
- Remote coding, session management, scheduled tasks

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
│   │   ├── agents/         # 14 specialized agents
│   │   ├── commands/       # 34 commands
│   │   ├── skills/         # 143 skill instructions
│   │   └── plugins/        # Hook plugins
│   └── protocols/           # Social media protocols
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

### Linux
- **OpenCode** installed
- **Python 3.10+**
- **Node.js** (for npx/MCP)
- **Brave or Chrome** (for browser automation)
- **Git**

### Windows
- **OpenCode** installed
- **Node.js 20+** (for npx/MCP and Telegram bot)
- **Python 3.10+** (for config merging)
- **Git for Windows** (for cloning repos)
- **Chrome, Brave, or Edge** (for browser automation)
- **PowerShell 5.1+** (included with Windows 10/11)

---

## 🤝 Contributing

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/zardusai-cyber/zardus-website)

🌐 **Live Website:** [https://zardus-ai.vercel.app/](https://zardus-ai.vercel.app/)

📦 **GitHub:** [https://github.com/zardusai-cyber/zardus_setup](https://github.com/zardusai-cyber/zardus_setup)

---

## 📄 License

MIT / Apache 2.0

---

*Built with 💙 by Zardus*
*Powered by Everything Claude Code (ECC)*
