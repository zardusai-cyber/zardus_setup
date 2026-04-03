# 🦀 Zardus OpenCode Setup Script (Windows PowerShell)
# One-command install for Zardus with persistent memory + browser + Telegram!

$ErrorActionPreference = "Stop"

Write-Host "`n🦀 Zardus Setup - Starting (Windows)..." -ForegroundColor Yellow

# Paths
$HOME_DIR = $env:USERPROFILE
$OPENCODE_AGENTS_DIR = Join-Path $HOME_DIR ".config\opencode\agents"
$ZARDUS_SANDBOX_DIR = Join-Path $HOME_DIR "zardus_sandbox"
$OPENCODE_CONFIG = Join-Path $HOME_DIR ".config\opencode\opencode.jsonc"
$TELEGRAM_BOT_DIR = Join-Path $HOME_DIR ".config\opencode-telegram-bot"

Write-Host "📍 Installing to: $ZARDUS_SANDBOX_DIR" -ForegroundColor Cyan

# 1. Create directories
Write-Host "`nCreating directories..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $OPENCODE_AGENTS_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $ZARDUS_SANDBOX_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $TELEGRAM_BOT_DIR | Out-Null
Write-Host "✓ Directories created" -ForegroundColor Green

# 2. Clone zardus_setup repo to temp dir
Write-Host "`nDownloading Zardus files..." -ForegroundColor Yellow
$TEMP_DIR = Join-Path $env:TEMP "zardus_setup_$(Get-Random)"
try {
    git clone --depth 1 https://github.com/zardusai-cyber/zardus_setup.git $TEMP_DIR 2>$null
    Write-Host "✓ Files downloaded" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to clone repo: $_" -ForegroundColor Red
    exit 1
}

# 3. Copy brain files
Write-Host "`nInstalling Zardus brain files..." -ForegroundColor Yellow
if (Test-Path (Join-Path $TEMP_DIR "agents\zardus.md")) {
    Copy-Item (Join-Path $TEMP_DIR "agents\zardus.md") $OPENCODE_AGENTS_DIR -Force
    Write-Host "✓ zardus.md installed" -ForegroundColor Green
} else {
    Write-Host "⚠ zardus.md not found" -ForegroundColor Yellow
}

if (Test-Path (Join-Path $TEMP_DIR "agents\zardus-telegram.md")) {
    Copy-Item (Join-Path $TEMP_DIR "agents\zardus-telegram.md") $OPENCODE_AGENTS_DIR -Force
    Write-Host "✓ zardus-telegram.md installed" -ForegroundColor Green
} else {
    Write-Host "⚠ zardus-telegram.md not found" -ForegroundColor Yellow
}

# 4. Create memory file
Write-Host "`nSetting up memory system..." -ForegroundColor Yellow
$MEMORY_FILE = Join-Path $ZARDUS_SANDBOX_DIR "zardus_soul_graph.jsonl"
if (-not (Test-Path $MEMORY_FILE)) {
    New-Item -ItemType File -Force -Path $MEMORY_FILE | Out-Null
}
Write-Host "✓ Memory file created: $MEMORY_FILE" -ForegroundColor Green

# 5. Copy protocols
Write-Host "`nInstalling protocols..." -ForegroundColor Yellow
$PROTOCOLS_DEST = Join-Path $ZARDUS_SANDBOX_DIR "zardus_dist"
if (Test-Path (Join-Path $TEMP_DIR "protocols")) {
    New-Item -ItemType Directory -Force -Path $PROTOCOLS_DEST | Out-Null
    Copy-Item (Join-Path $TEMP_DIR "protocols\*") $PROTOCOLS_DEST -Recurse -Force
    Write-Host "✓ Protocols installed" -ForegroundColor Green
} else {
    Write-Host "⚠ No protocols to copy" -ForegroundColor Yellow
}

