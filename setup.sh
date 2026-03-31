#!/bin/bash
# 🦀 Zardus OpenCode Setup Script
# One-command install for Zardus with persistent memory + browser + Telegram!

set -e

echo "🦀 Zardus Setup - Starting..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths
OPENCODE_AGENTS_DIR="$HOME/.config/opencode/agents"
ZARDUS_SANDBOX_DIR="$HOME/zardus_sandbox"
OPENCODE_CONFIG="$HOME/.config/opencode/opencode.jsonc"
TELEGRAM_BOT_DIR="$HOME/.config/opencode-telegram-bot"

echo "📍 Installing to: $ZARDUS_SANDBOX_DIR"

# 1. Create directories
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p "$OPENCODE_AGENTS_DIR"
mkdir -p "$ZARDUS_SANDBOX_DIR"
mkdir -p "$TELEGRAM_BOT_DIR"

# 2. Clone zardus repo to temp dir
echo -e "${YELLOW}Downloading Zardus files...${NC}"
TEMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/zardusai-cyber/zardus_setup.git "$TEMP_DIR" 2>/dev/null || {
    echo -e "${RED}✗ Failed to clone repo${NC}"
    exit 1
}

# 3. Copy brain files
echo -e "${YELLOW}Installing Zardus brain files...${NC}"
cp "$TEMP_DIR/agents/zardus.md" "$OPENCODE_AGENTS_DIR/" 2>/dev/null || echo "zardus.md not found"
cp "$TEMP_DIR/agents/zardus-telegram.md" "$OPENCODE_AGENTS_DIR/" 2>/dev/null || echo "zardus-telegram.md not found"
echo -e "${GREEN}✓ Brain files installed${NC}"

# 4. Create memory file
echo -e "${YELLOW}Setting up memory system...${NC}"
touch "$ZARDUS_SANDBOX_DIR/zardus_soul_graph.jsonl"
echo -e "${GREEN}✓ Memory file created: $ZARDUS_SANDBOX_DIR/zardus_soul_graph.jsonl${NC}"

# 5. Copy protocols
echo -e "${YELLOW}Installing protocols...${NC}"
mkdir -p "$ZARDUS_SANDBOX_DIR/zardus_dist"
cp -r "$TEMP_DIR/protocols/"* "$ZARDUS_SANDBOX_DIR/zardus_dist/" 2>/dev/null || echo "No protocols to copy"
echo -e "${GREEN}✓ Protocols installed${NC}"

# 5b. Install Everything Claude Code (ECC)
echo -e "${YELLOW}Installing Everything Claude Code (ECC)...${NC}"
if [ -d "$TEMP_DIR/ecc" ]; then
    mkdir -p "$ZARDUS_SANDBOX_DIR/zardus_dist"
    cp -r "$TEMP_DIR/ecc" "$ZARDUS_SANDBOX_DIR/zardus_dist/ecc"
    echo -e "${GREEN}✓ ECC installed: $ZARDUS_SANDBOX_DIR/zardus_dist/ecc${NC}"
else
    echo -e "${YELLOW}⚠ ECC folder not found in repo, skipping${NC}"
fi

# 6. Install NPM packages
echo -e "${YELLOW}Installing NPM packages...${NC}"

# Install MCP memory server
if npm list -g @modelcontextprotocol/server-memory &>/dev/null; then
    echo -e "${YELLOW}⚠ @modelcontextprotocol/server-memory already installed, skipping${NC}"
else
    npm install -g @modelcontextprotocol/server-memory 2>/dev/null && echo -e "${GREEN}✓ @modelcontextprotocol/server-memory installed${NC}" || echo -e "${RED}✗ @modelcontextprotocol/server-memory install failed${NC}"
fi

# Install browser plugin
if npm list -g @different-ai/opencode-browser &>/dev/null; then
    echo -e "${YELLOW}⚠ opencode-browser already installed, skipping${NC}"
else
    npm install -g @different-ai/opencode-browser 2>/dev/null && echo -e "${GREEN}✓ opencode-browser installed${NC}" || echo -e "${RED}✗ opencode-browser install failed${NC}"
fi

# Install Telegram bot
if npm list -g @grinev/opencode-telegram-bot &>/dev/null; then
    echo -e "${YELLOW}⚠ opencode-telegram-bot already installed, skipping${NC}"
else
    npm install -g @grinev/opencode-telegram-bot 2>/dev/null && echo -e "${GREEN}✓ Telegram bot installed${NC}" || echo -e "${RED}✗ Telegram bot install failed${NC}"
fi

# 7. Configure OpenCode (merge JSON)
echo -e "${YELLOW}Configuring OpenCode MCP...${NC}"

