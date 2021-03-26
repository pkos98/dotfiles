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
colorscheme jellybeans


" ==== plugins with their settings ====
call plug#begin('/home/pkos98/.local/share/nvimplugged')

Plug 'tomasr/molokai'

Plug 'kassio/neoterm'
let g:neoterm_default_mod='rightbelow' 
let g:neoterm_autoscroll='1'
let g:neoterm_autoinsert='1'
let g:neoterm_size=10
noremap <Leader>a :%TREPLSendFile<CR>
vnoremap <Leader>s :%TREPLSendSelection<CR>
vnoremap <Leader>l :%TREPLSendLine<CR>


Plug 'neoclide/coc.nvim', {'branch': 'release'}
" navigate through completion suggestions with <Tab>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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

"Plug 'ryanoasis/vim-devicons' DEPRECATED
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern.vim'
function! s:init_fern() abort
    nmap <buffer><expr>
      \ <Plug>(fern-my-expand-or-collapse)
      \ fern#smart#leaf(
      \   "\<Plug>(fern-action-collapse)",
      \   "\<Plug>(fern-action-expand)",
      \   "\<Plug>(fern-action-collapse)",
      \ )
nmap <buffer><nowait> l <Plug>(fern-my-expand-or-collapse)
endfunction
augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
let g:fern#renderer = "nerdfont"
"let g:fern#renderer = "devicons" DEPRECATED
"Plug 'lambdalisue/fern-renderer-devicons.vim' DEPRECATED

"Plug 'jpalardy/vim-slime', {'branch': 'main'}
"let g:slime_target = "neovim"
"nmap <c-c><c-x> :%SlimeSend<cr>

Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'down': '40%' }

Plug 'wlangstroth/vim-racket'
Plug 'elixir-editors/vim-elixir'
Plug 'hashivim/vim-terraform'

" Initialize plugin system
call plug#end() " calls syntax on & filetype autoindent on automatically

" ==== keybindings ====

map <C-e> :Fern . -reveal=% -drawer -toggle<CR>
map <C-t> :terminal<CR>

" switch to right tab using '>' key
nnoremap > gt
nnoremap < gT
" switch tab by pressing <Alt>-<F-<tabnum>>
nnoremap <A-F1> 1gt
nnoremap <A-F2> 2gt
nnoremap <A-F3> 3gt
nnoremap <A-F4> 4gt
nnoremap <A-F5> 5gt

map <C-t> :T #Welcome to NeoTerm<CR>

tnoremap <Esc> <C-\><C-n>

" Use Ctrl+q to show documentation in preview window
nnoremap <C-q> :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nnoremap <C-p> :FZF<CR>
nnoremap <C-f> :Rg<CR>
autocmd! FileType fzf tnoremap <buffer> <C-l> :q<CR>

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType sh setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType vim setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType rust setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType ps1 setlocal ts=4 sts=4 sw=4 expandtab

set cmdheight=1