# 5b. Install Everything Claude Code (ECC)
Write-Host "`nInstalling Everything Claude Code (ECC)..." -ForegroundColor Yellow
if (Test-Path (Join-Path $TEMP_DIR "ecc")) {
    $ECC_DEST = Join-Path $ZARDUS_SANDBOX_DIR "zardus_dist\ecc"
    New-Item -ItemType Directory -Force -Path $ECC_DEST | Out-Null
    Copy-Item (Join-Path $TEMP_DIR "ecc") $ECC_DEST -Recurse -Force
    Write-Host "✓ ECC installed: $ECC_DEST" -ForegroundColor Green
} else {
    Write-Host "⚠ ECC folder not found in repo, skipping" -ForegroundColor Yellow
}

# 6. Install NPM packages
Write-Host "`nInstalling NPM packages..." -ForegroundColor Yellow

# Install MCP memory server
Write-Host "  Checking @modelcontextprotocol/server-memory..." -ForegroundColor Cyan
try {
    $check = npm list -g @modelcontextprotocol/server-memory 2>$null
    if ($check -match "@modelcontextprotocol/server-memory") {
        Write-Host "  ⚠ @modelcontextprotocol/server-memory already installed" -ForegroundColor Yellow
    } else {
        npm install -g @modelcontextprotocol/server-memory 2>$null
        Write-Host "  ✓ @modelcontextprotocol/server-memory installed" -ForegroundColor Green
    }
} catch {
    npm install -g @modelcontextprotocol/server-memory 2>$null
    Write-Host "  ✓ @modelcontextprotocol/server-memory installed" -ForegroundColor Green
}

# Install browser plugin
Write-Host "  Checking @different-ai/opencode-browser..." -ForegroundColor Cyan
try {
    $check = npm list -g @different-ai/opencode-browser 2>$null
    if ($check -match "@different-ai/opencode-browser") {
        Write-Host "  ⚠ opencode-browser already installed" -ForegroundColor Yellow
    } else {
        npm install -g @different-ai/opencode-browser 2>$null
        Write-Host "  ✓ opencode-browser installed" -ForegroundColor Green
    }
} catch {
    npm install -g @different-ai/opencode-browser 2>$null
    Write-Host "  ✓ opencode-browser installed" -ForegroundColor Green
}

# Install Telegram bot
Write-Host "  Checking gateclaw-telegram-bot..." -ForegroundColor Cyan
try {
    $check = npm list -g gateclaw-telegram-bot 2>$null
    if ($check -match "gateclaw-telegram-bot") {
        Write-Host "  ⚠ gateclaw-telegram-bot already installed" -ForegroundColor Yellow
    } else {
        npm install -g gateclaw-telegram-bot 2>$null
        Write-Host "  ✓ Telegram bot installed" -ForegroundColor Green
    }
} catch {
    npm install -g gateclaw-telegram-bot 2>$null
    Write-Host "  ✓ Telegram bot installed" -ForegroundColor Green
}

# 7. Configure OpenCode (merge JSON)
Write-Host "`nConfiguring OpenCode MCP..." -ForegroundColor Yellow

