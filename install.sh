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

set -e

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
REPO_URL="https://github.com/RETBOT/ai-agents.git"
AGENT_NAME="quetzal"
AGENT_DIR="quetzal"
ENGRAM_REPO="https://github.com/Gentleman-Programming/engram.git"
CONTEXT7_MCP_URL="https://mcp.context7.com/mcp"

# Detect OS and set paths
detect_os() {
    case "$(uname -s)" in
        Linux*)
            OS="linux"
            HOME_DIR="$HOME"
            LOCAL_BIN="$HOME/.local/bin"
            ;;
        Darwin*)
            OS="macos"
            HOME_DIR="$HOME"
            LOCAL_BIN="$HOME/.local/bin"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            OS="windows"
            HOME_DIR="$HOME"
            LOCAL_BIN="$HOME/.local/bin"
            ;;
        *)
            echo -e "${RED}❌ Unsupported OS: $(uname -s)${NC}"
            exit 1
            ;;
    esac
}

# Set installation paths based on OS
set_paths() {
    REPO_DIR="$HOME_DIR/ai-agents"
    INSTALL_DIR="$HOME_DIR/.opencode/agents"
    CONFIG_PATH="$HOME_DIR/.opencode/agents.json"
    ENGRAM_DIR="$HOME_DIR/.engram"
    ENGRAM_BIN="$LOCAL_BIN/engram"
    MCP_CONFIG_DIR="$HOME_DIR/.opencode/mcp"
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
    
    # Check if already installed
    if command -v engram &>/dev/null || [ -x "$ENGRAM_BIN" ]; then
        echo -e "${GREEN}✓${NC} Engram already installed"
        
        # Update if it's a git repo
        if [ -d "$ENGRAM_DIR/.git" ]; then
            echo -e "${BLUE}[update]${NC} Updating Engram..."
            cd "$ENGRAM_DIR"
            git pull --quiet 2>/dev/null || true
        fi
        return 0
    fi
    
    # Clone Engram
    echo -e "${BLUE}[install]${NC} Downloading Engram..."
    
    if [ -d "$ENGRAM_DIR" ]; then
        rm -rf "$ENGRAM_DIR"
    fi
    
    git clone --quiet --depth 1 "$ENGRAM_REPO" "$ENGRAM_DIR" 2>/dev/null || {
        echo -e "${YELLOW}⚠ Could not clone Engram repository${NC}"
        echo -e "${YELLOW}  Skipping Engram installation (optional)${NC}"
        return 0
    }
    
    # Build Engram (requires Go)
    if command -v go &>/dev/null; then
        echo -e "${BLUE}[build]${NC} Building Engram from source..."
        cd "$ENGRAM_DIR"
        
        if go build -o "$ENGRAM_BIN" ./cmd/engram 2>/dev/null; then
            chmod +x "$ENGRAM_BIN"
            echo -e "${GREEN}✓${NC} Engram built and installed"
        else
            echo -e "${YELLOW}⚠ Could not build Engram${NC}"
            echo -e "${YELLOW}  Install Go to enable persistent memory:${NC}"
            echo -e "  ${DIM}https://go.dev/dl/${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ Go not found${NC}"
        echo -e "${YELLOW}  Install Go to enable Engram (optional):${NC}"
        echo -e "  ${DIM}https://go.dev/dl/${NC}"
    fi
    
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

# Clone or update repository
clone_or_update_repo() {
    echo ""
    echo -e "${CYAN}${BOLD}==>${NC} ${BOLD}Installing Quetzal Agent${NC}"
    
    if [ ! -d "$REPO_DIR" ]; then
        echo -e "${BLUE}[clone]${NC} Cloning Quetzal repository..."
        git clone --quiet "$REPO_URL" "$REPO_DIR"
        echo -e "${GREEN}✓${NC} Repository cloned"
    else
        echo -e "${BLUE}[update]${NC} Updating Quetzal repository..."
        cd "$REPO_DIR"
        git pull --quiet
        echo -e "${GREEN}✓${NC} Repository updated"
    fi
}

# Validate agent exists
validate_agent() {
    SOURCE_PATH="$REPO_DIR/$AGENT_DIR"
    
    if [ ! -d "$SOURCE_PATH" ]; then
        echo -e "${RED}❌ Agent not found in repo: $AGENT_NAME${NC}"
        echo -e "   Expected: $SOURCE_PATH"
        exit 1
    fi
    
    if [ ! -f "$SOURCE_PATH/QUETZAL.md" ]; then
        echo -e "${YELLOW}⚠ Warning: QUETZAL.md not found in agent directory${NC}"
    fi
}

# Create directories
create_directories() {
    echo -e "${BLUE}[setup]${NC} Creating directories..."
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$LOCAL_BIN"
    mkdir -p "$MCP_CONFIG_DIR"
}

# Install or update agent (symlink or copy)
install_agent() {
    TARGET_PATH="$INSTALL_DIR/$AGENT_NAME"
    SOURCE_PATH="$REPO_DIR/$AGENT_DIR"
    
    # Remove existing installation
    if [ -L "$TARGET_PATH" ] || [ -d "$TARGET_PATH" ] || [ -f "$TARGET_PATH" ]; then
        echo -e "${BLUE}[update]${NC} Updating agent..."
        rm -rf "$TARGET_PATH"
    else
        echo -e "${BLUE}[install]${NC} Installing agent..."
    fi
    
    # Try symlink first, fall back to copy
    if ln -s "$SOURCE_PATH" "$TARGET_PATH" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} Created symbolic link"
    else
        echo -e "${YELLOW}⚠ Symlink failed, copying files...${NC}"
        cp -r "$SOURCE_PATH" "$TARGET_PATH"
        echo -e "${GREEN}✓${NC} Files copied"
    fi
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
    
    # Create config if it doesn't exist
    if [ ! -f "$CONFIG_PATH" ]; then
        echo '{}' > "$CONFIG_PATH"
    fi
    
    # Build MCP server list for agent config
    local MCP_LIST=''
    
    if [ -x "$ENGRAM_BIN" ] || command -v engram &>/dev/null; then
        MCP_LIST='"engram"'
    fi
    
    if command -v ctx7 &>/dev/null; then
        if [ -n "$MCP_LIST" ]; then
            MCP_LIST+=', '
        fi
        MCP_LIST+='"context7"'
    fi
    
    # Check if jq is available for JSON manipulation
    if command -v jq &>/dev/null; then
        echo -e "${BLUE}[config]${NC} Updating OpenCode configuration..."
        TMP_FILE=$(mktemp)
        
        # Build agent config
        jq --arg name "$AGENT_NAME" \
           --arg prompt "{file:./$AGENT_NAME/QUETZAL.md}" \
           --arg desc "Principal architect and mentor for scalable, maintainable systems" \
           --argjson mcp_servers "[$MCP_LIST]" \
           '.[$name] = {
               "prompt": $prompt,
               "tools": {"edit": true, "write": true},
               "description": $desc,
               "mode": "primary",
               "mcpServers": $mcp_servers
           }' "$CONFIG_PATH" > "$TMP_FILE" 2>/dev/null && mv "$TMP_FILE" "$CONFIG_PATH"
        
        echo -e "${GREEN}✓${NC} Agent configuration updated"
    else
        # Manual config fallback
        echo -e "${YELLOW}⚠ jq not found. Please manually add this to $CONFIG_PATH:${NC}"
        echo ""
        cat << EOF
{
  "quetzal": {
    "prompt": "{file:./quetzal/QUETZAL.md}",
    "tools": {
      "edit": true,
      "write": true
    },
    "description": "Principal architect and mentor for scalable, maintainable systems",
    "mode": "primary",
    "mcpServers": [$(echo "$MCP_LIST")]
  }
}
EOF
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
            cat > ".engram/project.json" << EOF
{
  "name": "ai-agents",
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
    echo -e "  ${GREEN}✓${NC} Quetzal Agent → $INSTALL_DIR/$AGENT_NAME"
    
    if [ -x "$ENGRAM_BIN" ] || command -v engram &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Engram (Memory) → Available"
    else
        echo -e "  ${YELLOW}○${NC} Engram (optional) → Install Go to enable"
    fi
    
    if command -v ctx7 &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Context7 (Docs) → Available"
    else
        echo -e "  ${YELLOW}○${NC} Context7 (optional) → Install Node.js to enable"
    fi
    
    echo ""
    echo -e "${CYAN}${BOLD}Next Steps:${NC}"
    echo -e "  1. ${BOLD}Restart OpenCode${NC} to load the agent"
    echo -e "  2. ${BOLD}Try:${NC} 'How do I use React hooks?' (uses Context7)"
    echo -e "  3. ${BOLD}Try:${NC} 'Remember to use TypeScript strict mode' (uses Engram)"
    
    if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
        echo ""
        echo -e "${YELLOW}⚠ Add to your shell profile:${NC}"
        echo -e "  ${DIM}export PATH=\"\$PATH:$LOCAL_BIN\"${NC}"
    fi
    
    echo ""
    echo -e "${DIM}Config: $CONFIG_PATH${NC}"
    echo -e "${DIM}Docs: https://github.com/RETBOT/ai-agents${NC}"
}

# Main execution
main() {
    detect_os
    set_paths
    print_banner
    check_prerequisites
    
    # Install components
    install_engram
    install_context7
    clone_or_update_repo
    validate_agent
    create_directories
    install_agent
    configure_mcp_servers
    configure_opencode
    create_project_engram
    
    print_completion
}

# Run main
main "$@"
