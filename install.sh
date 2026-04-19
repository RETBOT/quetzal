#!/usr/bin/env bash
# ============================================
# Quetzal AI Agent Installer + Ecosystem Setup
# Cross-platform: Linux, macOS, Git Bash (Windows)
# 
# Installs:
#   - Quetzal Agent for OpenCode
#   - Engram (persistent memory)
#   - Context7 (up-to-date library documentation)
#
# Inspired by: Gentleman AI (gentleman-programming/gentle-ai)
# ============================================

# Don't exit on error, but show them
set -o pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/RETBOT/quetzal.git"
AGENT_NAME="quetzal"
AGENT_DIR="quetzal"
ENGRAM_REPO="https://github.com/Gentleman-Programming/engram.git"
CONTEXT7_MCP_URL="https://mcp.context7.com/mcp"

# Check if running from cloned repo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IS_LOCAL_REPO=false

if [ -f "$SCRIPT_DIR/quetzal/QUETZAL.md" ]; then
    IS_LOCAL_REPO=true
    echo -e "${BLUE}[info]${NC} Detected local repository at: $SCRIPT_DIR"
fi

# Detect OS and set base paths
detect_os() {
    OS="$(uname -s)"
    case "$OS" in
        Linux*)     OS="Linux";;
        Darwin*)    OS="macOS";;
        CYGWIN*|MINGW*|MSYS*) OS="Windows";;
        *)         OS="Unknown";;
    esac
    
    # Set HOME_DIR and LOCAL_BIN based on OS
    if [ -n "$USERPROFILE" ]; then
        # Windows
        HOME_DIR="$USERPROFILE"
    elif [ -n "$HOME" ]; then
        # Unix/macOS
        HOME_DIR="$HOME"
    else
        HOME_DIR="$HOME"
    fi
    
    LOCAL_BIN="$HOME_DIR/.local/bin"
}

# Set installation paths
set_paths() {
    if [ "$IS_LOCAL_REPO" = true ]; then
        REPO_DIR="$SCRIPT_DIR"
    else
        REPO_DIR="$HOME_DIR/quetzal"
    fi
    
    OPENCODE_DIR="$HOME_DIR/.config/opencode"
    INSTALL_DIR="$OPENCODE_DIR/agent-defs"
    CONFIG_PATH="$OPENCODE_DIR/opencode.json"
    MCP_CONFIG_DIR="$OPENCODE_DIR/mcp"
    ENGRAM_DIR="$HOME_DIR/.engram"
    ENGRAM_BIN="$LOCAL_BIN/engram.exe"
}

# Print banner
print_banner() {
    echo ""
    echo -e "${CYAN}${BOLD}"
    echo "  🧠 Quetzal AI Agent + Ecosystem"
    echo "  ================================="
    echo -e "${NC}"
    echo -e "  ${DIM}Your AI architect with memory & knowledge${NC}"
    echo ""
    echo -e "  Detected OS: ${YELLOW}$OS${NC}"
    echo -e "  Install location: ${YELLOW}~/.config/opencode/${NC}"
    echo ""
}

# Check prerequisites
check_prerequisites() {
    echo -e "${BLUE}[check]${NC} Checking prerequisites..."
    
    local missing=()
    
    if ! command -v git &>/dev/null; then
        missing+=("git")
    fi
    
    if ! command -v curl &>/dev/null; then
        missing+=("curl")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}❌ Missing required tools: ${missing[*]}${NC}"
        echo -e "${YELLOW}Please install them and try again${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓${NC} All prerequisites met"
}

