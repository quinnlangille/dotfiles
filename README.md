# Quinn's Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io/).

## Philosophy

**Minimal, functional, and intentional.** Every config should earn its place.

- **No bloat** — Only add what's actively used. Remove what isn't.
- **Readable over clever** — Prefer simple shell scripts over complex one-liners.
- **Cross-platform by default** — Use chezmoi templates for OS-specific logic.
- **Useful at a glance** — Status bars show actionable info (project name, system stats), not decoration.
- **Low maintenance** — Avoid plugins and dependencies where native solutions work.

## Quick Start (New Machine)

```bash
# Install chezmoi and apply dotfiles in one command
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply quinnlangille
```

Or if chezmoi is already installed:

```bash
chezmoi init --apply quinnlangille
```

## Dependencies

### Linux (Arch/CachyOS)

```bash
sudo pacman -S tmux wl-clipboard zsh
```

### macOS

```bash
brew install tmux
```

## Customizing for Your Machine

Each machine can have its own accent color and label. Edit `.chezmoidata.yaml`:

```yaml
machines:
  your-hostname:        # Run `hostname` to get this
    accent: "#b4befe"   # Pick from palette below
    label: "short-name" # Shows in tmux status bar
```

### Catppuccin Mocha Palette

| Color     | Hex       | Preview |
|-----------|-----------|---------|
| Rosewater | `#f5e0dc` | Pink-ish white |
| Flamingo  | `#f2cdcd` | Soft pink |
| Pink      | `#f5c2e7` | Pink |
| Mauve     | `#cba6f7` | Purple |
| Red       | `#f38ba8` | Red |
| Maroon    | `#eba0ac` | Dark pink |
| Peach     | `#fab387` | Orange |
| Yellow    | `#f9e2af` | Yellow |
| Green     | `#a6e3a1` | Green |
| Teal      | `#94e2d5` | Teal |
| Sky       | `#89dceb` | Light blue |
| Sapphire  | `#74c7ec` | Blue |
| Blue      | `#89b4fa` | Blue |
| Lavender  | `#b4befe` | Lavender |

If your machine isn't listed, it falls back to:
- **macOS**: Blue (`#89b4fa`)
- **Linux**: Green (`#a6e3a1`)

## What's Included

| Config | Description |
|--------|-------------|
| `tmux` | Catppuccin theme, Ctrl+a prefix, CPU/mem stats, git-aware window names |
| `ghostty` | Terminal config with OS-specific keybindings |
| `nvim` | Neovim based on kickstart.nvim |
| `zsh` | oh-my-zsh configuration |
| `MangoHud` | Gaming overlay (Linux only) |
| `herdr` | Terminal multiplexer with agent sidebar; tmux keybindings ported |
| `pi` | Coding agent CLI, pinned version, OpenRouter as provider |

## Tmux Nested Sessions

When SSH'd into another machine running tmux, press `F12` to toggle the outer tmux off. The status bar dims and shows "OFF", and all keys pass through to the inner tmux. Press `F12` again to re-enable.

## Machine-Local Secrets

API keys live in `~/.config/zsh/secrets.zsh` — **untracked, mode 600, never in this repo**.
`chezmoi init --apply` does not create it; every new machine needs it written by hand:

```bash
install -m 600 /dev/null ~/.config/zsh/secrets.zsh
cat >> ~/.config/zsh/secrets.zsh <<'EOF'
export OPENROUTER_API_KEY=sk-or-v1-...
EOF
```

`.zshrc` sources it last, so exports here are inherited by every child process in the
session. For anything that isn't genuinely global, prefer a per-project `.envrc` (direnv).

## pi (Coding Agent)

[pi](https://pi.dev) is installed by `run_onchange_10-install-pi.sh` at a **pinned version**,
into `~/.local` rather than the fnm node tree — so `fnm use <other-version>` doesn't lose it.

| Path | What it is |
|------|-----------|
| `run_onchange_10-install-pi.sh` | Installer; owns which version every machine runs |
| `private_dot_pi/private_agent/create_private_settings.json` | Seed for `~/.pi/agent/settings.json` |

**Upgrading:** bump `PI_VERSION` in the install script, commit, then `chezmoi apply` on each
machine. Do **not** run `pi update` — it installs outside the prefix and drifts from the repo.
Requires Node >= 22.19.0; the script fails loudly rather than letting npm install a broken tree.

**Provider:** OpenRouter, via `OPENROUTER_API_KEY` (see Machine-Local Secrets above). Without
it pi starts with zero models. Switch models in-session with `/model`; Ctrl+S saves the default.

**Why the settings seed is `create_`:** pi writes `~/.pi/agent/settings.json` itself whenever you
use `/settings` or Ctrl+S. A normally-managed file would make every in-app preference change
look like drift, and `chezmoi apply` would silently revert it. `create_` seeds new machines and
then leaves the file alone — so changing the seed does **not** propagate to existing machines.

pi's runtime state (`auth.json`, `trust.json`, `sessions/`, caches) is listed in `.chezmoiignore`,
so `chezmoi add ~/.pi` can never sweep credentials into git.

## Common Commands

```bash
chezmoi diff          # Preview pending changes
chezmoi apply         # Apply changes to home directory
chezmoi edit <file>   # Edit a managed file
chezmoi add <file>    # Add a new file to management
chezmoi update        # Pull from git and apply
chezmoi cd            # cd to source directory
```

## Adding New Configs

```bash
# Add a config file
chezmoi add ~/.config/something/config

# Add as a template (for OS-specific content)
chezmoi add --template ~/.config/something/config
```

## Pushing Changes

```bash
chezmoi cd
git add -A && git commit -m "description" && git push
```
