local g = vim.g
local api = vim.api

g.mapleader = ','
g.localleader = ','
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])
vim.cmd([[nnoremap <C-q> <cmd>lua vim.lsp.buf.declaration()<CR>]])
vim.cmd([[inoremap <C-a> <cmd>lua vim.lsp.buf.declaration()<CR>]])
vim.cmd([[inoremap <C-a> <cmd>lua vim.lsp.buf.hover()<CR>]])

