-- vi: ft=lua

-- ########################
-- #			VIM SETTINGS 		#
-- ########################
vim.g.laststatus = 3
vim.o.mouse = 'a'
vim.o.number = true
vim.o.termguicolors = true
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.relativenumber = true
vim.o.guicursor='a:blinkon100'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.autochdir = true
vim.o.completeopt='menuone,noselect'

-- ######################
-- #			PLUGINS 			#
-- ######################
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'navarasu/onedark.nvim'

  use 'neovim/nvim-lspconfig'

  use 'nvim-treesitter/nvim-treesitter'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  --[[use {
  "someone-stole-my-name/yaml-companion.nvim",
  requires = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    require("telescope").load_extension("yaml_schema")
  end,
}--]]

  use "b0o/schemastore.nvim"

  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
  }

  use 'folke/which-key.nvim'

  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

end)

local onedark = require('onedark')
onedark.setup {
  style = 'darker'
}
onedark.load()
onedark.load()
require('telescope').setup()
require("nvim-tree").setup()

  -- Set up nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
     -- completion = cmp.config.window.bordered(),
     documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
     { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()


-- ############################
-- #			GLOBAL KEYMAPS			#
-- ############################
vim.api.nvim_set_keymap('n', '<C-n>', '', {
    noremap = true,
    callback = function()
        require('telescope.builtin').find_files()
    end,
})
vim.api.nvim_set_keymap('n', '<C-S-f>', '', {
    noremap = true,
    callback = function()
        require('telescope.builtin').live_grep()
    end,
})
vim.api.nvim_set_keymap('n', '<C-f>', '', {
    noremap = true,
    callback = function()
        require('telescope.builtin').live_grep()
    end,
})
vim.api.nvim_set_keymap('n', '<C-e>', '', {
    noremap = true,
    callback = function()
        require('telescope.builtin').buffers()
    end,
})
--1b310a
--vim.api.nvim_set_keymap('n', '¡', '', { -- Alt+1
vim.api.nvim_set_keymap('n', '<A-1>', '', { -- Alt+1
    noremap = true,
    callback = function()
        require('nvim-tree.api').tree.toggle(true)
    end,
})
vim.cmd([[imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' ]])
vim.cmd([[inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>]])
vim.cmd([[snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>]])
vim.cmd([[snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>]])


-- `on_attach` callback will be called after a language server
-- instance has been attached to an open buffer with matching filetype
-- here we're setting key mappings for hover documentation, goto definitions, goto references, etc
-- you may set those key mappings based on your own preference
local on_attach = function(_, bufnr)
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-b>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-q>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<A-Left>', '<C-O>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<A-Right>', '<C-I>', opts)
end
local lspconfig = require('lspconfig')
for _, lsp in pairs({ 'terraformls', 'jedi_language_server', 'clangd', 'gopls', 'bashls', 'rust_analyzer'}) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end
lspconfig.elixirls.setup{
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { "/usr/bin/elixir-ls" };
}
lspconfig['lua_ls'].setup {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
      },
    },
  },
}
lspconfig.yamlls.setup {
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = true,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      --schemas = require('schemastore').yaml.schemas(),
        schemas = {
    kubernetes = "*.yaml",
    ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
    ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
    ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
    ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
    ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
    ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
    ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
    ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
    ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
    ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
    ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
  },
    },
  },
}
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  }
})
