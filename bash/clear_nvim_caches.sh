#!/usr/bin/env bash
set -euo pipefail

# Directories to clean
NVIM_CACHE="${HOME}/.cache/nvim"
NVIM_SHARE="${HOME}/.local/share/nvim"
NVIM_STATE="${HOME}/.local/state/nvim"

DIRS=(
  "$NVIM_CACHE"
  "$NVIM_SHARE"
  "$NVIM_STATE"
)

echo "The following Neovim directories will be removed:"
for dir in "${DIRS[@]}"; do
  echo "  $dir"
done

read -rp "Continue? [y/N]: " confirm
if [[ "${confirm:-}" != "y" && "${confirm:-}" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

for dir in "${DIRS[@]}"; do
  if [[ -d "$dir" ]]; then
    echo "Removing $dir"
    rm -rf --one-file-system "$dir"
  else
    echo "Skipping $dir (not found)"
  fi
done

echo "Done."
