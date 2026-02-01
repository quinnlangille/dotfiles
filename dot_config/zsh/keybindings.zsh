# Key Bindings

# Use emacs keybindings
bindkey -e

# History search with up/down arrows
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search    # Up
bindkey '^[[B' down-line-or-beginning-search  # Down
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# Word navigation
bindkey '^[[1;5C' forward-word     # Ctrl+Right
bindkey '^[[1;5D' backward-word    # Ctrl+Left
bindkey '^[[H' beginning-of-line   # Home
bindkey '^[[F' end-of-line         # End

# Delete word
bindkey '^[[3;5~' kill-word        # Ctrl+Delete
bindkey '^H' backward-kill-word    # Ctrl+Backspace

# Edit command in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# fzf key bindings (if available)
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
fi
if [[ -f /usr/share/fzf/completion.zsh ]]; then
  source /usr/share/fzf/completion.zsh
fi
