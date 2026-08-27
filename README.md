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
| `opencode` | Coding agent CLI, pinned version, OpenRouter as provider |

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

## Coding Agents (pi, opencode)

Both [pi](https://pi.dev) and [opencode](https://opencode.ai) are installed at **pinned
versions** into `~/.local`, by `run_onchange_10-install-pi.sh` and
`run_onchange_11-install-opencode.sh`. Installing outside the fnm node tree means
`fnm use <other-version>` doesn't lose them.

| Agent | Config (managed) | Upgrade by |
|-------|------------------|-----------|
| `pi` | `~/.pi/agent/settings.json` (seeded once) | bump `PI_VERSION` |
| `opencode` | `~/.config/opencode/opencode.json` (fully managed) | bump `OPENCODE_VERSION` |

**Upgrading:** bump the version in the relevant install script, commit, then `chezmoi apply`
on each machine. Do **not** use `pi update` or `opencode upgrade` — both install outside the
prefix and drift from the repo.

**Provider:** both use OpenRouter via `OPENROUTER_API_KEY` (see Machine-Local Secrets above).
Neither needs its own login; without the key both start with zero models. Runtime state
(credentials, sessions, caches) is listed in `.chezmoiignore`, so `chezmoi add` can never
sweep credentials into git.

**Permissions:** opencode's config sets `"permission": "allow"`, so it never prompts.
Its defaults only ask for three things — shell commands touching paths outside the project
(`external_directory`), the runaway-loop guard (`doom_loop`), and reading `*.env` files.
Blanket allow drops all three, including the `.env` read guard: the agent can read a project's
`.env` and send it to the model. Narrow it with the object form if that matters on a machine:

```json
{ "permission": { "external_directory": "allow", "doom_loop": "allow" } }
```

### Why the two configs are managed differently

`opencode.json` is read-only to opencode, so it is a normal managed file — edit it here and
the change propagates to every machine on `chezmoi update`.

pi is different: it **writes** `~/.pi/agent/settings.json` itself whenever you use `/settings`
or Ctrl+S in `/model`. Managing it normally would make every in-app preference change look
like drift, and `chezmoi apply` would silently revert it. So the source file uses chezmoi's
`create_` attribute: it seeds new machines and then leaves the file alone. Consequence:
**changing the pi seed does not propagate to machines that already have the file.**

### Install-flag gotcha

pi is installed with `--ignore-scripts` (it needs no lifecycle scripts). opencode is **not** —
its `postinstall` picks the right native binary out of its `optionalDependencies` and copies it
into `bin/`. Skipping it leaves a non-functional stub. Don't unify the two flags.

pi additionally requires Node >= 22.19.0 at runtime; opencode ships a native binary and needs
node only to install.

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
