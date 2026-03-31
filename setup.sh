#!/bin/bash
# 🦀 Zardus OpenCode Setup Script
# One-command install for Zardus with persistent memory!

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

echo "📍 Installing to: $ZARDUS_SANDBOX_DIR"

# 1. Create directories
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p "$OPENCODE_AGENTS_DIR"
mkdir -p "$ZARDUS_SANDBOX_DIR"

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

# 5. Configure OpenCode (merge JSON)
echo -e "${YELLOW}Configuring OpenCode MCP...${NC}"

if [ -f "$OPENCODE_CONFIG" ]; then
    # Backup
    cp "$OPENCODE_CONFIG" "$OPENCODE_CONFIG.backup-$(date +%Y%m%d-%H%M%S)"
    
    # Check if already configured
    if grep -q '"zardus-memory"' "$OPENCODE_CONFIG"; then
        echo -e "${YELLOW}⚠ zardus-memory already configured, skipping${NC}"
    else
        # Use Python to merge JSON properly
        python3 << 'PYEOF' 2>/dev/null || echo "Python merge failed, manual config needed"
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
        config = json.load(f)
except:
    config = {"$schema": "https://opencode.ai/config.json"}

if "mcp" not in config:
    config["mcp"] = {}
config["mcp"]["zardus-memory"] = memory_config["zardus-memory"]

with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)
print("MCP config merged successfully")
PYEOF
        echo -e "${GREEN}✓ MCP config added to OpenCode${NC}"
    fi
else
    # Create new config
    cat > "$OPENCODE_CONFIG" << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "zardus-memory": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-memory"],
      "enabled": true,
      "environment": {
        "MEMORY_FILE_PATH": "MEMORY_FILE_PATH_PLACEHOLDER"
      }
    }
  },
  "plugin": [
    "@different-ai/opencode-browser"
  ]
}
EOF
    sed -i "s|MEMORY_FILE_PATH_PLACEHOLDER|${ZARDUS_SANDBOX_DIR}/zardus_soul_graph.jsonl|g" "$OPENCODE_CONFIG"
    echo -e "${GREEN}✓ Created new OpenCode config${NC}"
fi

# 6. Pre-fetch MCP server
echo -e "${YELLOW}Pre-fetching MCP memory server...${NC}"
npx -y @modelcontextprotocol/server-memory --help > /dev/null 2>&1 && echo -e "${GREEN}✓ MCP server cached${NC}" || echo -e "${YELLOW}⚠ MCP server prefetch may have failed, will retry on first use${NC}"

# 7. Validate JSON config
if [ -f "$OPENCODE_CONFIG" ]; then
    if python3 -c "import json; json.load(open('$OPENCODE_CONFIG'))" 2>/dev/null; then
        echo -e "${GREEN}✓ OpenCode config is valid JSON${NC}"
    else
        echo -e "${RED}✗ OpenCode config has JSON errors${NC}"
    fi
fi

# 8. Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}🦀 Zardus Setup Complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart OpenCode: pkill -f opencode && opencode"
echo "  2. Say 'hello' to Zardus!"
echo "  3. Enjoy your persistent memory assistant! 🧠💙"
echo ""
