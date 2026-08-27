#!/usr/bin/env bash
# pi coding agent (https://pi.dev) — OS-agnostic, so no template branching.
#
# Version is pinned so every machine converges on the same build. To upgrade:
# bump PI_VERSION, commit, and `chezmoi apply` on each machine. Do NOT use
# `pi update` — it would install outside this prefix and drift from the repo.
set -euo pipefail

PI_VERSION="0.84.3"
PI_PACKAGE="@earendil-works/pi-coding-agent"
# ~/.local/bin is already on PATH (dot_zshrc.tmpl) and is outside the fnm
# node-version tree, so `fnm use` on another version does not lose pi.
PI_PREFIX="$HOME/.local"

echo "==> Installing pi ${PI_VERSION}..."

if ! command -v node &>/dev/null; then
  echo "ERROR: node not found; pi requires Node >= 22.19.0. Install it with fnm first." >&2
  exit 1
fi

# pi's package engines field is >=22.19.0; npm only warns on mismatch, so fail loudly here.
if ! node -e '
  const cur = process.versions.node.split(".").map(Number);
  const min = [22, 19, 0];
  for (let i = 0; i < 3; i++) {
    if (cur[i] > min[i]) process.exit(0);
    if (cur[i] < min[i]) process.exit(1);
  }
  process.exit(0);
'; then
  echo "ERROR: node $(node --version) is too old; pi requires >= 22.19.0." >&2
  exit 1
fi

installed=""
if [[ -x "$PI_PREFIX/bin/pi" ]]; then
  installed="$("$PI_PREFIX/bin/pi" --version 2>/dev/null || true)"
fi

if [[ "$installed" == "$PI_VERSION" ]]; then
  echo "==> pi ${PI_VERSION} already installed at ${PI_PREFIX}/bin/pi."
else
  # --ignore-scripts: pi needs no dependency lifecycle scripts (per its README).
  npm install -g --ignore-scripts --prefix "$PI_PREFIX" "${PI_PACKAGE}@${PI_VERSION}"
  echo "==> pi $("$PI_PREFIX/bin/pi" --version) installed at ${PI_PREFIX}/bin/pi."
fi

# The bin is a symlink with a `#!/usr/bin/env node` shebang, so a stale copy
# earlier on PATH silently wins. Name it rather than let it confuse later debugging.
resolved="$(command -v pi 2>/dev/null || true)"
if [[ "$resolved" != "$PI_PREFIX/bin/pi" ]]; then
  echo "WARNING: 'pi' on PATH resolves to '${resolved:-<none>}', not ${PI_PREFIX}/bin/pi." >&2
  echo "         Remove the shadowing install or fix PATH order." >&2
fi

if [[ -z "${OPENROUTER_API_KEY:-}" ]]; then
  echo "NOTE: OPENROUTER_API_KEY is unset in this shell. pi has no models without it."
  echo "      Add 'export OPENROUTER_API_KEY=...' to ~/.config/zsh/secrets.zsh (mode 600, untracked)."
fi
