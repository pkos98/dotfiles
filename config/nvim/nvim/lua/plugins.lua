local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g
local api = vim.api

cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias

paq {'savq/paq-nvim', opt=true}

paq {'RRethy/nvim-base16'}

paq {'kassio/neoterm'}
g.neoterm_default_mod = 'rightbelow' 
g.neoterm_autoscroll = '1'
g['neoterm_autoinsert'] = '1'
g['neoterm_size'] = '10'
api.nvim_set_keymap('n', '<Leader>a', ':%TREPLSendFile<CR>', { noremap = true, silent = false })
api.nvim_set_keymap('n', '<Leader>l', ':%TREPLSendLine<CR>', { noremap = true, silent = false })
api.nvim_set_keymap('v', '<Leader>s', ':%TREPLSendSelection<CR>', { noremap = true, silent = false })
api.nvim_set_keymap('n', '<C-t>', '<C-\\><C-n> :Ttoggle | T ls<CR>', { noremap = true, silent = false })
api.nvim_set_keymap('t', '<C-t>', '<C-\\><C-n> :Ttoggle<CR>', { noremap = true, silent = false })

paq {'hoob3rt/lualine.nvim'}
require('lualine').setup()

paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-telescope/telescope.nvim'}
api.nvim_set_keymap('n', '<C-f>', [[:lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = false })
api.nvim_set_keymap('n', '<C-p>', [[:lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = false })
api.nvim_set_keymap('n', '<C-e>', [[:lua require('telescope.builtin').file_browser()<CR>]], { noremap = true, silent = false })

paq {'nvim-treesitter/nvim-treesitter'}
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

paq {'neovim/nvim-lspconfig'}
nvim_lsp = require('lspconfig')
for _, lsp in ipairs( {"pyright", "bashls", "rust_analyzer", "racket_langserver", "terraformls", "denols", "jsonls", "gopls"} ) do
    nvim_lsp[lsp].setup { on_attach= on_attach}
end
nvim_lsp.elixirls.setup{cmd={ "/home/pkos98/bin/elixir-ls/language_server.sh" }}
-- Support autocompletion navigation using TABs
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

paq {'hrsh7th/nvim-compe'}
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    nvim_treesitter = true;
  };
}

cmd([[inoremap <silent><expr> <C-Space> compe#complete()]])
cmd([[inoremap <silent><expr> <CR>      compe#confirm('<CR>')]])
cmd([[inoremap <silent><expr> <C-e>     compe#close('<C-e>')]])
cmd([[inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })]])
cmd([[inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })]])


-- workaround as long as there is no treesitter implementation
paq {'elixir-editors/vim-elixir'}
paq {'hashivim/vim-terraform'}
