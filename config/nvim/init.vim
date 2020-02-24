" ===== general settings ====
set incsearch
set mouse=a
set number
set expandtab " use softtabs (replace tab with spaces)
set tabstop=4 " use 4 spaces per default

" ==== plugins with their settings ====
call plug#begin('/home/pkos98/.local/share/nvimplugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'elixir-editors/vim-elixir'

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

" ==== keybindings ====

" switch to right tab using '>' key
nnoremap > gt
nnoremap < gT