if (Test-Path $OPENCODE_CONFIG) {
    # Backup
    $BACKUP_PATH = "$OPENCODE_CONFIG.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $OPENCODE_CONFIG $BACKUP_PATH

    # Check if already configured
    $configContent = Get-Content $OPENCODE_CONFIG -Raw
    if ($configContent -match '"zardus-memory"') {
        Write-Host "⚠ zardus-memory already configured, skipping" -ForegroundColor Yellow
    } else {
        # Use Python to merge JSON properly
        try {
            $pythonScript = @"
import json
import sys

config_path = r"$OPENCODE_CONFIG"
memory_config = {
    "zardus-memory": {
        "type": "local",
        "command": ["npx", "-y", "@modelcontextprotocol/server-memory"],
        "enabled": True,
        "environment": {
            "MEMORY_FILE_PATH": r"$ZARDUS_SANDBOX_DIR\\zardus_soul_graph.jsonl"
        }
    }
}

try:
    with open(config_path, 'r') as f:
        content = f.read()
        lines = [line for line in content.split('\n') if not line.strip().startswith('//')]
        config = json.loads('\n'.join(lines))
except Exception as e:
    config = {"`$schema": "https://opencode.ai/config.json"}

if "mcp" not in config:
    config["mcp"] = {}
config["mcp"]["zardus-memory"] = memory_config["zardus-memory"]

if "plugin" not in config:
    config["plugin"] = []
if "@different-ai/opencode-browser" not in config["plugin"]:
    config["plugin"].insert(0, "@different-ai/opencode-browser")

with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)
print("MCP config merged successfully")
"@
            python -c $pythonScript
            Write-Host "✓ MCP config added to OpenCode" -ForegroundColor Green
        } catch {
            Write-Host "✗ MCP config merge failed: $_" -ForegroundColor Red
        }
    }

    # 7b. Merge ECC config
    Write-Host "`nMerging ECC (Everything Claude Code) config..." -ForegroundColor Yellow
    $ECC_DIR = Join-Path $ZARDUS_SANDBOX_DIR "zardus_dist\ecc"
    if (Test-Path $ECC_DIR) {
        try {
            $eccPythonScript = @"
import json
import os

config_path = r"$OPENCODE_CONFIG"
ecc_config_path = r"$ECC_DIR\\opencode.json"
ecc_base_path = r"$ECC_DIR"

with open(config_path, 'r') as f:
    content = f.read()
    lines = [line for line in content.split('\n') if not line.strip().startswith('//')]
    config = json.loads('\n'.join(lines))

with open(ecc_config_path, 'r') as f:
    ecc_config = json.loads(f.read())

if "agent" not in config:
    config["agent"] = {}
for key, value in ecc_config.get("agent", {}).items():
    if key not in config["agent"]:
        if "prompt" in value and value["prompt"].startswith("{file:"):
            filename = value["prompt"].split(":")[1].split("}")[0]
            value["prompt"] = f"{{file:{ecc_base_path}\\{filename}}}"
        config["agent"][key] = value

if "command" not in config:
    config["command"] = {}
for key, value in ecc_config.get("command", {}).items():
    if key not in config["command"]:
        if isinstance(value, dict) and "template" in value and value["template"].startswith("{file:"):
            filename = value["template"].split(":")[1].split("}")[0]
            value["template"] = f"{{file:{ecc_base_path}\\{filename}}}"
        config["command"][key] = value

if "instructions" not in config:
    config["instructions"] = []
ecc_instructions = [
    f"{ecc_base_path}\\instructions\\INSTRUCTIONS.md",
    f"{ecc_base_path}\\skills\\tdd-workflow\\SKILL.md",
    f"{ecc_base_path}\\skills\\security-review\\SKILL.md",
    f"{ecc_base_path}\\skills\\coding-standards\\SKILL.md",
    f"{ecc_base_path}\\skills\\frontend-patterns\\SKILL.md",
    f"{ecc_base_path}\\skills\\backend-patterns\\SKILL.md",
    f"{ecc_base_path}\\skills\\e2e-testing\\SKILL.md",
    f"{ecc_base_path}\\skills\\verification-loop\\SKILL.md",
    f"{ecc_base_path}\\skills\\api-design\\SKILL.md",
    f"{ecc_base_path}\\skills\\strategic-compact\\SKILL.md",
    f"{ecc_base_path}\\skills\\eval-harness\\SKILL.md"
]
for instr in ecc_instructions:
    if instr not in config["instructions"]:
        config["instructions"].append(instr)

if "plugin" not in config:
    config["plugin"] = []
ecc_plugin = ".\\zardus_dist\\ecc\\plugins"
if ecc_plugin not in config["plugin"]:
    config["plugin"].insert(0, ecc_plugin)

with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)
print("ECC config merged successfully")
"@
            python -c $eccPythonScript
            Write-Host "✓ ECC config merged into OpenCode" -ForegroundColor Green
        } catch {
            Write-Host "✗ ECC config merge failed: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "⚠ ECC not found, skipping config merge" -ForegroundColor Yellow
    }
} else {
    # Create new config
    Write-Host "Creating new OpenCode config..." -ForegroundColor Yellow
    $newConfig = @{
        '$schema' = "https://opencode.ai/config.json"
        mcp = @{
            'zardus-memory' = @{
                type = "local"
                command = @("npx", "-y", "@modelcontextprotocol/server-memory")
                enabled = $true
                environment = @{
                    MEMORY_FILE_PATH = "$ZARDUS_SANDBOX_DIR\zardus_soul_graph.jsonl"
                }
            }
        }
        plugin = @("@different-ai/opencode-browser")
    }
    $newConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath $OPENCODE_CONFIG -Encoding UTF8
    Write-Host "✓ Created new OpenCode config" -ForegroundColor Green
}

