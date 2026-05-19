#!/usr/bin/env bash
#
# install-deps.sh — Verify and install dependencies for Deliberate_Agents
#
# Checks for required tools: tmux, claude (Claude Code CLI), git
# Optionally installs missing dependencies via Homebrew.
#
# Usage: install-deps.sh [--check-only]

set -euo pipefail

CHECK_ONLY=false
if [[ "${1:-}" == "--check-only" ]]; then
  CHECK_ONLY=true
fi

errors=0
warnings=0

check_command() {
  local cmd="$1"
  local desc="$2"
  local install_hint="$3"
  local required="${4:-true}"

  if command -v "$cmd" &>/dev/null; then
    local version
    version="$("$cmd" --version 2>/dev/null | head -1 || echo "installed")"
    echo "  [OK] $cmd — $version"
  else
    if [[ "$required" == "true" ]]; then
      echo "  [MISSING] $cmd — $desc"
      echo "            Install: $install_hint"
      ((errors++))
    else
      echo "  [OPTIONAL] $cmd — $desc (not found)"
      echo "             Install: $install_hint"
      ((warnings++))
    fi
  fi
}

echo "Deliberate_Agents — Dependency Check"
echo "====================================="
echo ""

echo "Required:"
check_command "tmux"    "Terminal multiplexer for agent sessions" "brew install tmux"
check_command "claude"  "Claude Code CLI for headless agent execution" "See https://docs.anthropic.com/en/docs/claude-code"
check_command "git"     "Version control" "brew install git"
check_command "it2"     "iTerm2 CLI for split-pane agent teams" "pip3 install it2"

echo ""
echo "Optional:"
check_command "yq"      "YAML processor (enables richer config parsing)" "brew install yq" "false"
check_command "jq"      "JSON processor (useful for log analysis)" "brew install jq" "false"
check_command "node"    "Node.js runtime (required for MCP servers)" "brew install node" "false"
check_command "npm"     "Node package manager (required for MCP servers)" "brew install node" "false"

echo ""

if command -v tmux &>/dev/null; then
  tmux_version="$(tmux -V | sed 's/tmux //')"
  major="${tmux_version%%.*}"
  if (( major < 3 )); then
    echo "  [WARN] tmux version $tmux_version detected. Version 3.0+ is recommended."
    ((warnings++))
  fi
fi

echo "====================================="
if (( errors > 0 )); then
  echo "RESULT: $errors required dependency/dependencies missing."
  if ! $CHECK_ONLY; then
    echo ""
    read -rp "Attempt to install missing dependencies via Homebrew? [y/N] " confirm
    if [[ "$confirm" == [yY] ]]; then
      if ! command -v brew &>/dev/null; then
        echo "ERROR: Homebrew not found. Install manually."
        exit 1
      fi
      command -v tmux  &>/dev/null || brew install tmux
      command -v git   &>/dev/null || brew install git
      command -v it2   &>/dev/null || pip3 install it2
      echo ""
      echo "Note: Claude Code CLI must be installed separately."
      echo "See: https://docs.anthropic.com/en/docs/claude-code"
      echo ""
      echo "For iTerm2 split panes: enable Python API in iTerm2 → Settings → General → Magic"
    fi
  fi
  exit 1
elif (( warnings > 0 )); then
  echo "RESULT: All required dependencies found. $warnings optional dependency/dependencies missing."
  exit 0
else
  echo "RESULT: All dependencies satisfied."
  exit 0
fi