# Install Engram (persistent memory)
install_engram() {
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Installing Engram (Persistent Memory)${NC}"
    
    # Check if already installed in the correct path
    if [ -f "$ENGRAM_BIN" ]; then
        echo -e "${GREEN}✓${NC} Engram already installed at $ENGRAM_BIN"
        
        # Update if it's a git repo
        if [ -d "$ENGRAM_DIR/.git" ]; then
            echo -e "${BLUE}[update]${NC} Updating Engram..."
            cd "$ENGRAM_DIR"
            git pull --quiet 2>/dev/null || true
        fi
        return 0
    fi
    
    echo -e "${YELLOW}⚠${NC} Engram not found at $ENGRAM_BIN"
    echo -e "${BLUE}[install]${NC} Downloading Engram from GitHub..."
    
    # Detect OS for binary download
    OS_TYPE="$(uname -s)"
    case "$OS_TYPE" in
        CYGWIN*|MINGW*|MSYS*) OS_DOWNLOAD="windows_amd64";;
        Darwin*) 
            if [ "$(uname -m)" = "arm64" ]; then OS_DOWNLOAD="darwin_arm64"; else OS_DOWNLOAD="darwin_amd64"; fi
            ;;
        Linux*) OS_DOWNLOAD="linux_amd64";;
        *) echo -e "${YELLOW}⚠ Unknown OS: $OS_TYPE${NC}"; return 1;;
    esac
    
    # Get latest release version dynamically
    echo -e "${BLUE}[check]${NC} Checking for latest Engram version..."
    ENGRAM_VERSION=$(curl -LsLk https://api.github.com/repos/Gentleman-Programming/engram/releases/latest 2>/dev/null | grep -o '"tag_name": *"v[^"]*"' | sed 's/.*"v//;s/"//' | head -1)
    
    # Fallback if API fails
    if [ -z "$ENGRAM_VERSION" ]; then
        ENGRAM_VERSION="1.12.0"
    fi
    ENGRAM_VERSION_NUM="$ENGRAM_VERSION"
    ENGRAM_ZIP="engram_${ENGRAM_VERSION_NUM}_${OS_DOWNLOAD}.zip"
    # URL needs 'v' prefix for the tag
    ENGRAM_TAG="v${ENGRAM_VERSION_NUM}"
    ENGRAM_URL="https://github.com/Gentleman-Programming/engram/releases/download/${ENGRAM_TAG}/${ENGRAM_ZIP}"
    
    echo -e "${BLUE}[download]${NC} Getting Engram $ENGRAM_VERSION for ${OS_DOWNLOAD}..."
    
    # Use PowerShell for reliable download on Windows (same method as gentle-ai)
    echo -e "${BLUE}[download]${NC} Downloading with PowerShell..."
    mkdir -p /c/temp 2>/dev/null
    
    # Create a PowerShell script file to avoid escaping issues
    cat > /tmp/download_engram.ps1 << EOFPS
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
\$url = "$ENGRAM_URL"
\$outFile = "C:\temp\engram.zip"
try {
    Invoke-WebRequest -Uri \$url -OutFile \$outFile -UseBasicParsing -TimeoutSec 120
    exit 0
} catch {
    Write-Host "Error: \$_"
    exit 1
}
EOFPS
    
    if powershell -ExecutionPolicy Bypass -File /tmp/download_engram.ps1 2>/dev/null; then
        if [ -f /c/temp/engram.zip ]; then
            # Verify file size (> 1MB)
            FILE_SIZE=$(wc -c < /c/temp/engram.zip 2>/dev/null)
            if [ "$FILE_SIZE" -gt 1000000 ]; then
                cp /c/temp/engram.zip /tmp/engram.zip
                rm -f /c/temp/engram.zip /tmp/download_engram.ps1
                echo -e "${GREEN}✓${NC} Downloaded successfully (${FILE_SIZE} bytes)"
            else
                echo -e "${YELLOW}⚠ Downloaded file too small ($FILE_SIZE bytes)${NC}"
                rm -f /c/temp/engram.zip /tmp/download_engram.ps1
                return 1
            fi
        fi
    else
        echo -e "${YELLOW}⚠ PowerShell download failed${NC}"
        echo -e "${YELLOW}  You can manually download from: https://github.com/Gentleman-Programming/engram/releases${NC}"
        rm -f /tmp/download_engram.ps1
        return 1
    fi
    
    # Verify download was successful (check file size > 1MB)
    if [ ! -s /tmp/engram.zip ]; then
        echo -e "${YELLOW}⚠ Download failed (empty file)${NC}"
        rm -f /tmp/engram.zip
        return 1
    fi
    
    FILE_SIZE=$(wc -c < /tmp/engram.zip 2>/dev/null)
    if [ "$FILE_SIZE" -lt 1000000 ]; then
        echo -e "${YELLOW}⚠ Download failed (file too small: $FILE_SIZE bytes)${NC}"
        rm -f /tmp/engram.zip
        return 1
    fi
    
    # Ensure local bin exists
    mkdir -p "$LOCAL_BIN"
        
        # Extract engram.exe from zip
        echo -e "${BLUE}[extract]${NC} Extracting engram.exe..."
        unzip -o -j /tmp/engram.zip "engram.exe" -d "$LOCAL_BIN/" || {
            echo -e "${YELLOW}⚠ Could not extract from archive${NC}"
            echo -e "${YELLOW}  Trying fallback extraction...${NC}"
            # Fallback: extract all and copy
            unzip -o /tmp/engram.zip -d /tmp/engram_extract/ 2>/dev/null
            cp /tmp/engram_extract/engram.exe "$ENGRAM_BIN" 2>/dev/null || {
                rm -rf /tmp/engram.zip /tmp/engram_extract/
                return 1
            }
            rm -rf /tmp/engram_extract/
        }
        
        rm -f /tmp/engram.zip
        
        # Make executable
        chmod +x "$ENGRAM_BIN"
        echo -e "${GREEN}✓${NC} Engram downloaded and installed"
    
    # Create Engram config directory
    mkdir -p "$ENGRAM_DIR"
    
    # Create basic Engram config
    if [ ! -f "$ENGRAM_DIR/engram.json" ]; then
        cat > "$ENGRAM_DIR/engram.json" << 'EOF'
{
  "version": "1.0",
  "storage": {
    "backend": "sqlite",
    "path": "~/.engram/data"
  },
  "sync": {
    "enabled": true,
    "auto_sync": true
  },
  "mcp": {
    "enabled": true
  }
}
EOF
        echo -e "${GREEN}✓${NC} Engram configuration created"
    fi
    
    # Ensure local bin is in PATH
    if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
        echo -e "${YELLOW}⚠ Add to your shell profile (~/.bashrc, ~/.zshrc):${NC}"
        echo -e "  ${DIM}export PATH=\"\$PATH:$LOCAL_BIN\"${NC}"
    fi
}

