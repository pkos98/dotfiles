local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'RRethy/nvim-base16'

  use 'nvim-lualine/lualine.nvim'
  require('lualine').setup()

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope-project.nvim'
  use 'lazytanuki/nvim-mapper'
  require('nvim-mapper').setup({
    search_path 	  = os.getenv("HOME") .. "/.config/nvim/lua/general/mappings.lua",
    action_on_enter = "execute"
  })

  use 'nvim-telescope/telescope.nvim'
  local telescope=require('telescope')
  telescope.load_extension('project')
  telescope.load_extension('mapper')

  use 'nvim-treesitter/nvim-treesitter'
  require('nvim-treesitter.configs').setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = true,              -- false will disable the whole extension
    },
    incremental_selection = {
	enable = true
    }
  }

    -- TODO: deprecated, replace with nvim-cmp or coq
  use {'hrsh7th/nvim-compe',
	config=function() require('compe').setup {
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
  end}

  use {'neovim/nvim-lspconfig'}
  require("lspconfig_settings")


  use {'wlangstroth/vim-racket', ft={'racket', 'rkt', 'lisp', 'scm', 'scheme'}}

  -- workaround as long as there is no treesitter implementation
  use {'elixir-editors/vim-elixir', ft={'elixir', 'ex'}}

  use {'hashivim/vim-terraform', ft={'tf', 'terraform'}}

  use 'hkupty/iron.nvim'
  require("iron").core.set_config {
    repl_open_cmd = "rightbelow 15 split",
  }

  use 'norcalli/nvim-colorizer.lua'
  require'colorizer'.setup()

  use 'kyazdani42/nvim-web-devicons'

  use 'mhinz/vim-signify'
  g.signify_sign_add = '+'
  g.signify_sign_delete = '_'
  g.signify_sign_delete_first_line = '‾'
  g.signify_sign_change = '~'
  g.signify_sign_show_count = 0
  g.signify_sign_show_text = 1


  use 'romgrk/barbar.nvim'
  g.bufferline = {
    animation = false
  }

  use "b0o/schemastore.nvim"
  require('lspconfig').jsonls.setup {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
}



  use 'kyazdani42/nvim-tree.lua'
  require'nvim-tree'.setup {
  nvim_tree_side = "left",
  nvim_tree_width = 25,
  nvim_tree_ignore = { ".git", "node_modules", ".cache" },
  nvim_tree_gitignore = 1,
  nvim_tree_auto_ignore_ft = { "dashboard" }, -- don't open tree on specific fiypes.
  nvim_tree_auto_open = 0,
  nvim_tree_auto_close = 0, -- closes tree when it's the last window,
  nvim_tree_quit_on_open = 0, -- closes tree when file's opened,
  nvim_tree_follow = 1,
  nvim_tree_indent_markers = 1,
  nvim_tree_hide_dotfiles = 1,
  nvim_tree_git_hl = 1,
  nvim_tree_highlight_opened_files = 0,
  nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" },
  nvim_tree_tab_open = 0,
  nvim_tree_allow_resize = 1,
  nvim_tree_add_trailing = 0, -- append a trailing slash to folder names,
  nvim_tree_disable_netrw = 1,
  nvim_tree_hijack_netrw = 0,
  nvim_tree_update_cwd = 1,

  nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    -- folder_arrows= 1
  },
  nvim_tree_icons = {
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
}
  end)
