"===== general settings ====
set incsearch
set mouse=a
set number
set expandtab " use softtabs (replace tab with spaces)
set tabstop=4 " use 4 spaces per default
set guicursor=
set relativenumber
set termguicolors
let mapleader = ","
let maplocalleader = ","


" ==== plugins with their settings ====
call plug#begin('/home/pkos98/.local/share/nvimplugged')

Plug 'kassio/neoterm'
let g:neoterm_default_mod='rightbelow' 
let g:neoterm_autoscroll='1'
let g:neoterm_autoinsert='1'
let g:neoterm_size=10
noremap <Leader>a :%TREPLSendFile<CR>
vnoremap <Leader>s :%TREPLSendSelection<CR>
vnoremap <Leader>l :%TREPLSendLine<CR>


Plug 'itchyny/vim-gitbranch'
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
Plug 'itchyny/lightline.vim'

"Plug 'junegunn/fzf.vim'
"let g:fzf_layout = { 'down': '40%' }
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/completion-nvim'

Plug 'famiu/nvim-reload'

Plug 'RRethy/nvim-base16'

call plug#end() " calls syntax on & filetype autoindent on automatically

lua << EOF
require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.bashls.setup{}
--require'lspconfig'.pyls.setup{on_attach=require'completion'.on_attach}
require('base16-colorscheme').setup('schemer-dark')
EOF

" ==== keybindings ====
map <C-t> :terminal<CR>

" switch to right tab using '>' key
nnoremap > gt
nnoremap < gT

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c


" switch tab by pressing <Alt>-<F-<tabnum>>
map <C-t> :T #Welcome to NeoTerm<CR>
tnoremap <Esc> <C-\><C-n>

nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <C-f> <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <C-b> <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <C-e> <cmd>lua require('telescope.builtin').file_browser()<cr>

"autocmd! FileType fzf tnoremap <buffer> <C-l> :q<CR>
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType sh setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType vim setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType rust setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType ps1 setlocal ts=4 sts=4 sw=4 expandtab

set cmdheight=1