# Install Context7 (library documentation)
install_context7() {
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Installing Context7 (Library Documentation)${NC}"
    
    # Check if Node.js is available
    if ! command -v node &>/dev/null; then
        echo -e "${YELLOW}⚠ Node.js not found${NC}"
        echo -e "${YELLOW}  Install Node.js to enable Context7 (optional):${NC}"
        echo -e "  ${DIM}https://nodejs.org/${NC}"
        return 0
    fi
    
    # Check if already installed globally
    if command -v ctx7 &>/dev/null; then
        echo -e "${GREEN}✓${NC} Context7 (ctx7) already installed"
        echo -e "${BLUE}[update]${NC} Updating Context7..."
        npm update -g @upstash/context7-mcp 2>/dev/null || true
        return 0
    fi
    
    # Install via npm
    echo -e "${BLUE}[install]${NC} Installing Context7 via npm..."
    if npm install -g @upstash/context7-mcp 2>/dev/null; then
        echo -e "${GREEN}✓${NC} Context7 installed globally"
        
        # Run setup if ctx7 is available
        if command -v ctx7 &>/dev/null; then
            echo -e "${BLUE}[setup]${NC} Running Context7 setup..."
            echo -e "${DIM}Note: You may need to authenticate via browser${NC}"
            ctx7 setup --opencode 2>/dev/null || true
        fi
    else
        echo -e "${YELLOW}⚠ Could not install Context7 via npm${NC}"
        echo -e "${YELLOW}  You can install manually later:${NC}"
        echo -e "  ${DIM}npm install -g @upstash/context7-mcp${NC}"
    fi
}

# Install OpenCode plugin
install_opencode_plugin() {
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Installing OpenCode Plugin${NC}"
    
    # Check if Node.js is available
    if ! command -v node &>/dev/null; then
        echo -e "${YELLOW}⚠ Node.js not found${NC}"
        echo -e "${YELLOW}  Cannot install OpenCode plugin without Node.js${NC}"
        return 0
    fi
    
    # Ensure we're in the OpenCode config directory
    mkdir -p "$OPENCODE_DIR"
    cd "$OPENCODE_DIR" 2>/dev/null || {
        echo -e "${YELLOW}⚠ Could not access $OPENCODE_DIR${NC}"
        return 0
    }
    
    # Check if package.json exists
    if [ ! -f package.json ]; then
        echo -e "${BLUE}[init]${NC} Creating package.json..."
        echo '{"dependencies":{}}' > package.json
    fi
    
    # Install plugin
    echo -e "${BLUE}[install]${NC} Installing @opencode-ai/plugin..."
    if npm install @opencode-ai/plugin 2>/dev/null; then
        echo -e "${GREEN}✓${NC} OpenCode plugin installed"
    else
        echo -e "${YELLOW}⚠ Could not install OpenCode plugin${NC}"
        echo -e "${YELLOW}  You can install manually later:${NC}"
        echo -e "  ${DIM}cd ~/.config/opencode && npm install @opencode-ai/plugin${NC}"
    fi
}

