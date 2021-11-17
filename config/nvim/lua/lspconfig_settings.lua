local mappings = require('general/mappings')
local mapper = require('nvim-mapper')

local on_attach = function(_, bufnr)
  local function buf_set_keymap(...) mapper.map_buf(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local opts = { noremap=true, silent=true }
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  mappings.init_lsp_mappings(buf_set_keymap, opts)
end
local nvim_lsp = require('lspconfig')
for _, lsp in ipairs( {"pyright", "bashls", "rust_analyzer", "racket_langserver", "terraformls", "denols", "jsonls", "gopls"} ) do
    nvim_lsp[lsp].setup { on_attach= on_attach}
end
nvim_lsp.diagnosticls.setup{
  on_attach=on_attach,
  filetypes= {"sh", "bash", "zsh"},
   init_options = {
    linters = {
      shellcheck = {
	   command = 'shellcheck',
            debounce = 100,
            args = { '--format=gcc', '-'},
            offsetLine = 0,
            offsetColumn = 0,
            sourceName = 'shellcheck',
            formatLines = 1,
            formatPattern = {
              '^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$',
              {
                line = 1,
                column = 2,
                message = 4,
                security = 3
              }
	    },
            securities = {
              error = 'error',
              warning = 'warning',
              note = 'info'
            }
          },
	filetypes = {
	  bash = 'shellcheck',
	  sh = 'shellcheck',
	  zsh = 'shellcheck'
	}
      }
  }
}
nvim_lsp.elixirls.setup { on_attach=on_attach; cmd={ "/opt/elixir-ls/language_server.sh" }}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach;
  cmd = {"/usr/bin/lua-language-server", "-E", "/home/pkos98/src/language-server-lua/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}


