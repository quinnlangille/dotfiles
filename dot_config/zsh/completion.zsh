# Completion System Configuration

# Note: compinit is handled by zinit in plugins.zsh (zicompinit)
# Only load compinit here if zinit hasn't been sourced
if (( ! ${+functions[zinit]} )); then
  autoload -Uz compinit
  if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
fi

# Completion options
setopt COMPLETE_IN_WORD    # Complete from both ends of a word
setopt ALWAYS_TO_END       # Move cursor to end after completion
setopt AUTO_MENU           # Show menu on second tab
setopt AUTO_LIST           # List choices on ambiguous completion
setopt AUTO_PARAM_SLASH    # Add trailing slash to directories
setopt NO_MENU_COMPLETE    # Don't autoselect first completion

# Completion styling
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

# Group completions by category
zstyle ':completion:*' group-name ''
# Use ANSI codes for fzf-tab compatibility (zsh %F codes don't work in fzf)
zstyle ':completion:*:descriptions' format $'\e[33m-- %d --\e[0m'
zstyle ':completion:*:corrections' format $'\e[32m-- %d (errors: %e) --\e[0m'
zstyle ':completion:*:messages' format $'\e[35m-- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[31m-- no matches found --\e[0m'

# Process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Man page completion
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Create cache directory
[[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]] || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
