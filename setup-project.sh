#!/bin/bash
# =============================================================================
# Project Setup Script
# =============================================================================
# Links a project repo to the central ~/.dev-env/ agentic infrastructure.
# Run this once per project repo to enable the orchestrator.
#
# Usage:
#   ~/.dev-env/setup-project.sh /path/to/your/project-repo
#
# What it does:
#   1. Creates .cursor/rules/ and symlinks the orchestrator rule
#   2. Symlinks .claude/agents/ to the central agent definitions
#   3. Creates a CLAUDE.md that references the orchestrator prompt
#
# =============================================================================

set -e

DEV_ENV="$HOME/.dev-env"
PROJECT_DIR="${1:-.}"

# Resolve to absolute path
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

echo "================================================"
echo "  Agentic Dev Environment - Project Setup"
echo "================================================"
echo ""
echo "Project: $PROJECT_DIR"
echo "Dev Env: $DEV_ENV"
echo ""

# --- Cursor Setup ---
echo "[Cursor] Setting up orchestrator rule..."
mkdir -p "$PROJECT_DIR/.cursor/rules"

# Symlink orchestrator rule
if [ -L "$PROJECT_DIR/.cursor/rules/orchestrator.md" ]; then
    echo "  - orchestrator.md symlink already exists, updating..."
    rm "$PROJECT_DIR/.cursor/rules/orchestrator.md"
fi
ln -s "$DEV_ENV/orchestrator/cursor-orchestrator-rule.md" "$PROJECT_DIR/.cursor/rules/orchestrator.md"
echo "  - Created: .cursor/rules/orchestrator.md -> ~/.dev-env/orchestrator/cursor-orchestrator-rule.md"

echo ""

# --- Claude Code Setup ---
echo "[Claude Code] Setting up agents directory..."
mkdir -p "$PROJECT_DIR/.claude"

# Symlink agents directory
if [ -L "$PROJECT_DIR/.claude/agents" ]; then
    echo "  - agents/ symlink already exists, updating..."
    rm "$PROJECT_DIR/.claude/agents"
elif [ -d "$PROJECT_DIR/.claude/agents" ]; then
    echo "  WARNING: .claude/agents/ is a real directory, not a symlink."
    echo "  Backing up to .claude/agents.bak/ and replacing with symlink."
    mv "$PROJECT_DIR/.claude/agents" "$PROJECT_DIR/.claude/agents.bak"
fi
ln -s "$DEV_ENV/agents" "$PROJECT_DIR/.claude/agents"
echo "  - Created: .claude/agents/ -> ~/.dev-env/agents/"

echo ""

# --- CLAUDE.md Setup ---
echo "[Claude Code] Setting up CLAUDE.md..."
if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
    echo "  - CLAUDE.md already exists. Checking for orchestrator reference..."
    if grep -q "claude-orchestrator.md" "$PROJECT_DIR/CLAUDE.md"; then
        echo "  - Orchestrator reference already present. Skipping."
    else
        echo "  - WARNING: CLAUDE.md exists but doesn't reference the orchestrator."
        echo "  - Add this line to the top of your CLAUDE.md:"
        echo ""
        echo '    Read and follow all instructions in @~/.dev-env/orchestrator/claude-orchestrator.md'
        echo ""
    fi
else
    cat > "$PROJECT_DIR/CLAUDE.md" << 'CLAUDEMD'
Read and follow all instructions in @~/.dev-env/orchestrator/claude-orchestrator.md

# Project Context

<!-- Add project-specific context below -->
<!-- This is loaded at session start in Claude Code -->

## Project
- Name: [PROJECT_NAME]
- Stack: [TECH_STACK]
- Description: [BRIEF_DESCRIPTION]
CLAUDEMD
    echo "  - Created: CLAUDE.md with orchestrator reference"
    echo "  - NOTE: Edit CLAUDE.md to fill in your project details"
fi

echo ""
echo "================================================"
echo "  Setup Complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo "  1. Edit CLAUDE.md to add project-specific context"
echo "  2. Update ~/.dev-env/orchestrator/manifest.yaml to add this project"
echo "  3. Open the project in Cursor or Claude Code -- the orchestrator is active!"
echo ""
echo "To add this project to the manifest:"
echo ""
echo "  - name: $(basename $PROJECT_DIR)"
echo "    repo_path: $PROJECT_DIR"
echo "    stack: [YOUR_TECH_STACK]"
echo "    summary: \"[BRIEF_DESCRIPTION]\""
echo "    related_to: []"
echo ""
