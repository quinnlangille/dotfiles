# Shell Options
# Navigation
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push directories onto stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt PUSHD_SILENT         # Don't print directory stack

# Globbing
setopt EXTENDED_GLOB        # Extended globbing
setopt GLOB_DOTS            # Include dotfiles in globbing
setopt NO_CASE_GLOB         # Case insensitive globbing

# Correction
setopt CORRECT              # Command correction
setopt CORRECT_ALL          # Argument correction

# Job Control
setopt NO_BG_NICE           # Don't nice background jobs
setopt NO_HUP               # Don't kill jobs on exit
setopt LONG_LIST_JOBS       # Long format job listings

# Misc
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt NO_BEEP              # No beeping
setopt PROMPT_SUBST         # Enable prompt substitution
