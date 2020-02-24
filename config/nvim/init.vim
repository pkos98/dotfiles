set incsearch
set mouse=a
set number
set expandtab " use softtabs (replace tab with spaces)
set tabstop=4 " use 4 spaces per default
nnoremap > gt
nnoremap < gT

" Specify a directory for plugins
call plug#begin(stdpath('data') . 'plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'elixir-editors/vim-elixir'

"Plug 'dense-analysis/ale'
"let g:ale_sign_error = '>>'
"let g:ale_sign_warning = '--'
" let g:ale_set_highlights = 0

Plug 'itchyny/vim-gitbranch'

Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

" Initialize plugin system
call plug#end() " calls syntax on & filetype autoindent on automatically
