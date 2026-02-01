# Custom Functions

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
