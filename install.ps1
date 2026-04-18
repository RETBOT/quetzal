#Requires -Version 5.1
<#
.SYNOPSIS
    Quetzal AI Agent Installer + Ecosystem Setup for Windows
    
.DESCRIPTION
    Installs the complete Quetzal AI ecosystem:
    - Quetzal Agent (AI Architect)
    - Engram (Persistent Memory)
    - Context7 (Library Documentation)
    
    Inspired by: Gentleman AI (gentleman-programming/gentle-ai)
    
.EXAMPLE
    # Run directly:
    .\install.ps1
    
    # Or with bypass (if execution policy blocks):
    powershell -ExecutionPolicy Bypass -File install.ps1
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

# ============================================================================
# Configuration
# ============================================================================

$GITHUB_OWNER = "RETBOT"
$GITHUB_REPO = "ai-agents"
$REPO_URL = "https://github.com/RETBOT/ai-agents.git"
$AGENT_NAME = "quetzal"
$AGENT_DIR = "quetzal"
$ENGRAM_REPO = "https://github.com/Gentleman-Programming/engram.git"

# Paths
$RepoDir = "$env:USERPROFILE\ai-agents"
$InstallDir = "$env:USERPROFILE\.opencode\agents"
$ConfigPath = "$env:USERPROFILE\.opencode\agents.json"
$EngramDir = "$env:USERPROFILE\.engram"
$EngramBin = "$env:USERPROFILE\.local\bin\engram.exe"
$McpConfigDir = "$env:USERPROFILE\.opencode\mcp"
$LocalBin = "$env:USERPROFILE\.local\bin"

# ============================================================================
# Logging helpers
# ============================================================================

function Write-Info    { param([string]$Message) Write-Host "[info]    $Message" -ForegroundColor Blue }
function Write-Success { param([string]$Message) Write-Host "[ok]      $Message" -ForegroundColor Green }
function Write-Warn    { param([string]$Message) Write-Host "[warn]    $Message" -ForegroundColor Yellow }
function Write-Err     { param([string]$Message) Write-Host "[error]   $Message" -ForegroundColor Red }
function Write-Step    { param([string]$Message) Write-Host "`n==> $Message" -ForegroundColor Cyan }

function Stop-WithError {
    param([string]$Message)
    Write-Err $Message
    exit 1
}

# ============================================================================
# Banner
# ============================================================================

function Show-Banner {
    Write-Host ""
    Write-Host "  🧠 Quetzal AI Agent + Ecosystem" -ForegroundColor Cyan
    Write-Host "  =================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Your AI architect with memory & knowledge" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Detected OS: Windows (PowerShell)" -ForegroundColor Yellow
    Write-Host ""
}

# ============================================================================
# Prerequisites
# ============================================================================

function Test-Prerequisites {
    Write-Step "Checking prerequisites"
    
    $missing = @()
    
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        $missing += "git"
    }
    
    if (-not (Get-Command curl -ErrorAction SilentlyContinue)) {
        $missing += "curl"
    }
    
    if ($missing.Count -gt 0) {
        Stop-WithError "Missing required tools: $($missing -join ', '). Please install them and try again."
    }
    
    Write-Success "All prerequisites met"
}

# ============================================================================
# Install Engram (Persistent Memory)
# ============================================================================

function Install-Engram {
    Write-Step "Installing Engram (Persistent Memory)"
    
    # Check if already installed
    $engramInstalled = $false
    if (Get-Command engram -ErrorAction SilentlyContinue) {
        $engramInstalled = $true
    } elseif (Test-Path $EngramBin) {
        $engramInstalled = $true
    }
    
    if ($engramInstalled) {
        Write-Success "Engram already installed"
        
        # Update if it's a git repo
        if (Test-Path "$EngramDir\.git") {
            Write-Info "Updating Engram..."
            Push-Location $EngramDir
            git pull --quiet 2>$null
            Pop-Location
        }
        return
    }
    
    # Clone Engram
    Write-Info "Downloading Engram..."
    
    if (Test-Path $EngramDir) {
        Remove-Item -Path $EngramDir -Recurse -Force
    }
    
    try {
        git clone --quiet --depth 1 $ENGRAM_REPO $EngramDir 2>$null
    } catch {
        Write-Warn "Could not clone Engram repository"
        Write-Warn "Skipping Engram installation (optional)"
        return
    }
    
    # Build Engram (requires Go)
    if (Get-Command go -ErrorAction SilentlyContinue) {
        Write-Info "Building Engram from source..."
        Push-Location $EngramDir
        
        try {
            go build -o $EngramBin .\cmd\engram 2>$null
            if (Test-Path $EngramBin) {
                Write-Success "Engram built and installed"
            } else {
                throw "Build failed"
            }
        } catch {
            Write-Warn "Could not build Engram"
            Write-Warn "Install Go to enable persistent memory:"
            Write-Host "  https://go.dev/dl/" -ForegroundColor DarkGray
        }
        Pop-Location
    } else {
        Write-Warn "Go not found"
        Write-Warn "Install Go to enable Engram (optional):"
        Write-Host "  https://go.dev/dl/" -ForegroundColor DarkGray
    }
    
    # Create Engram config
    New-Item -ItemType Directory -Path $EngramDir -Force | Out-Null
    
    $engramConfig = @"
{
  ""version"": ""1.0"",
  ""storage"": {
    ""backend"": ""sqlite"",
    ""path"": ""~/.engram/data""
  },
  ""sync"": {
    ""enabled"": true,
    ""auto_sync"": true
  },
  ""mcp"": {
    ""enabled"": true
  }
}
"@
    
    $engramConfigPath = Join-Path $EngramDir "engram.json"
    if (-not (Test-Path $engramConfigPath)) {
        $engramConfig | Out-File -FilePath $engramConfigPath -Encoding utf8
        Write-Success "Engram configuration created"
    }
    
    # Ensure local bin is in PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$LocalBin*") {
        Write-Warn "Add to your PATH:"
        Write-Host "  [Environment]::SetEnvironmentVariable('Path', `$env:Path + ';$LocalBin', 'User')" -ForegroundColor DarkGray
    }
}