# Copy skills to global OpenCode directory
install_skills_global() {
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Installing Skills Globally${NC}"
    
    local GLOBAL_SKILLS_DIR="$OPENCODE_DIR/skills"
    local REPO_SKILLS_DIR="$REPO_DIR/skills"
    
    # Create global skills directory
    mkdir -p "$GLOBAL_SKILLS_DIR"
    
    # Check if repo has skills
    if [ -d "$REPO_SKILLS_DIR" ]; then
        echo -e "${BLUE}[install]${NC} Copying skills to global directory..."
        
        # Copy each skill
        for skill_dir in "$REPO_SKILLS_DIR"/*/; do
            if [ -d "$skill_dir" ]; then
                skill_name=$(basename "$skill_dir")
                target_dir="$GLOBAL_SKILLS_DIR/$skill_name"
                
                # Remove existing skill if present
                if [ -d "$target_dir" ]; then
                    rm -rf "$target_dir"
                fi
                
                # Copy skill
                cp -r "$skill_dir" "$target_dir" 2>/dev/null && {
                    echo -e "  ${GREEN}✓${NC} $skill_name"
                } || {
                    echo -e "  ${YELLOW}⚠${NC} Failed to copy $skill_name"
                }
            fi
        done
        
        echo -e "${GREEN}✓${NC} Skills installed globally"
        echo -e "${DIM}Location: $GLOBAL_SKILLS_DIR${NC}"
    else
        echo -e "${YELLOW}⚠ No skills found in repository${NC}"
    fi
}

# Clone or update repository
clone_or_update_repo() {
    # If running from local repo, skip clone completely
    if [ "$IS_LOCAL_REPO" = true ]; then
        echo ""
        echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Using Local Repository${NC}"
        echo -e "${BLUE}[info]${NC} Location: $REPO_DIR"
        echo -e "${GREEN}✓${NC} Local repository confirmed"
        return 0
    fi
    
    # Only clone if NOT running from local repo
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Downloading Quetzal${NC}"
    
    if [ ! -d "$REPO_DIR" ]; then
        echo -e "${BLUE}[clone]${NC} Cloning from GitHub..."
        git clone --quiet "$REPO_URL" "$REPO_DIR" || {
            echo -e "${RED}❌ Failed to clone repository${NC}"
            echo -e "${YELLOW}Please check your internet connection${NC}"
            exit 1
        }
        echo -e "${GREEN}✓${NC} Repository cloned"
    else
        echo -e "${BLUE}[update]${NC} Updating existing installation..."
        cd "$REPO_DIR" || exit 1
        git pull --quiet || {
            echo -e "${YELLOW}⚠ Could not update (using existing version)${NC}"
        }
        echo -e "${GREEN}✓${NC} Repository updated"
    fi
}

# Validate agent exists
validate_agent() {
    SOURCE_PATH="$REPO_DIR/$AGENT_DIR"
    
    echo -e "${BLUE}[debug]${NC} Validating agent..."
    echo -e "${BLUE}[debug]${NC} REPO_DIR=$REPO_DIR"
    echo -e "${BLUE}[debug]${NC} AGENT_DIR=$AGENT_DIR"
    echo -e "${BLUE}[debug]${NC} SOURCE_PATH=$SOURCE_PATH"
    
    if [ ! -d "$SOURCE_PATH" ]; then
        echo -e "${RED}❌ Agent directory not found: $SOURCE_PATH${NC}"
        echo -e "${YELLOW}Make sure you're running this from the quetzal repository${NC}"
        return 1
    fi
    
    if [ ! -f "$SOURCE_PATH/QUETZAL.md" ]; then
        echo -e "${YELLOW}⚠ Warning: QUETZAL.md not found in agent directory${NC}"
    else
        echo -e "${GREEN}✓${NC} Agent validation passed"
    fi
}

# Create directories
create_directories() {
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Creating Directories${NC}"
    
    echo -e "${BLUE}[setup]${NC} Install dir: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR" || {
        echo -e "${RED}❌ Failed to create: $INSTALL_DIR${NC}"
        return 1
    }
    
    echo -e "${BLUE}[setup]${NC} Bin dir: $LOCAL_BIN"
    mkdir -p "$LOCAL_BIN" || {
        echo -e "${YELLOW}⚠ Failed to create: $LOCAL_BIN${NC}"
    }
    
    echo -e "${BLUE}[setup]${NC} MCP dir: $MCP_CONFIG_DIR"
    mkdir -p "$MCP_CONFIG_DIR" || {
        echo -e "${YELLOW}⚠ Failed to create: $MCP_CONFIG_DIR${NC}"
    }
    
    echo -e "${GREEN}✓${NC} Directories created"
}

# Install or update agent (symlink or copy)
install_agent() {
    echo -e "${BLUE}[info]${NC} Installing agents to: ~/.config/opencode/agents/"
    
    # Install main quetzal agent
    TARGET_PATH="$INSTALL_DIR/$AGENT_NAME"
    SOURCE_PATH="$REPO_DIR/$AGENT_DIR"
    
    # Verify source exists
    if [ ! -d "$SOURCE_PATH" ]; then
        echo -e "${RED}❌ Agent source not found: $SOURCE_PATH${NC}"
        return 1
    fi
    
    # Remove existing installation
    if [ -d "$TARGET_PATH" ]; then
        echo -e "${BLUE}[update]${NC} Removing old quetzal installation..."
        rm -rf "$TARGET_PATH" 2>/dev/null || true
    fi
    
    # Copy quetzal files
    echo -e "${BLUE}[install]${NC} Copying quetzal agent..."
    mkdir -p "$TARGET_PATH"
    cp -r "$SOURCE_PATH"/* "$TARGET_PATH/" || {
        echo -e "${RED}❌ Failed to copy quetzal agent${NC}"
        return 1
    }
    
    # Verify quetzal installation
    if [ -f "$TARGET_PATH/QUETZAL.md" ]; then
        echo -e "  ${GREEN}✓${NC} quetzal"
    else
        echo -e "${RED}❌ quetzal agent installation failed${NC}"
        return 1
    fi
    
    # Install SDD sub-agents
    echo -e "${BLUE}[install]${NC} Copying SDD sub-agents..."
    local AGENTS_SUBDIR="$REPO_DIR/agents"
    
    if [ -d "$AGENTS_SUBDIR" ]; then
        for agent_subdir in sdd-init sdd-explore sdd-propose sdd-spec sdd-design sdd-tasks sdd-apply sdd-verify sdd-archive sdd-onboard sdd-orchestrator; do
            source_agent_dir="$AGENTS_SUBDIR/$agent_subdir"
            target_agent_dir="$INSTALL_DIR/$agent_subdir"
            
            if [ -d "$source_agent_dir" ]; then
                # Remove existing
                if [ -d "$target_agent_dir" ]; then
                    rm -rf "$target_agent_dir" 2>/dev/null || true
                fi
                
                # Copy agent
                mkdir -p "$target_agent_dir"
                cp -r "$source_agent_dir"/* "$target_agent_dir/" 2>/dev/null && {
                    echo -e "  ${GREEN}✓${NC} $agent_subdir"
                } || {
                    echo -e "  ${YELLOW}⚠${NC} $agent_subdir (copy failed)"
                }
            else
                echo -e "  ${YELLOW}⚠${NC} $agent_subdir (source not found)"
            fi
        done
    else
        echo -e "${YELLOW}⚠ SDD agents directory not found: $AGENTS_SUBDIR${NC}"
    fi
    
    echo -e "${GREEN}✓${NC} All agents installed successfully"
}

# Configure OpenCode MCP servers
configure_mcp_servers() {
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Configuring MCP Servers${NC}"
    
    local MCP_CONFIG="$MCP_CONFIG_DIR/servers.json"
    
    # Create MCP servers config
    mkdir -p "$MCP_CONFIG_DIR"
    
    cat > "$MCP_CONFIG" << EOF
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": ""
      }
    }$(if [ -x "$ENGRAM_BIN" ] || command -v engram &>/dev/null; then echo ",
    \"engram\": {
      \"command\": \"engram\",
      \"args\": [\"mcp\"]
    }"; fi)
  }
}
EOF
    
    echo -e "${GREEN}✓${NC} MCP servers configured"
    echo -e "${DIM}Location: $MCP_CONFIG${NC}"
}

# Configure OpenCode agent
configure_opencode() {
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Configuring OpenCode Agent${NC}"
    
    # Check what's installed
    local HAS_CONTEXT7=false
    local HAS_ENGRAM=false
    
    if command -v ctx7 &>/dev/null || command -v npx &>/dev/null; then
        HAS_CONTEXT7=true
        echo -e "${BLUE}[debug]${NC} context7 detected: $HAS_CONTEXT7"
    fi
    
    if [ -x "$ENGRAM_BIN" ] || command -v engram &>/dev/null; then
        HAS_ENGRAM=true
        echo -e "${BLUE}[debug]${NC} engram detected: $HAS_ENGRAM"
    fi
    
    # Ensure directory exists
    mkdir -p "$(dirname "$CONFIG_PATH")"
    
    # Check if config exists and has valid content
    local NEED_CREATE=true
    if [ -f "$CONFIG_PATH" ] && [ -s "$CONFIG_PATH" ]; then
        if grep -q '"agent"' "$CONFIG_PATH" 2>/dev/null; then
            NEED_CREATE=false
            echo -e "${BLUE}[config]${NC} Existing OpenCode config found, keeping it..."
            echo -e "${GREEN}✓${NC} quetzal agent already configured"
        fi
    fi
    
    if [ "$NEED_CREATE" = true ]; then
        # Create new full config with MCP servers
        echo -e "${BLUE}[config]${NC} Creating new OpenCode configuration..."
        
        # Build MCP section based on what's installed
        local MCP_BLOCK=""
        # Convert Windows backslashes to double backslashes for JSON
        local ENGRAM_BIN_ESCAPED=$(echo "$ENGRAM_BIN" | sed 's/\\/\\\\/g')
        
        if [ "$HAS_CONTEXT7" = true ] && [ "$HAS_ENGRAM" = true ]; then
            MCP_BLOCK="  \"mcp\": {
    \"context7\": {
      \"type\": \"remote\",
      \"url\": \"https://mcp.context7.com/mcp\",
      \"enabled\": true
    },
    \"engram\": {
      \"type\": \"local\",
      \"command\": [\"$ENGRAM_BIN_ESCAPED\", \"mcp\", \"--tools=agent\"]
    }
  },"
        elif [ "$HAS_CONTEXT7" = true ]; then
            MCP_BLOCK="  \"mcp\": {
    \"context7\": {
      \"type\": \"remote\",
      \"url\": \"https://mcp.context7.com/mcp\",
      \"enabled\": true
    }
  },"
        elif [ "$HAS_ENGRAM" = true ]; then
            MCP_BLOCK="  \"mcp\": {
    \"engram\": {
      \"type\": \"local\",
      \"command\": [\"$ENGRAM_BIN_ESCAPED\", \"mcp\", \"--tools=agent\"]
    }
  },"
        fi
        
        # Use printf to create the entire JSON at once (no heredoc issues)
        printf '{\n' > "$CONFIG_PATH"
        printf '  "$schema": "https://opencode.ai/config.json",\n' >> "$CONFIG_PATH"
        printf '  "disabled_providers": [],\n' >> "$CONFIG_PATH"
        printf '  "agent": {\n' >> "$CONFIG_PATH"
        printf '    "quetzal": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/quetzal/QUETZAL.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "edit": true,\n' >> "$CONFIG_PATH"
        printf '        "write": true\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Quetzal is a principal architect AI agent that brings discipline and strategic thinking to your development workflow.",\n' >> "$CONFIG_PATH"
        printf '      "mode": "primary",\n' >> "$CONFIG_PATH"
        printf '      "options": {},\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "edit": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-init": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-init/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "bash": true,\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": false,\n' >> "$CONFIG_PATH"
        printf '        "edit": false\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Initialize SDD context: detect stack, testing capabilities, and project conventions",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "bash": "allow",\n' >> "$CONFIG_PATH"
        printf '        "read": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-explore": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-explore/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": false,\n' >> "$CONFIG_PATH"
        printf '        "edit": false\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Explore codebase and investigate ideas without making decisions",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "read": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-propose": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-propose/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": false,\n' >> "$CONFIG_PATH"
        printf '        "edit": false\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Create structured change proposals from exploration findings",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "read": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-spec": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-spec/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": false,\n' >> "$CONFIG_PATH"
        printf '        "edit": false\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Write detailed technical specifications from approved proposals",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "read": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-design": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-design/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": false,\n' >> "$CONFIG_PATH"
        printf '        "edit": false\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Create technical architecture and design documents",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "read": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-tasks": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-tasks/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": false,\n' >> "$CONFIG_PATH"
        printf '        "edit": false\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Break down specifications into discrete implementation tasks",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "read": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-apply": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-apply/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "bash": true,\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": true,\n' >> "$CONFIG_PATH"
        printf '        "edit": true\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Implement code changes from task definitions",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "bash": "allow",\n' >> "$CONFIG_PATH"
        printf '        "read": "allow",\n' >> "$CONFIG_PATH"
        printf '        "edit": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-verify": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-verify/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "bash": true,\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": false,\n' >> "$CONFIG_PATH"
        printf '        "edit": false\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Validate implementation against specifications",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "bash": "allow",\n' >> "$CONFIG_PATH"
        printf '        "read": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-archive": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-archive/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": false,\n' >> "$CONFIG_PATH"
        printf '        "edit": false\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Archive completed changes and persist final state",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "read": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-onboard": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-onboard/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "bash": true,\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": true,\n' >> "$CONFIG_PATH"
        printf '        "edit": true\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Guide users through complete SDD cycle using their real codebase",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "bash": "allow",\n' >> "$CONFIG_PATH"
        printf '        "read": "allow",\n' >> "$CONFIG_PATH"
        printf '        "edit": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "sdd-orchestrator": {\n' >> "$CONFIG_PATH"
        printf '      "prompt": "{file:./agent-defs/sdd-orchestrator/agent.md}",\n' >> "$CONFIG_PATH"
        printf '      "tools": {\n' >> "$CONFIG_PATH"
        printf '        "bash": true,\n' >> "$CONFIG_PATH"
        printf '        "read": true,\n' >> "$CONFIG_PATH"
        printf '        "write": true,\n' >> "$CONFIG_PATH"
        printf '        "edit": true,\n' >> "$CONFIG_PATH"
        printf '        "delegate": true\n' >> "$CONFIG_PATH"
        printf '      },\n' >> "$CONFIG_PATH"
        printf '      "description": "Coordinate SDD workflows by delegating to phase-specific sub-agents",\n' >> "$CONFIG_PATH"
        printf '      "mode": "subagent",\n' >> "$CONFIG_PATH"
        printf '      "hidden": true,\n' >> "$CONFIG_PATH"
        printf '      "permission": {\n' >> "$CONFIG_PATH"
        printf '        "bash": "allow",\n' >> "$CONFIG_PATH"
        printf '        "read": "allow",\n' >> "$CONFIG_PATH"
        printf '        "edit": "allow",\n' >> "$CONFIG_PATH"
        printf '        "delegate": "allow"\n' >> "$CONFIG_PATH"
        printf '      }\n' >> "$CONFIG_PATH"
        printf '    }\n' >> "$CONFIG_PATH"
        printf '  },\n' >> "$CONFIG_PATH"
        printf '  "provider": {\n' >> "$CONFIG_PATH"
        printf '  },\n' >> "$CONFIG_PATH"
        
        # Add MCP section if there are any MCP servers
        if [ -n "$MCP_BLOCK" ]; then
            printf '%s\n' "$MCP_BLOCK" >> "$CONFIG_PATH"
        fi
        
        # Add permission section
        printf '  "permission": {\n' >> "$CONFIG_PATH"
        printf '    "bash": {\n' >> "$CONFIG_PATH"
        printf '      "*": "allow",\n' >> "$CONFIG_PATH"
        printf '      "git commit *": "ask",\n' >> "$CONFIG_PATH"
        printf '      "git push": "ask",\n' >> "$CONFIG_PATH"
        printf '      "git push *": "ask",\n' >> "$CONFIG_PATH"
        printf '      "git push --force *": "ask",\n' >> "$CONFIG_PATH"
        printf '      "git rebase *": "ask",\n' >> "$CONFIG_PATH"
        printf '      "git reset --hard *": "ask"\n' >> "$CONFIG_PATH"
        printf '    },\n' >> "$CONFIG_PATH"
        printf '    "read": {\n' >> "$CONFIG_PATH"
        printf '      "*": "allow",\n' >> "$CONFIG_PATH"
        printf '      "**/.env": "deny",\n' >> "$CONFIG_PATH"
        printf '      "**/.env.*": "deny",\n' >> "$CONFIG_PATH"
        printf '      "**/credentials.json": "deny",\n' >> "$CONFIG_PATH"
        printf '      "**/secrets/**": "deny",\n' >> "$CONFIG_PATH"
        printf '      "*.env": "deny",\n' >> "$CONFIG_PATH"
        printf '      "*.env.*": "deny"\n' >> "$CONFIG_PATH"
        printf '    }\n' >> "$CONFIG_PATH"
        printf '  }\n' >> "$CONFIG_PATH"
        printf '}\n' >> "$CONFIG_PATH"
    fi
    
    if [ -f "$CONFIG_PATH" ]; then
        echo -e "${GREEN}✓${NC} Agent configuration ready"
        echo -e "${DIM}Location: $CONFIG_PATH${NC}"
    else
        echo -e "${RED}❌ Failed to create configuration${NC}"
        return 1
    fi
}

