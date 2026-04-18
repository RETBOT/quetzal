.PHONY: install install-windows install-unix update uninstall help

# Default target
default: help

# Detect OS and install accordingly
install:
	@echo "🔍 Detecting OS..."
	@case "$$(uname -s)" in \
		MINGW*|MSYS*|CYGWIN*|Windows*) \
			echo "Detected Windows - running PowerShell installer..." && \
			powershell -ExecutionPolicy Bypass -File install.ps1 \
			;; \
		*) \
			echo "Detected Unix-like system - running Bash installer..." && \
			chmod +x install.sh && ./install.sh \
			;; \
	esac

# Force Unix installer (for Git Bash, WSL, Linux, macOS)
install-unix:
	@echo "🐧 Running Unix installer..."
	@chmod +x install.sh && ./install.sh

# Force Windows installer
install-windows:
	@echo "🪟 Running Windows installer..."
	@powershell -ExecutionPolicy Bypass -File install.ps1

# Update (same as install - handles updates automatically)
update: install

# Uninstall agent
uninstall:
	@echo "🗑️  Removing Quetzal..."
	@rm -rf "$(HOME)/.opencode/agents/quetzal"
	@echo "✅ Agent removed. Note: Config in agents.json may need manual cleanup."

# Help
help:
	@echo "🧠 Quetzal Agent Installer"
	@echo ""
	@echo "Available targets:"
	@echo "  make install          - Auto-detect OS and install"
	@echo "  make install-unix     - Force Unix/Bash installer"
	@echo "  make install-windows  - Force PowerShell installer"
	@echo "  make update           - Update to latest version"
	@echo "  make uninstall        - Remove Quetzal agent"
	@echo "  make help             - Show this help"
	@echo ""
	@echo "Direct usage:"
	@echo "  ./install.sh          - Unix/Linux/macOS/Git Bash"
	@echo "  .\install.ps1         - Windows PowerShell"
	@echo "  make install          - Any platform (recommended)"
