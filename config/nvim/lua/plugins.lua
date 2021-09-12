local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g

cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias

paq {'savq/paq-nvim', opt=true}

paq {'RRethy/nvim-base16'}

paq {'hoob3rt/lualine.nvim'}
require('lualine').setup()

paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-telescope/telescope-project.nvim'}
paq {'lazytanuki/nvim-mapper'}
require('nvim-mapper').setup({
  search_path 	  = os.getenv("HOME") .. "/.config/nvim/lua/general/mappings.lua",
  action_on_enter = "execute"
})
paq {'nvim-telescope/telescope.nvim'}
local telescope=require('telescope')
telescope.load_extension('project')
telescope.load_extension('mapper')

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
require("lspconfig_settings")


-- TODO: deprecated, replace with nvim-cmp or coq
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


paq {'wlangstroth/vim-racket'}

-- workaround as long as there is no treesitter implementation
paq {'elixir-editors/vim-elixir'}

paq {'hashivim/vim-terraform'}

paq {'hkupty/iron.nvim'}
require("iron").core.set_config {
  repl_open_cmd = "rightbelow 15 split",
}

paq {'norcalli/nvim-colorizer.lua'}
require'colorizer'.setup()

paq {'kyazdani42/nvim-web-devicons'}

paq {'mhinz/vim-signify'}
g.signify_sign_add = '+'
g.signify_sign_delete = '_'
g.signify_sign_delete_first_line = '‾'
g.signify_sign_change = '~'
g.signify_sign_show_count = 0
g.signify_sign_show_text = 1

paq {'kyazdani42/nvim-tree.lua'}
g.nvim_tree_side = "left"
g.nvim_tree_width = 25
g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
g.nvim_tree_gitignore = 1
g.nvim_tree_auto_ignore_ft = { "dashboard" } -- don't open tree on specific fiypes.
g.nvim_tree_auto_open = 0
g.nvim_tree_auto_close = 0 -- closes tree when it's the last window
g.nvim_tree_quit_on_open = 0 -- closes tree when file's opened
g.nvim_tree_follow = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_hide_dotfiles = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" }
g.nvim_tree_tab_open = 0
g.nvim_tree_allow_resize = 1
g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
g.nvim_tree_disable_netrw = 1
g.nvim_tree_hijack_netrw = 0
g.nvim_tree_update_cwd = 1

g.nvim_tree_show_icons = {
   git = 1,
   folders = 1,
   files = 1,
   -- folder_arrows= 1
}
g.nvim_tree_icons = {
   default = "",
   symlink = "",
   git = {
      unstaged = "✗",
      staged = "✓",
      unmerged = "",
      renamed = "➜",
      untracked = "★",
      deleted = "",
      ignored = "◌",
   },
   folder = {
      -- disable indent_markers option to get arrows working or if you want both arrows and indent then just add the arrow icons in front            ofthe default and opened folders below!
      -- arrow_open = "",
      -- arrow_closed = "",
      default = "",
      open = "",
      empty = "", -- 
      empty_open = "",
      symlink = "",
      symlink_open = "",
   },
}
