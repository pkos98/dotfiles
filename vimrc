" === PLUGIN CONFIG ===
" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Provides autocomplete
Plug 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py' " set global clang config-file
let g:ycm_autoclose_preview_window_after_completion = 1
map <C-d> :YcmCompleter GetDoc<CR>

" Shows syntax errors
Plug 'vim-syntastic/syntastic'
let g:syntastic_check_on_wq = 0 " disable syntax-check when quitting (and simult. saving) vim!
let g:syntastic_java_checkers = [] " disable java checker - needed for youcompleteme java

" Git support (also in airline)
Plug 'tpope/vim-fugitive'
Plug 'liuchengxu/space-vim-dark'

Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" ElixirSense Language-Server for Auto-Completion
Plug 'slashmili/alchemist.vim', { 'for': 'elixir' }
" Syntax highlighting
Plug 'huffman/vim-elixir', { 'for': 'elixir' }

Plug 'ap/vim-readdir'
" Disable netrw loading
let g:loaded_netrwPlugin = 1

Plug 'tweekmonster/startuptime.vim'

" All of your Plugins must be added before the following line
call plug#end()            " required
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

" ==== LANG SPECIFIC ====

" --------------------------------------------------------------------------------
"  Configure tabwidth, replace tabs with spaces, etc...
" --------------------------------------------------------------------------------
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

set background=light
colorscheme space-vim-dark
" Always show the statusline
set laststatus=2
