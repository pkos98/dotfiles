"===== general settings ====
set incsearch
set mouse=a
set number
set expandtab " use softtabs (replace tab with spaces)
set tabstop=4 " use 4 spaces per default
set guicursor=
colorscheme gruvbox

" ==== plugins with their settings ====
call plug#begin('/home/pkos98/.local/share/nvimplugged')

Plug 'morhetz/gruvbox/'
let g:gruvbox_contrast_dark='hard'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" navigate through completion suggestions with <Tab>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

Plug 'elixir-editors/vim-elixir'

Plug 'PProvost/vim-ps1'

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

Plug 'ryanoasis/vim-devicons'

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
let g:fern#renderer = "devicons"
Plug 'lambdalisue/fern-renderer-devicons.vim'

" Initialize plugin system
call plug#end() " calls syntax on & filetype autoindent on automatically

" ==== keybindings ====

map <C-e> :Fern . -reveal=% -drawer -toggle<CR>

" switch to right tab using '>' key
nnoremap > gt
nnoremap < gT
" switch tab by pressing <Alt>-<F-<tabnum>>
nnoremap <A-F1> 1gt
nnoremap <A-F2> 2gt
nnoremap <A-F3> 3gt
nnoremap <A-F4> 4gt
nnoremap <A-F5> 5gt

" Use Ctrl+q to show documentation in preview window
nnoremap <C-q> :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType sh setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType vim setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType rust setlocal ts=4 sts=4 sw=4 expandtab
