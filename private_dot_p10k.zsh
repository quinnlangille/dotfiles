# Powerlevel10k - Pure style with Catppuccin Mocha colors
# Minimal prompt inspired by Pure (https://github.com/sindresorhus/pure)

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # =============================================================================
  # Catppuccin Mocha Palette
  # =============================================================================
  local mauve='#cba6f7'
  local teal='#94e2d5'
  local green='#a6e3a1'
  local yellow='#f9e2af'
  local red='#f38ba8'
  local subtext='#a6adc8'
  local overlay='#6c7086'

  # =============================================================================
  # Prompt Layout - Pure style (minimal two-line)
  # =============================================================================
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir                     # current directory
    vcs                     # git status
    newline                 # \n
    prompt_char             # prompt symbol
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    virtualenv              # python venv
    newline
  )

  # Pure style: no background, no separators
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=

  # No icons (pure style is text-only)
  typeset -g POWERLEVEL9K_MODE=
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=

  # =============================================================================
  # Directory
  # =============================================================================
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$mauve
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$overlay
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$mauve
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80

  # =============================================================================
  # Git (VCS) - Pure style: just branch + * when dirty
  # =============================================================================
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  # Clean state - teal
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$teal
  # Modified/dirty - yellow
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$yellow
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$yellow
  # Conflicted - red
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=$red
  # Loading - subtext
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=$subtext

  # Custom format: "branch" or "branch *" when dirty
  # Sum the dirty flags, remove if "0", then output " *" if non-empty
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${VCS_STATUS_LOCAL_BRANCH}${${${:-$((VCS_STATUS_HAS_STAGED+VCS_STATUS_HAS_UNSTAGED+VCS_STATUS_HAS_UNTRACKED+VCS_STATUS_HAS_CONFLICTED))}:#0}:+ *}'

  # Disable all the default icons and formatting
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=0
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

  # =============================================================================
  # Prompt Character (❯ like Pure)
  # =============================================================================
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$mauve
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$red
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true

  # =============================================================================
  # Status (exit code)
  # =============================================================================
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=$green
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$red
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=$red
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=$red
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false

  # =============================================================================
  # Command Execution Time
  # =============================================================================
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$subtext
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  # =============================================================================
  # Virtual Environment
  # =============================================================================
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$teal
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  # =============================================================================
  # Transient Prompt (optional - makes past prompts minimal)
  # =============================================================================
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  # =============================================================================
  # Instant Prompt
  # =============================================================================
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # =============================================================================
  # Hot Reload
  # =============================================================================
  (( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
  'builtin' 'unset' 'p10k_config_opts'
}