# ============================================================================
# Install Context7 (Library Documentation)
# ============================================================================

function Install-Context7 {
    Write-Step "Installing Context7 (Library Documentation)"
    
    # Check if Node.js is available
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Warn "Node.js not found"
        Write-Warn "Install Node.js to enable Context7 (optional):"
        Write-Host "  https://nodejs.org/" -ForegroundColor DarkGray
        return
    }
    
    # Check if already installed globally
    if (Get-Command ctx7 -ErrorAction SilentlyContinue) {
        Write-Success "Context7 (ctx7) already installed"
        Write-Info "Updating Context7..."
        npm update -g @upstash/context7-mcp 2>$null
        return
    }
    
    # Install via npm
    Write-Info "Installing Context7 via npm..."
    try {
        npm install -g @upstash/context7-mcp 2>$null
        Write-Success "Context7 installed globally"
        
        # Run setup if ctx7 is available
        if (Get-Command ctx7 -ErrorAction SilentlyContinue) {
            Write-Info "Running Context7 setup..."
            Write-Host "Note: You may need to authenticate via browser" -ForegroundColor DarkGray
            ctx7 setup --opencode 2>$null
        }
    } catch {
        Write-Warn "Could not install Context7 via npm"
        Write-Warn "You can install manually later:"
        Write-Host "  npm install -g @upstash/context7-mcp" -ForegroundColor DarkGray
    }
}

# ============================================================================
# Clone or Update Repository
# ============================================================================

function Update-Repository {
    Write-Step "Installing Quetzal Agent"
    
    if (-not (Test-Path $RepoDir)) {
        Write-Info "Cloning Quetzal repository..."
        git clone --quiet $REPO_URL $RepoDir
        Write-Success "Repository cloned"
    } else {
        Write-Info "Updating Quetzal repository..."
        Push-Location $RepoDir
        git pull --quiet
        Pop-Location
        Write-Success "Repository updated"
    }
}

# ============================================================================
# Validate Agent Exists
# ============================================================================

function Test-AgentExists {
    $SourcePath = "$RepoDir\$AgentDir"
    
    if (-not (Test-Path $SourcePath)) {
        Stop-WithError "Agent not found in repo: $AgentName`n  Expected: $SourcePath"
    }
    
    if (-not (Test-Path "$SourcePath\QUETZAL.md")) {
        Write-Warn "Warning: QUETZAL.md not found in agent directory"
    }
}

# ============================================================================
# Create Directories
# ============================================================================

function New-Directories {
    Write-Info "Creating directories..."
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    New-Item -ItemType Directory -Force -Path $LocalBin | Out-Null
    New-Item -ItemType Directory -Force -Path $McpConfigDir | Out-Null
}

# ============================================================================
# Install Agent
# ============================================================================

function Install-Agent {
    $SourcePath = "$RepoDir\$AgentDir"
    $TargetPath = "$InstallDir\$AgentName"
    
    # Remove existing installation
    if (Test-Path $TargetPath) {
        Write-Info "Updating agent..."
        Remove-Item $TargetPath -Force -Recurse
    } else {
        Write-Info "Installing agent..."
    }
    
    # Try symlink first, fall back to copy
    try {
        New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath | Out-Null
        Write-Success "Created symbolic link"
    } catch {
        Write-Warn "Symlink failed (run as Admin for symlinks), copying files..."
        Copy-Item -Path $SourcePath -Destination $TargetPath -Recurse -Force
        Write-Success "Files copied"
    }
}

# ============================================================================
# Configure MCP Servers
# ============================================================================

