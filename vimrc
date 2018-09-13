" === VUNDLE ===
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Provides autocomplete
Plugin 'Valloric/YouCompleteMe'
" Elixir/EEx syntax highlighting, filetype detection & indentation
Plugin 'elixir-editors/vim-elixir'
" Integrates elixir support (autocompletion, doc-lookup, jump2def...)
Plugin 'slashmili/alchemist.vim'
" Provides status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme='aurora'
" File explorer
Plugin 'scrooloose/nerdtree.git'
map <C-e> :NERDTreeToggle<CR>

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" === NORMAL CONFIG ===
" configure expanding of tabs for various file types
au BufRead,BufNewFile *.py set expandtab
au BufRead,BufNewFile *.c set noexpandtab
au BufRead,BufNewFile *.h set noexpandtab
au BufRead,BufNewFile Makefile* set noexpandtab

" --------------------------------------------------------------------------------
" configure editor with tabs and nice stuff...
" --------------------------------------------------------------------------------
set expandtab           " enter spaces when tab is pressed
set textwidth=120       " break lines when line length increases
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
set autoindent          " copy indent from current line when starting a new line

" make backspaces more powerfull
set backspace=indent,eol,start

set ruler               " show line and column number
set number              " show line number on the left side
set mouse=a             " enable mouse support (text selection, resizing buffers)
syntax on               " syntax highlighting
set showcmd             " show (partial) command in status line
autocmd FileType python setlocal completeopt-=preview           " Disable auto-popup of the docstring window during completion
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:vim_markdown_folding_disabled = 1 " disable header-folding

" automagically open vim when no file is specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | edit $HOME/.vimrc | set ft=vim | endif

