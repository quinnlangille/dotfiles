"PLUGINS
" load plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Start installing plugins
call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'leafgarland/typescript-vim'
Plug 'dracula/vim', { 'as': 'dracula' }

" Initialize plugin system
call plug#end()

" GENERAL WHATEVER
syntax on
color dracula

set number
set linebreak
set showmatch
set visualbell

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4

" ADVANCED
set ruler
set undolevels=1000
set backspace=indent,eol,start

" NERDTree config
map <silent> <C-n> :NERDTreeFocus<CR>

" ligtline config
if !has('gui_running')
  set t_Co=256
endif
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }
