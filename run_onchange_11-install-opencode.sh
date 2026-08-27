#!/usr/bin/env bash
# opencode coding agent (https://opencode.ai) — OS-agnostic, so no template branching.
#
# Version is pinned so every machine converges on the same build. To upgrade:
# bump OPENCODE_VERSION, commit, and `chezmoi apply` on each machine. Do NOT run
# `opencode upgrade` — it replaces the binary in place and drifts from the repo.
set -euo pipefail

OPENCODE_VERSION="1.18.23"
OPENCODE_PACKAGE="opencode-ai"
# ~/.local/bin is already on PATH (dot_zshrc.tmpl). The shipped artifact is a
# native binary, so unlike pi this does not depend on node at runtime.
OPENCODE_PREFIX="$HOME/.local"

echo "==> Installing opencode ${OPENCODE_VERSION}..."

if ! command -v npm &>/dev/null; then
  echo "ERROR: npm not found; needed to install opencode. Install node with fnm first." >&2
  exit 1
fi

installed=""
if [[ -x "$OPENCODE_PREFIX/bin/opencode" ]]; then
  installed="$("$OPENCODE_PREFIX/bin/opencode" --version 2>/dev/null || true)"
fi

if [[ "$installed" == "$OPENCODE_VERSION" ]]; then
  echo "==> opencode ${OPENCODE_VERSION} already installed at ${OPENCODE_PREFIX}/bin/opencode."
else
  # No --ignore-scripts here (unlike pi): opencode's postinstall selects the
  # platform binary out of its optionalDependencies and copies it into bin/.
  # Skipping it leaves a non-functional stub.
  npm install -g --prefix "$OPENCODE_PREFIX" "${OPENCODE_PACKAGE}@${OPENCODE_VERSION}"
  echo "==> opencode $("$OPENCODE_PREFIX/bin/opencode" --version) installed at ${OPENCODE_PREFIX}/bin/opencode."
fi

resolved="$(command -v opencode 2>/dev/null || true)"
if [[ "$resolved" != "$OPENCODE_PREFIX/bin/opencode" ]]; then
  echo "WARNING: 'opencode' on PATH resolves to '${resolved:-<none>}', not ${OPENCODE_PREFIX}/bin/opencode." >&2
  echo "         Remove the shadowing install or fix PATH order." >&2
fi

if [[ -z "${OPENROUTER_API_KEY:-}" ]]; then
  echo "NOTE: OPENROUTER_API_KEY is unset in this shell. opencode has no models without it."
  echo "      Add 'export OPENROUTER_API_KEY=...' to ~/.config/zsh/secrets.zsh (mode 600, untracked)."
fi
