" === VUNDLE ===
set nocompatible
filetype off

" === PLUGIN CONFIG ===

set rtp+=~/.vim/bundle/Vundle.vim " set the runtime path to include Vundle and initialize
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Provides autocomplete
Plugin 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py' " set global clang config-file
let g:ycm_autoclose_preview_window_after_completion = 1
map <C-d> :YcmCompleter GetDoc<CR>

" Elixir/EEx syntax highlighting, filetype detection & indentation
Plugin 'elixir-editors/vim-elixir'
" Provides status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme = 'aurora'
let g:airline#extensions#tabline#enabled = 1 " enables top-bar (buffer-bar)
let g:airline_powerline_fonts = 1 " lets one use the powerline-fonts
" File explorer
Plugin 'scrooloose/nerdtree.git'
map <C-e> :NERDTreeToggle<CR>
" Ctrl+p to search for files
Plugin 'ctrlpvim/ctrlp.vim'
" Shows syntax errors
Plugin 'vim-syntastic/syntastic'
let g:syntastic_enable_elixir_checker = 1 " Will execute the files in order to look for errors...
let g:syntastic_check_on_wq = 0 " disable syntax-check when quitting (and simult. saving) vim!
:command Sc :SyntasticCheck
" Git support (also in airline)
Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" === NORMAL CONFIG ===

" --------------------------------------------------------------------------------
" configure editor with tabs and nice stuff...
" --------------------------------------------------------------------------------
set cursorline          " underlines the current line
set expandtab           " enter spaces when tab is pressed (use softtabs)
"set textwidth=80        " break lines when line length increases
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
set autoindent          " copy indent from current line when starting a new line
set encoding=utf-8

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

" configure expanding of tabs for various file types
au BufRead,BufNewFile *.py set expandtab
au BufRead,BufNewFile *.py set tabstop=4 " set 2 spaces for google-python-styleguide
au BufRead,BufNewFile *.py set softtabstop=4
au BufRead,BufNewFile *.py set shiftwidth=4
autocmd BufWritePre *.py %s/\s\+$//e "automatically remove trailing whitespaces on :w in python-files

au BufRead,BufNewFile *.c set noexpandtab
au BufRead,BufNewFile *.h set noexpandtab
au BufRead,BufNewFile Makefile* set noexpandtab

" set indention-width level to 2 & replace tab with 2 spaces for assembler
au BufRead,BufNewFile *.s set expandtab
au BufRead,BufNewFile *.s set tabstop=2
au BufRead,BufNewFile *.s set softtabstop=2
au BufRead,BufNewFile *.s set shiftwidth=2