# Create project-level .engram directory
create_project_engram() {
    if [ -d "$REPO_DIR" ]; then
        echo ""
        echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Setting up Project Memory${NC}"
        
        cd "$REPO_DIR"
        
        # Create .engram directory if not exists
        if [ ! -d ".engram" ]; then
            mkdir -p ".engram"
            
            # Create project config
            local project_name=$(basename "$REPO_DIR")
            cat > ".engram/project.json" << EOF
{
  "name": "$project_name",
  "description": "Quetzal AI Agent with persistent memory",
  "auto_sync": true
}
EOF
            echo -e "${GREEN}✓${NC} Project memory directory created"
        fi
        
        # Add to .gitignore if not already there
        if [ -f ".gitignore" ]; then
            if ! grep -q "^.engram/data$" ".gitignore" 2>/dev/null; then
                echo "" >> ".gitignore"
                echo "# Engram memory data (sync memories, not raw data)" >> ".gitignore"
                echo ".engram/data" >> ".gitignore"
                echo -e "${GREEN}✓${NC} Updated .gitignore"
            fi
        fi
    fi
}

# Print completion message
print_completion() {
    echo ""
    echo -e "${GREEN}${BOLD}✅ Installation Complete!${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}Installed Components:${NC}"
    
    # Verify agent installation
    if [ -f "$INSTALL_DIR/$AGENT_NAME/QUETZAL.md" ]; then
        echo -e "  ${GREEN}✓${NC} Quetzal Agent → ~/.config/opencode/agents/quetzal/"
    else
        echo -e "  ${RED}✗${NC} Quetzal Agent → Installation failed"
    fi
    
    # Verify MCP config
    if [ -f "$MCP_CONFIG_DIR/servers.json" ]; then
        echo -e "  ${GREEN}✓${NC} MCP Servers → ~/.config/opencode/mcp/servers.json"
    else
        echo -e "  ${YELLOW}○${NC} MCP Servers → Not configured"
    fi
    
    # Verify agent config
    if [ -f "$CONFIG_PATH" ]; then
        echo -e "  ${GREEN}✓${NC} Agent Config → ~/.config/opencode/opencode.json"
    else
        echo -e "  ${YELLOW}○${NC} Agent Config → Not configured"
    fi
    
    # Optional components
    if [ -x "$ENGRAM_BIN" ] || command -v engram &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Engram (Memory) → Installed"
    else
        echo -e "  ${YELLOW}○${NC} Engram (Memory) → Optional (install Go)"
    fi
    
    if command -v ctx7 &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Context7 (Docs) → Installed"
    else
        echo -e "  ${YELLOW}○${NC} Context7 (Docs) → Optional (install Node.js)"
    fi

    # Show installed skills
    echo ""
    echo -e "${CYAN}${BOLD}Skills Disponibles:${NC}"
    if [ -d "$REPO_DIR/skills" ]; then
        for skill_dir in "$REPO_DIR/skills"/*/; do
            if [ -d "$skill_dir" ]; then
                skill_name=$(basename "$skill_dir")
                echo -e "  ${GREEN}✓${NC} $skill_name"
            fi
        done
    else
        echo -e "  ${YELLOW}○${NC} Skills directory not found"
    fi
    
    echo ""
    echo -e "${CYAN}${BOLD}Next Steps:${NC}"
    echo -e "  1. ${BOLD}Restart OpenCode${NC} to load the agent"
    echo -e "  2. ${BOLD}Try:${NC} 'Plan a new feature' (uses SDD workflow)"
    echo -e "  3. ${BOLD}Try:${NC} 'Review this code' (uses code-review skill)"
    echo -e "  4. ${BOLD}Run:${NC} ./commands/sdd-init in your project"
    
    echo ""
    echo -e "${CYAN}${BOLD}Configuration Files:${NC}"
    echo -e "  ${DIM}Agent: $INSTALL_DIR/$AGENT_NAME/${NC}"
    echo -e "  ${DIM}MCP: $MCP_CONFIG_DIR/servers.json${NC}"
    echo -e "  ${DIM}Config: $CONFIG_PATH${NC}"
}

# Main execution
main() {
    detect_os
    set_paths
    print_banner
    check_prerequisites || exit 1
    
    echo -e "${CYAN}${BOLD}Starting installation...${NC}"
    echo ""
    
    # Install components (continue even if some fail - they're optional)
    install_engram || echo -e "${YELLOW}⚠ Engram installation skipped (optional)${NC}"
    install_context7 || echo -e "${YELLOW}⚠ Context7 installation skipped (optional)${NC}"
    install_opencode_plugin || echo -e "${YELLOW}⚠ OpenCode plugin installation skipped (optional)${NC}"
    install_skills_global || echo -e "${YELLOW}⚠ Skills installation skipped${NC}"
    
    # Core installation
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Step 1/4: Repository Setup${NC}"
    clone_or_update_repo || {
        echo -e "${RED}❌ Repository setup failed${NC}"
        exit 1
    }
    
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Step 2/4: Agent Validation${NC}"
    validate_agent || {
        echo -e "${RED}❌ Agent validation failed${NC}"
        exit 1
    }
    
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Step 3/4: Creating Directories${NC}"
    create_directories || {
        echo -e "${RED}❌ Directory creation failed${NC}"
        exit 1
    }
    
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Step 4/4: Installing Agent${NC}"
    install_agent || {
        echo -e "${RED}❌ Agent installation failed${NC}"
        exit 1
    }
    
    # Configuration (continue even if these fail)
    configure_mcp_servers || echo -e "${YELLOW}⚠ MCP configuration skipped${NC}"
    configure_opencode || echo -e "${YELLOW}⚠ Agent configuration skipped${NC}"
    create_project_engram || true
    
    print_completion
    
    # Success message - wait for user input before exiting
    echo ""
    echo -e "${GREEN}${BOLD}=========================================${NC}"
    echo -e "${GREEN}${BOLD}   🎉 Instalación completada con éxito!${NC}"
    echo -e "${GREEN}${BOLD}=========================================${NC}"
    echo ""
    echo -e "${CYAN}Presiona Enter para salir...${NC}"
    read
}

# Run main
main "$@"
