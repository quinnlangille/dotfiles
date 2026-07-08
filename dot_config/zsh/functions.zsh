# Custom Functions

# =============================================================================
# Terminal Integration
# =============================================================================
# Report working directory to terminal via OSC 7
_osc7_cwd() {
  printf '\e]7;file://%s%s\e\\' "${HOST}" "${PWD}"
}

# Update tmux window name to current project/directory
_tmux_window_name() {
  if [[ -n "$TMUX" ]]; then
    local name="$("$HOME/.local/bin/tmux-window-name" "$PWD")"
    tmux rename-window "$name"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _osc7_cwd
add-zsh-hook chpwd _tmux_window_name
_osc7_cwd  # Report initial directory on shell start
_tmux_window_name  # Set initial window name

# =============================================================================
# Utility Functions
# =============================================================================
# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.tar.xz)  tar xJf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick grep in files
grepf() {
  grep -rn "$1" "${2:-.}"
}

# Find file by name
ff() {
  find . -name "*$1*"
}

# Show top processes by memory
topmem() {
  ps aux --sort=-%mem | head -n "${1:-10}"
}

# Show top processes by CPU
topcpu() {
  ps aux --sort=-%cpu | head -n "${1:-10}"
}

# Quick backup of a file
backup() {
  cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
}

# fzf-powered functions (if fzf available)
if command -v fzf &>/dev/null; then
  # cd with fzf
  fcd() {
    local dir
    dir=$(fd --type d --hidden --exclude .git 2>/dev/null | fzf +m) && cd "$dir"
  }

  # edit with fzf
  fe() {
    local file
    file=$(fzf --preview 'bat --style=numbers --color=always {}' --preview-window=right:60%) && ${EDITOR:-nvim} "$file"
  }

  # git checkout branch with fzf
  fco() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout "$(echo "$branch" | sed 's/.* //' | sed 's#remotes/[^/]*/##')"
  }

  # kill process with fzf
  fkill() {
    local pid
    pid=$(ps aux | sed 1d | fzf -m | awk '{print $2}')
    if [[ -n "$pid" ]]; then
      echo "$pid" | xargs kill -${1:-9}
    fi
  }
fi

# =============================================================================
# herdr: per-host tab naming + pane tint on interactive SSH
# =============================================================================
# When you `ssh <host>` inside herdr, the current tab is renamed to the host,
# a bright per-host banner is printed, and the pane background is tinted (if
# herdr honors OSC 11). Only fires for interactive logins inside herdr; plain
# `ssh host <cmd>`, scp, and git-over-ssh are untouched.
#
# Colors mirror ~/.local/share/chezmoi/.chezmoidata.yaml `machines:` accents.
# Add a host by extending both maps below. Manual rename still works anytime
# (prefix+shift+t, or `herdr tab rename <tab_id> <name>`); this only sets the
# name on connect and never overrides a later manual rename.
if [[ -n "$HERDR_ENV" ]]; then
  # Bright accent (banner) — keep in sync with .chezmoidata.yaml
  typeset -gA _herdr_host_accent=(
    megaboss       "#f9e2af"   # yellow
    megaboss-local "#f9e2af"
    miniboss       "#74c7ec"   # sapphire
    big-rig-gaming "#94e2d5"   # teal
  )
  # Dark, readable pane background per host (OSC 11 tint)
  typeset -gA _herdr_host_bg=(
    megaboss       "#2b2600"
    megaboss-local "#2b2600"
    miniboss       "#01212b"
    big-rig-gaming "#04231f"
  )

  _herdr_hex_rgb() {  # "#rrggbb" -> "r;g;b"
    local h="$1"; print -r -- "$(( 16#${h[2,3]} ));$(( 16#${h[4,5]} ));$(( 16#${h[6,7]} ))"
  }
  _herdr_banner() {   # $1 accent hex, $2 label
    printf '\e[48;2;%sm\e[38;2;0;0;0m %s \e[0m\n' "$(_herdr_hex_rgb "$1")" "$2"
  }

  ssh() {
    emulate -L zsh
    # Only decorate interactive logins inside herdr with a real tty.
    if [[ -z "$HERDR_ENV" || ! -t 1 ]]; then command ssh "$@"; return; fi

    # Find the destination and detect a trailing remote command.
    local -a a=("$@"); local wantsarg="bcDeFIiJLlmOopQRSWw"
    local host="" hadcmd=0 i=1 tok
    while (( i <= $#a )); do
      tok="${a[i]}"
      if [[ "$tok" == -- ]]; then :
      elif [[ "$tok" == -?* ]]; then
        # consume an option-argument for flags that take one (e.g. -p 22, -o ...)
        [[ ${#tok} -eq 2 && "$wantsarg" == *"${tok[2]}"* ]] && (( i++ ))
      elif [[ -z "$host" ]]; then host="$tok"
      else hadcmd=1; break; fi
      (( i++ ))
    done
    if [[ -z "$host" || $hadcmd -eq 1 ]]; then command ssh "$@"; return; fi

    local label="${host#*@}"                     # strip user@
    [[ -n "$HERDR_TAB_ID" ]] && herdr tab rename "$HERDR_TAB_ID" "$label" >/dev/null 2>&1
    local accent="${_herdr_host_accent[$label]}" bg="${_herdr_host_bg[$label]}"
    [[ -n "$accent" ]] && _herdr_banner "$accent" "$label"
    [[ -n "$bg" ]] && printf '\e]11;%s\e\\' "$bg"   # set pane background

    command ssh "$@"
    local rc=$?
    [[ -n "$bg" ]] && printf '\e]111\e\\'           # reset pane background
    return $rc
  }
fi
