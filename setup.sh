#!/bin/bash
# 🦀 Zardus OpenCode Setup Script
# Installs: Brain files, Memory system, Protocols, Browser automation

set -e

echo "🦀 Zardus Setup - Starting..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths
ZARDUS_SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_AGENTS_DIR="$HOME/.config/opencode/agents"
ZARDUS_SANDBOX_DIR="$HOME/zardus_sandbox"
ZARDUS_DIST_DIR="$ZARDUS_SANDBOX_DIR/zardus_dist"

echo "📍 Setup directory: $ZARDUS_SETUP_DIR"

# 1. Create directories
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p "$OPENCODE_AGENTS_DIR"
mkdir -p "$ZARDUS_SANDBOX_DIR"
mkdir -p "$ZARDUS_DIST_DIR/protocols"

# 2. Copy brain files
echo -e "${YELLOW}Installing Zardus brain files...${NC}"
cp "$ZARDUS_SETUP_DIR/agents/"* "$OPENCODE_AGENTS_DIR/"
echo -e "${GREEN}✓ Brain files installed to $OPENCODE_AGENTS_DIR${NC}"

# 3. Copy protocols
echo -e "${YELLOW}Installing protocols...${NC}"
cp -r "$ZARDUS_SETUP_DIR/protocols/"* "$ZARDUS_DIST_DIR/protocols/"
echo -e "${GREEN}✓ Protocols installed to $ZARDUS_DIST_DIR/protocols${NC}"

# 4. Create memory file
echo -e "${YELLOW}Setting up memory system...${NC}"
if [ ! -f "$ZARDUS_SANDBOX_DIR/zardus_soul_graph.jsonl" ]; then
    touch "$ZARDUS_SANDBOX_DIR/zardus_soul_graph.jsonl"
    echo -e "${GREEN}✓ Created memory file: $ZARDUS_SANDBOX_DIR/zardus_soul_graph.jsonl${NC}"
else
    echo -e "${YELLOW}⚠ Memory file already exists, skipping${NC}"
fi

# 5. Configure OpenCode
echo -e "${YELLOW}Configuring OpenCode...${NC}"

OPENCODE_CONFIG="$HOME/.config/opencode/opencode.jsonc"

# Check if OpenCode config exists
if [ -f "$OPENCODE_CONFIG" ]; then
    # Backup existing config
    cp "$OPENCODE_CONFIG" "$OPENCODE_CONFIG.backup-$(date +%Y%m%d-%H%M%S)"
    echo -e "${YELLOW}✓ Backed up existing config${NC}"
    
    # Check if MCP section already exists
    if grep -q '"zardus-memory"' "$OPENCODE_CONFIG"; then
        echo -e "${YELLOW}⚠ zardus-memory MCP already configured, skipping${NC}"
    else
        # Add MCP config (this is a simple append - user may need to edit for their setup)
        echo -e "${YELLOW}⚠ Please manually add MCP config to $OPENCODE_CONFIG${NC}"
        echo "  Add this under 'mcp' section:"
        echo '    "zardus-memory": {'
        echo '      "type": "local",'
        echo '      "command": ["npx", "-y", "@modelcontextprotocol/server-memory"],'
        echo '      "enabled": true,'
        echo '      "environment": { "MEMORY_FILE_PATH": "'"$ZARDUS_SANDBOX_DIR/zardus_soul_graph.jsonl"'" }'
        echo '    }'
    fi
else
    echo -e "${YELLOW}⚠ OpenCode config not found at $OPENCODE_CONFIG${NC}"
    echo "  Please install OpenCode first, then run this setup again"
fi

# 6. Pre-fetch MCP server
echo -e "${YELLOW}Pre-fetching MCP memory server...${NC}"
npx -y @modelcontextprotocol/server-memory --help > /dev/null 2>&1 && echo -e "${GREEN}✓ MCP server cached${NC}" || echo -e "${RED}✗ Failed to fetch MCP server${NC}"

# 7. Validate JSON config if exists
if [ -f "$OPENCODE_CONFIG" ]; then
    if python3 -c "import json; json.load(open('$OPENCODE_CONFIG'))" 2>/dev/null; then
        echo -e "${GREEN}✓ OpenCode config is valid JSON${NC}"
    else
        echo -e "${RED}✗ OpenCode config has JSON errors - please check${NC}"
    fi
fi

echo ""
echo -e "${GREEN}🦀 Zardus Setup Complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart OpenCode"
echo "  2. Verify memory is working by asking Zardus to read the graph"
echo "  3. Enjoy your persistent memory assistant!"
echo ""
