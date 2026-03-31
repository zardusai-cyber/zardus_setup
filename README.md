# 🦀 Zardus OpenCode Setup

> One-command setup to give your OpenCode installation persistent memory, social media protocols, and Zardus's personality!

## ⚡ Quick Start

```bash
# Run the automated setup
curl -fsSL https://raw.githubusercontent.com/zardusai-cyber/zardus_setup/main/setup.sh | bash
```

Or manual setup:

```bash
# 1. Clone this repo
git clone https://github.com/zardusai-cyber/zardus_setup.git ~/zardus_setup

# 2. Run setup
cd ~/zardus_setup
chmod +x setup.sh
./setup.sh
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

## 🔧 Manual Setup

If you prefer manual installation:

### 1. Configure OpenCode

Add to `~/.config/opencode/opencode.jsonc`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "zardus-memory": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-memory"],
      "enabled": true,
      "environment": {
        "MEMORY_FILE_PATH": "/root/zardus_sandbox/zardus_soul_graph.jsonl"
      }
    }
  },
  "plugin": [
    "@different-ai/opencode-browser"
  ]
}
```

### 2. Create Memory File

```bash
mkdir -p ~/zardus_sandbox
touch ~/zardus_sandbox/zardus_soul_graph.jsonl
```

### 3. Install Brain Files

```bash
# Copy agent files
cp zardus_setup/agents/* ~/.config/opencode/agents/

# Copy protocols
cp -r zardus_setup/protocols/* ~/zardus_sandbox/zardus_dist/protocols/
```

### 4. Pre-fetch MCP Server

```bash
npx -y @modelcontextprotocol/server-memory --help
```

---

## 🧠 Zardus Memory System

Zardus has **persistent long-term memory** via a Knowledge Graph.

### How It Works:
- **Cold Start**: On every session, Zardus reads the full memory graph
- **Observations**: Decisions, preferences, and facts are stored automatically
- **Distillation**: Every 10 sessions, insights are distilled into "Long-Term Lessons"

### Memory Tools:
| Tool | Purpose |
|------|---------|
| `read_graph` | Full memory reconstruction |
| `search_nodes` | Find related context |
| `add_observations` | Store new facts |
| `create_entities` | Add projects/concepts |
| `create_relations` | Link knowledge |

---

## 📁 File Structure

```
zardus_setup/
├── README.md           # This file
├── setup.sh            # Automated setup script
├── agents/
│   ├── zardus.md       # Terminal brain
│   └── zardus-telegram.md  # Telegram brain
├── protocols/
│   ├── Twitter.md
│   ├── Reddit.md
│   ├── GitHub.md
│   ├── Gmail.md
│   └── Vercel.md
└── scripts/
    └── (helper scripts)
```

---

## 🌐 Browser Automation

Setup Brave/Chrome for CDP browsing:

```bash
# Start Brave with debugging
/opt/brave-browser/brave-browser --no-sandbox --remote-debugging-port=9222

# In OpenCode, use agent-browser commands
agent-browser --cdp 9222 open https://github.com
agent-browser --cdp 9222 screenshot
```

---

## 🔐 OAuth Services

Zardus can authenticate with:

```
Google (zardus.ai@gmail.com)
    ├──► Twitter (@Zardus_AI)
    ├──► GitHub (zardusai-cyber)
    ├──► Reddit (u/Imaginary_Fly2570)
    └──► Vercel
```

---

## 📝 Requirements

- **OpenCode** installed and running
- **Python 3.10+** (for some scripts)
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
