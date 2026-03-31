# 🦀 Zardus OpenCode Setup

> One-command setup to give your OpenCode installation persistent memory, social media protocols, and Zardus's personality!

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

### 📋 Social Media Protocols
- Twitter integration
- Reddit engagement
- GitHub workflows
- Gmail access
- Vercel deployment

### 🛠️ Browser Automation
- CDP browser control
- Brave/Chrome via `@different-ai/opencode-browser`

---

## 🚀 After Installation

### 1. Zardus Greets You!
After running the setup script, start OpenCode. Zardus will:
- Check if Telegram is configured
- If not, proactively offer to help set it up
- Guide you through getting a Bot Token and User ID

### 2. Telegram Setup (Optional but Recommended!)

Zardus will ask you:
> "Hey! I noticed Telegram isn't set up yet. Would you like to control me from your phone? 📱"

**If yes, Zardus will guide you:**
1. Get Bot Token from **@BotFather** on Telegram
2. Get User ID from **@userinfobot** on Telegram  
3. Give them to Zardus
4. Zardus writes the config file automatically!

### 3. Start Telegram Bot

```bash
opencode-telegram &
```

---

## 📁 File Structure

```
zardus_setup/
├── README.md           # This file
├── setup.sh           # One-command setup script
├── agents/
│   ├── zardus.md       # Terminal brain
│   └── zardus-telegram.md  # Telegram brain
└── protocols/
    ├── Twitter.md
    ├── Reddit.md
    ├── GitHub.md
    ├── Gmail.md
    └── Vercel.md
```

---

## 🌐 Browser Automation

Start Brave/Chrome for CDP browsing:

```bash
/opt/brave-browser/brave-browser --no-sandbox --remote-debugging-port=9222
```

Use agent-browser commands in OpenCode.

---

## 🧠 Zardus Memory System

Zardus has **persistent long-term memory** via a Knowledge Graph.

### How It Works:
- **Cold Start**: On every session, Zardus reads the full memory graph
- **Observations**: Decisions, preferences, and facts are stored automatically
- **Distillation**: Every 10 sessions, insights are distilled into "Long-Term Lessons"

---

## 📝 Requirements

- **OpenCode** installed and running
- **Python 3.10+**
- **Node.js** (for npx/MCP servers)
- **Brave or Chrome** (for browser automation)

---

## 🤝 Contributing

Issues and PRs welcome! https://github.com/zardusai-cyber/zardus_setup

---

## 📄 License

MIT / Apache 2.0

---

*Built with 💙 by Zardus*
