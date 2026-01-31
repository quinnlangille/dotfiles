# Quinn's Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io/).

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
| `tmux` | Catppuccin theme, Ctrl+a prefix, F12 nested session toggle |
| `ghostty` | Terminal config with OS-specific keybindings |
| `nvim` | Neovim based on kickstart.nvim |
| `zsh` | oh-my-zsh configuration |
| `MangoHud` | Gaming overlay (Linux only) |

## Tmux Nested Sessions

When SSH'd into another machine running tmux, press `F12` to toggle the outer tmux off. The status bar dims and shows "OFF", and all keys pass through to the inner tmux. Press `F12` again to re-enable.

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
