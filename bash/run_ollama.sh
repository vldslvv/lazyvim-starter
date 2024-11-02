#!/usr/bin/env bash
set -euo pipefail

# ---- Defaults ----
DEFAULT_OLLAMA_PATH="$HOME/code/ollama"
DEFAULT_OLLAMA_MODEL="codellama:7b"
SESSION_NAME="ollama_session"

# ---- Parameters with fallback ----
OLLAMA_MODEL="${1:-$DEFAULT_OLLAMA_MODEL}"
OLLAMA_PATH="${2:-$DEFAULT_OLLAMA_PATH}"

# ---- Validation ----
if [[ ! -d "$OLLAMA_PATH" ]]; then
    echo "Error: OLLAMA_PATH does not exist: $OLLAMA_PATH"
    exit 1
fi

if ! command -v tmux >/dev/null 2>&1; then
    echo "Error: tmux not installed"
    exit 1
fi

# ---- Kill existing session if present ----
tmux has-session -t "$SESSION_NAME" 2>/dev/null && tmux kill-session -t "$SESSION_NAME"

# ---- Create new session ----
tmux new-session -d -s "$SESSION_NAME"

# Pane 1: Ollama server + model
tmux send-keys -t "$SESSION_NAME" \
    "cd \"$OLLAMA_PATH\" && make run && make run-model MODEL=${OLLAMA_MODEL}" C-m

# Pane 2: ollama-copilot
tmux split-window -t "$SESSION_NAME"
tmux send-keys -t "$SESSION_NAME" \
    "sleep 10 && ollama-copilot -model ${OLLAMA_MODEL}" C-m

# Optional: vertical layout (side-by-side)
tmux select-layout -t "$SESSION_NAME" even-horizontal

# Attach
tmux attach -t "$SESSION_NAME"
