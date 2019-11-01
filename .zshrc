##########
## VARS ##
##########

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# vim lightline support
export TERM=xterm-256color
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/terraform@0.11/bin:$PATH"

# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
## PLUGINS ##
plugins=(
  zsh-nvm
  history-substring-search
  wd
  git
  syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

###########
## THEME ##
###########

# requires: npm install pureprompt
ZSH_THEME=""
autoload -U promptinit; promptinit
prompt pure

###########
# TOOLING #
###########

# Advanced file listing, to install
# run: brew install lsd
alias ls='lsd'

# Generic ls alias (installing lsd above will override ls)
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# cat upgrade
# brew install bat
alias cat='bat'

# config autosuggest
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd, completion)
bindkey '^ ' autosuggest-accept

###############
## FUNCTIONS ##
###############
# Docker-Trash stops, deletes and removes images of all files matching the pattern     passed in the first argument
docker-trash() {
  container="$1"
  echo $container
  docker stop $(docker ps -a | grep $container | awk '{ print $1 }');
  docker rm $(docker ps -a | grep $container  | awk '{ print $1 }');
  docker rmi $(docker images -a | grep $container | awk '{ print $3 }');
}
