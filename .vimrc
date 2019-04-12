"PLUGINS
" load plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Start installing plugins
call plug#begin('~/.vim/plugged')

" Vue Stuff
Plug 'posva/vim-vue'

" Typescript Stuff
Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'

" Linting / Completion
Plug 'Valloric/YouCompleteMe'
Plug 'w0rp/ale'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'

" Layout / Look
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'dracula/vim', { 'as': 'dracula' }

" Autoreload
Plug 'tmux-plugins/vim-tmux-focus-events'

" Initialize plugin system
call plug#end()

" Configure ctrlp
if executable('ag')
  " Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast, respects .gitignore
  " and .agignore. Ignores hidden files by default.
  let g:ctrlp_user_command = 'ag %s -l --nocolor -f -g ""'
else
  "ctrl+p ignore files in .gitignore
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
endif

" Configure YCM
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
map <C-g> :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Configure Linter
let g:ale_fix_on_save = 1

" Configure Vim-vue
let g:vue_disable_pre_processors=1

" Configure live reload
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" GENERAL WHATEVER
syntax on
color dracula

set autoread
set clipboard=unnamed
set mouse+=a
set number
set linebreak
set showmatch
set visualbell

set hlsearch
set smartcase
set ignorecase
set incsearch
set noswapfile

" Indentation
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" ADVANCED
set ruler
set undolevels=1000
set backspace=indent,eol,start
" highlight the current line number
highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
set cursorline

" NERDTree config
map <silent> <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 &&
	    \exists("b:NERDTree") &&
	    \b:NERDTree.isTabTree()) | q | endif

" ligtline config
if !has('gui_running')
  set t_Co=256
endif
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }
