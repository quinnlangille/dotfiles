# Zinit Plugin Manager
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Install zinit if not present
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  print -P "%F{33}Installing zinit...%f"
  command mkdir -p "$(dirname $ZINIT_HOME)"
  command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# Powerlevel10k - load immediately for instant prompt
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Async plugins with turbo mode
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# OMZ snippets (turbo loaded)
zinit wait lucid for \
  OMZP::sudo \
  OMZP::copypath \
  OMZP::dirhistory \
  OMZP::git

# fzf-tab disabled - using native zsh completion instead (more minimal/inline)
# zinit wait lucid for Aloxaf/fzf-tab