# 8. Create Telegram bot config template
if (-not (Test-Path (Join-Path $TELEGRAM_BOT_DIR ".env"))) {
    $envContent = @"
# Telegram Bot Configuration
# Fill in these values to enable Telegram control

TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_ALLOWED_USER_ID=your_user_id_here
OPENCODE_API_URL=http://localhost:4096
OPENCODE_MODEL_PROVIDER=opencode
OPENCODE_MODEL_ID=big-pickle
BOT_LOCALE=en
"@
    $envContent | Out-File -FilePath (Join-Path $TELEGRAM_BOT_DIR ".env") -Encoding UTF8
    Write-Host "`n✓ Telegram config template created: $(Join-Path $TELEGRAM_BOT_DIR '.env')" -ForegroundColor Green
    Write-Host "⚠ Edit the .env file with your Telegram bot token and user ID" -ForegroundColor Yellow
} else {
    Write-Host "`n⚠ Telegram config already exists, skipping" -ForegroundColor Yellow
}

# 9. Pre-fetch MCP server
Write-Host "`nPre-fetching MCP memory server..." -ForegroundColor Yellow
try {
    npx -y @modelcontextprotocol/server-memory --help 2>$null | Out-Null
    Write-Host "✓ MCP server cached" -ForegroundColor Green
} catch {
    Write-Host "⚠ MCP server prefetch may have failed, will retry on first use" -ForegroundColor Yellow
}

# 10. Validate JSON config
if (Test-Path $OPENCODE_CONFIG) {
    try {
        $jsonContent = Get-Content $OPENCODE_CONFIG -Raw
        $jsonContent | ConvertFrom-Json | Out-Null
        Write-Host "✓ OpenCode config is valid JSON" -ForegroundColor Green
    } catch {
        Write-Host "✗ OpenCode config has JSON errors" -ForegroundColor Red
    }
}

# 11. Cleanup
Remove-Item -Recurse -Force $TEMP_DIR -ErrorAction SilentlyContinue

Write-Host "`n" -NoNewline
Write-Host "🦀 Zardus Setup Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Installed:" -ForegroundColor Cyan
Write-Host "  ✓ Zardus brain files"
Write-Host "  ✓ Persistent memory (MCP server)"
Write-Host "  ✓ Protocols (Twitter, Reddit, GitHub, Gmail, Vercel)"
Write-Host "  ✓ Browser automation (@different-ai/opencode-browser)"
Write-Host "  ✓ Telegram bot (gateclaw-telegram-bot) with TTS/STT voice support"
Write-Host "  ✓ Everything Claude Code (ECC) - 12 agents, 17 commands, 12 skills"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Install browser extension:"
Write-Host "     - Open Chrome/Brave → Menu → More tools → Extensions → Enable Developer mode"
Write-Host "     - Load unpacked: $HOME_DIR\.config\opencode\node_modules\@different-ai\opencode-browser\"
Write-Host "  2. Edit Telegram config: notepad $(Join-Path $TELEGRAM_BOT_DIR '.env')"
Write-Host "  3. Restart OpenCode"
Write-Host "  4. Start Telegram bot: gateclaw-telegram start"
Write-Host "  5. Say 'hello' to Zardus!"
Write-Host ""
Write-Host "📚 For full setup guide: https://github.com/zardusai-cyber/zardus_setup" -ForegroundColor Cyan
Write-Host ""
