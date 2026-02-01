# History Configuration
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

# Create history directory if it doesn't exist
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

# History options
setopt EXTENDED_HISTORY          # Write timestamp to history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first
setopt HIST_FIND_NO_DUPS         # No duplicates in search
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicates
setopt HIST_IGNORE_DUPS          # Ignore consecutive duplicates
setopt HIST_IGNORE_SPACE         # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
setopt HIST_SAVE_NO_DUPS         # Don't save duplicates
setopt HIST_VERIFY               # Show command before executing from history
setopt INC_APPEND_HISTORY        # Add commands immediately
setopt SHARE_HISTORY             # Share history between sessions
