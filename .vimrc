" GENERAL WHATEVER
syntax on

" NERDTree config
map <silent> <C-n> :NERDTreeFocus<CR>

" ligtline config
if !has('gui_running')
  set t_Co=256
endif
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ }

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

" Initialize plugin system
call plug#end()