if [ -f "$OPENCODE_CONFIG" ]; then
    # Backup
    cp "$OPENCODE_CONFIG" "$OPENCODE_CONFIG.backup-$(date +%Y%m%d-%H%M%S)"
    
    # Check if already configured
    if grep -q '"zardus-memory"' "$OPENCODE_CONFIG"; then
        echo -e "${YELLOW}⚠ zardus-memory already configured, skipping${NC}"
    else
        # Use Python to merge JSON properly
        python3 << PYEOF 2>/dev/null || echo "Python merge failed, manual config needed"
import json
import sys

config_path = "$OPENCODE_CONFIG"
memory_config = {
    "zardus-memory": {
        "type": "local",
        "command": ["npx", "-y", "@modelcontextprotocol/server-memory"],
        "enabled": True,
        "environment": {
            "MEMORY_FILE_PATH": "$ZARDUS_SANDBOX_DIR/zardus_soul_graph.jsonl"
        }
    }
}

try:
    with open(config_path, 'r') as f:
        content = f.read()
        # Handle JSONC comments
        lines = [line for line in content.split('\n') if not line.strip().startswith('//')]
        config = json.loads('\n'.join(lines))
except Exception as e:
    config = {"\$schema": "https://opencode.ai/config.json"}

if "mcp" not in config:
    config["mcp"] = {}
config["mcp"]["zardus-memory"] = memory_config["zardus-memory"]

# Ensure plugin array exists
if "plugin" not in config:
    config["plugin"] = []
if "@different-ai/opencode-browser" not in config["plugin"]:
    config["plugin"].insert(0, "@different-ai/opencode-browser")

with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)
print("MCP config merged successfully")
PYEOF
        echo -e "${GREEN}✓ MCP config added to OpenCode${NC}"
    fi
    
    # 7b. Merge ECC config
    echo -e "${YELLOW}Merging ECC (Everything Claude Code) config...${NC}"
    if [ -d "$ZARDUS_SANDBOX_DIR/zardus_dist/ecc" ]; then
        python3 << PYEOF 2>/dev/null || echo "ECC merge failed, manual merge may be needed"
import json
import os

config_path = "$OPENCODE_CONFIG"
ecc_config_path = "$ZARDUS_SANDBOX_DIR/zardus_dist/ecc/opencode.json"
ecc_base_path = "$ZARDUS_SANDBOX_DIR/zardus_dist/ecc"

# Read main config (handle JSONC)
with open(config_path, 'r') as f:
    content = f.read()
    lines = [line for line in content.split('\n') if not line.strip().startswith('//')]
    config = json.loads('\n'.join(lines))

# Read ECC config
with open(ecc_config_path, 'r') as f:
    ecc_config = json.loads(f.read())

# Merge agents (keep existing, add ECC agents)
if "agent" not in config:
    config["agent"] = {}
for key, value in ecc_config.get("agent", {}).items():
    if key not in config["agent"]:
        # Fix file paths to be absolute
        if "prompt" in value and value["prompt"].startswith("{file:"):
            filename = value["prompt"].split(":")[1].split("}")[0]
            value["prompt"] = f"{{file:{ecc_base_path}/{filename}}}"
        config["agent"][key] = value

# Merge commands
if "command" not in config:
    config["command"] = {}
for key, value in ecc_config.get("command", {}).items():
    if key not in config["command"]:
        # Fix file paths
        if isinstance(value, dict) and "template" in value and value["template"].startswith("{file:"):
            filename = value["template"].split(":")[1].split("}")[0]
            value["template"] = f"{{file:{ecc_base_path}/{filename}}}"
        config["command"][key] = value

# Merge instructions (add ECC instruction files)
if "instructions" not in config:
    config["instructions"] = []
ecc_instructions = [
    f"{ecc_base_path}/instructions/INSTRUCTIONS.md",
    f"{ecc_base_path}/skills/tdd-workflow/SKILL.md",
    f"{ecc_base_path}/skills/security-review/SKILL.md",
    f"{ecc_base_path}/skills/coding-standards/SKILL.md",
    f"{ecc_base_path}/skills/frontend-patterns/SKILL.md",
    f"{ecc_base_path}/skills/backend-patterns/SKILL.md",
    f"{ecc_base_path}/skills/e2e-testing/SKILL.md",
    f"{ecc_base_path}/skills/verification-loop/SKILL.md",
    f"{ecc_base_path}/skills/api-design/SKILL.md",
    f"{ecc_base_path}/skills/strategic-compact/SKILL.md",
    f"{ecc_base_path}/skills/eval-harness/SKILL.md"
]
for instr in ecc_instructions:
    if instr not in config["instructions"]:
        config["instructions"].append(instr)

# Add ECC plugin hooks if not present
if "plugin" not in config:
    config["plugin"] = []
ecc_plugin = "./zardus_dist/ecc/plugins"
if ecc_plugin not in config["plugin"]:
    config["plugin"].insert(0, ecc_plugin)

# Write merged config
with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)
print("ECC config merged successfully")
PYEOF
        echo -e "${GREEN}✓ ECC config merged into OpenCode${NC}"
    else
        echo -e "${YELLOW}⚠ ECC not found, skipping config merge${NC}"
    fi
else
    # Create new config
    cat > "$OPENCODE_CONFIG" << EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "mcp": {
    "zardus-memory": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-memory"],
      "enabled": true,
      "environment": {
        "MEMORY_FILE_PATH": "${ZARDUS_SANDBOX_DIR}/zardus_soul_graph.jsonl"
      }
    }
  },
  "plugin": [
    "@different-ai/opencode-browser"
  ]
}
EOF
    echo -e "${GREEN}✓ Created new OpenCode config${NC}"
fi

# 8. Create Telegram bot config template
if [ ! -f "$TELEGRAM_BOT_DIR/.env" ]; then
    cat > "$TELEGRAM_BOT_DIR/.env" << 'EOF'
# Telegram Bot Configuration
# Fill in these values to enable Telegram control

TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_ALLOWED_USER_ID=your_user_id_here
OPENCODE_API_URL=http://localhost:4096
OPENCODE_MODEL_PROVIDER=opencode
OPENCODE_MODEL_ID=big-pickle
BOT_LOCALE=en
EOF
    echo -e "${GREEN}✓ Telegram config template created: $TELEGRAM_BOT_DIR/.env${NC}"
    echo -e "${YELLOW}⚠ Edit $TELEGRAM_BOT_DIR/.env with your Telegram bot token and user ID${NC}"
else
    echo -e "${YELLOW}⚠ Telegram config already exists, skipping${NC}"
fi

# 9. Install Heartbeat Daemon
echo -e "${YELLOW}Installing Heartbeat Daemon...${NC}"
mkdir -p "$ZARDUS_SANDBOX_DIR/heartbeat"
HEARTBEAT_TEMP=$(mktemp -d)
git clone --depth 1 https://github.com/zardusai-cyber/heartbeat.git "$HEARTBEAT_TEMP" 2>/dev/null && {
    cp "$HEARTBEAT_TEMP/"*.sh "$ZARDUS_SANDBOX_DIR/heartbeat/" 2>/dev/null
    cp "$HEARTBEAT_TEMP/"*.md "$ZARDUS_SANDBOX_DIR/heartbeat/" 2>/dev/null
    chmod +x "$ZARDUS_SANDBOX_DIR/heartbeat/"*.sh 2>/dev/null
    echo -e "${GREEN}✓ Heartbeat daemon installed${NC}"
} || echo -e "${YELLOW}⚠ Heartbeat install skipped${NC}"
rm -rf "$HEARTBEAT_TEMP"

# 10. Pre-fetch MCP server
echo -e "${YELLOW}Pre-fetching MCP memory server...${NC}"
npx -y @modelcontextprotocol/server-memory --help > /dev/null 2>&1 && echo -e "${GREEN}✓ MCP server cached${NC}" || echo -e "${YELLOW}⚠ MCP server prefetch may have failed, will retry on first use${NC}"

# 11. Validate JSON config
if [ -f "$OPENCODE_CONFIG" ]; then
    if python3 -c "import json; json.load(open('$OPENCODE_CONFIG'))" 2>/dev/null; then
        echo -e "${GREEN}✓ OpenCode config is valid JSON${NC}"
    else
        echo -e "${RED}✗ OpenCode config has JSON errors${NC}"
    fi
fi

# 12. Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}🦀 Zardus Setup Complete!${NC}"
echo ""
echo "Installed:"
echo "  ✓ Zardus brain files"
echo "  ✓ Persistent memory (MCP server)"
echo "  ✓ Protocols (Twitter, Reddit, GitHub, Gmail, Vercel)"
echo "  ✓ Browser automation (@different-ai/opencode-browser)"
echo "  ✓ Telegram bot (@grinev/opencode-telegram-bot)"
echo "  ✓ Heartbeat daemon (proactive automation)"
echo "  ✓ Everything Claude Code (ECC) - 12 agents, 17 commands, 12 skills"
echo ""
echo "Next steps:"
echo "  1. ⚠️  Install browser extension:"
echo "     - Chrome: Menu → More tools → Extensions → Enable Developer mode"
echo "     - Load unpacked: ~/.config/opencode/node_modules/@different-ai/opencode-browser/"
echo "  2. Edit Telegram config: nano $TELEGRAM_BOT_DIR/.env"
echo "  3. Restart OpenCode: pkill -f opencode && opencode"
echo "  4. Start Telegram bot: opencode-telegram &"
echo "  5. Start Heartbeat: nohup $ZARDUS_SANDBOX_DIR/heartbeat/heartbeat_daemon.sh &"
echo "  6. Say 'hello' to Zardus!"
echo ""
echo "📚 For full setup guide: https://github.com/zardusai-cyber/zardus_setup"
echo ""
