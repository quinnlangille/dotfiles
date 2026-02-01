#!/bin/bash
# Enable Tailscale SSH for secure remote access within tailnet
# This runs once per machine when chezmoi apply is executed

set -euo pipefail

# Skip if tailscale isn't installed
if ! command -v tailscale &> /dev/null; then
    echo "Tailscale not installed, skipping SSH setup"
    exit 0
fi

# Check if Tailscale SSH is already enabled
if tailscale status --json 2>/dev/null | grep -q '"SSH":true'; then
    echo "Tailscale SSH already enabled"
    exit 0
fi

echo "Enabling Tailscale SSH..."
sudo tailscale set --ssh

echo "Tailscale SSH enabled successfully"
echo "You can now SSH to this machine via: ssh $(whoami)@$(hostname)"
