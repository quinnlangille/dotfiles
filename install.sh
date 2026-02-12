#!/usr/bin/env bash
set -euo pipefail

# Bootstrap a fresh Mac from zero to fully configured.
# Usage: bash -c "$(curl -fsSL https://raw.githubusercontent.com/quinnlangille/dotfiles/main/install.sh)"

echo "==> Installing Xcode Command Line Tools (if missing)..."
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "Waiting for Xcode CLT installation to complete..."
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
fi

echo "==> Installing Homebrew (if missing)..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is on PATH for the rest of this script
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "==> Installing chezmoi..."
brew install chezmoi

echo "==> Applying dotfiles..."
chezmoi init --apply quinnlangille

echo "==> Done! Restart your shell to pick up all changes."