function Set-McpServers {
    Write-Step "Configuring MCP Servers"
    
    $mcpConfig = Join-Path $McpConfigDir "servers.json"
    
    # Build MCP config based on what's installed
    $mcpServers = @{
        mcpServers = @{
            context7 = @{
                command = "npx"
                args = @("-y", "@upstash/context7-mcp@latest")
            }
        }
    }
    
    # Add Engram if installed
    if ((Test-Path $EngramBin) -or (Get-Command engram -ErrorAction SilentlyContinue)) {
        $mcpServers.mcpServers.engram = @{
            command = "engram"
            args = @("mcp")
        }
    }
    
    $mcpServers | ConvertTo-Json -Depth 5 | Out-File -FilePath $mcpConfig -Encoding utf8
    
    Write-Success "MCP servers configured"
    Write-Host "  Location: $mcpConfig" -ForegroundColor DarkGray
}

# ============================================================================
# Configure OpenCode Agent
# ============================================================================

function Set-AgentConfig {
    Write-Step "Configuring OpenCode Agent"
    
    # Create config if it doesn't exist
    if (-not (Test-Path $ConfigPath)) {
        "{}" | Out-File $ConfigPath -Encoding utf8
    }
    
    # Build MCP server list
    $mcpList = @()
    
    if ((Test-Path $EngramBin) -or (Get-Command engram -ErrorAction SilentlyContinue)) {
        $mcpList += "engram"
    }
    
    if (Get-Command ctx7 -ErrorAction SilentlyContinue) {
        $mcpList += "context7"
    }
    
    # Read existing config
    $config = Get-Content $ConfigPath | ConvertFrom-Json
    
    # Add agent config
    $agentConfig = @{
        prompt = "{file:./$AgentName/QUETZAL.md}"
        tools = @{
            edit = $true
            write = $true
        }
        description = "Principal architect and mentor for scalable, maintainable systems"
        mode = "primary"
        mcpServers = $mcpList
    }
    
    $config | Add-Member -Force -MemberType NoteProperty -Name $AgentName -Value $agentConfig
    
    $config | ConvertTo-Json -Depth 5 | Out-File $ConfigPath -Encoding utf8
    
    Write-Success "Agent configuration updated"
}

# ============================================================================
# Create Project Engram
# ============================================================================

function New-ProjectEngram {
    if (Test-Path $RepoDir) {
        Write-Step "Setting up Project Memory"
        
        Push-Location $RepoDir
        
        # Create .engram directory
        if (-not (Test-Path ".engram")) {
            New-Item -ItemType Directory -Path ".engram" -Force | Out-Null
            
            $projectConfig = @"
{
  ""name"": ""ai-agents"",
  ""description"": ""Quetzal AI Agent with persistent memory"",
  ""auto_sync"": true
}
"@
            $projectConfig | Out-File -FilePath ".engram\project.json" -Encoding utf8
            Write-Success "Project memory directory created"
        }
        
        # Update .gitignore
        if (Test-Path ".gitignore") {
            $gitignoreContent = Get-Content ".gitignore" -Raw
            if ($gitignoreContent -notmatch "\.engram/data") {
                Add-Content -Path ".gitignore" -Value "`n# Engram memory data (sync memories, not raw data)" -Encoding utf8
                Add-Content -Path ".gitignore" -Value ".engram/data" -Encoding utf8
                Write-Success "Updated .gitignore"
            }
        }
        
        Pop-Location
    }
}

# ============================================================================
# Completion
# ============================================================================

function Show-Completion {
    Write-Host ""
    Write-Host "✅ Installation Complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Installed Components:" -ForegroundColor Cyan
    Write-Host "  ✓ Quetzal Agent → $InstallDir\$AgentName"
    
    if ((Test-Path $EngramBin) -or (Get-Command engram -ErrorAction SilentlyContinue)) {
        Write-Host "  ✓ Engram (Memory) → Available"
    } else {
        Write-Host "  ○ Engram (optional) → Install Go to enable" -ForegroundColor Yellow
    }
    
    if (Get-Command ctx7 -ErrorAction SilentlyContinue) {
        Write-Host "  ✓ Context7 (Docs) → Available"
    } else {
        Write-Host "  ○ Context7 (optional) → Install Node.js to enable" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "  1. Restart OpenCode to load the agent"
    Write-Host "  2. Try: 'How do I use React hooks?' (uses Context7)"
    Write-Host "  3. Try: 'Remember to use TypeScript strict mode' (uses Engram)"
    
    Write-Host ""
    Write-Host "Config: $ConfigPath" -ForegroundColor DarkGray
    Write-Host "Docs: https://github.com/RETBOT/ai-agents" -ForegroundColor DarkGray
}

# ============================================================================
# Main
# ============================================================================

function Main {
    Show-Banner
    Test-Prerequisites
    Install-Engram
    Install-Context7
    Update-Repository
    Test-AgentExists
    New-Directories
    Install-Agent
    Set-McpServers
    Set-AgentConfig
    New-ProjectEngram
    Show-Completion
}

Main
