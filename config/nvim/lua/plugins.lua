local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g
local api = vim.api

cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias

paq {'savq/paq-nvim', opt=true}

paq {'RRethy/nvim-base16'}

paq {'hoob3rt/lualine.nvim'}
require('lualine').setup()

paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-telescope/telescope.nvim'}

paq {'nvim-treesitter/nvim-treesitter'}
require('nvim-treesitter.configs').setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  incremental_selection = {
      enable = true
  }
}

paq {'neovim/nvim-lspconfig'}
mappings = require('general/mappings')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local opts = { noremap=true, silent=true }
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  mappings.init_lsp_mappings(buf_set_keymap, opts)
end
nvim_lsp = require('lspconfig')
for _, lsp in ipairs( {"pyright", "bashls", "rust_analyzer", "racket_langserver", "terraformls", "denols", "jsonls", "gopls"} ) do
    nvim_lsp[lsp].setup { on_attach= on_attach}
end
nvim_lsp.elixirls.setup{cmd={ "/home/pkos98/.local/bin/elixir-ls/language_server.sh" }}

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

-- workaround as long as there is no treesitter implementation
paq {'elixir-editors/vim-elixir'}
paq {'hashivim/vim-terraform'}

paq {'hkupty/iron.nvim'}

paq {'norcalli/nvim-colorizer.lua'}
require'colorizer'.setup()
