-- ########################
-- #    VIM SETTINGS      #
-- ########################
vim.g.mapleader = ","
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.o.number = true
vim.o.mouse = "a"
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.g.loaded_netrw = false
vim.g.loaded_netrwPlugin = false
vim.g.laststatus = 3
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.cmdheight = 0
vim.g.updatetime = 500 -- recommended https://github.com/airblade/vim-gitgutter#when-are-the-signs-updated
vim.g.python3_host_prog = "python" -- improve startuptime in presence of venv (avoids lookup)
vim.opt.exrc = true
vim.loader.enable()

-- ########################
-- #    PLUGIN SETTINGS   #
-- ########################
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=main",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  -- Base plugins
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    lazy = false,
    pin = true,
    config = function()
      require("onedarkpro").setup({
        options = {
          highlight_inactive_windows = true,
        },
        colors = {
          bg = "#1f2329",
          color_column = "red",
        },
        highlights = {
          MatchParen = {
            bg = "grey",
          },
        },
      })
      vim.cmd.colorscheme("onedark")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      enabled = true,
    },
  },
  "neovim/nvim-lspconfig",
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    "b0o/schemastore.nvim",
    ft = { "json", "yaml" },
    config = function()
      local lspconfig = require("lspconfig")
      local schemastore = require("schemastore")
      lspconfig.jsonls.setup({
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      })
      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = schemastore.yaml.schemas(),
          },
        },
      })
    end,
  },

  -- UI plugins
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
      { "<leader>qq", function() require("trouble").toggle("quickfix") end },
      { "<leader>xq", function() require("trouble").toggle("quickfix") end },
      { "<leader>xx", function() require("trouble").toggle("diagnostics") end },
      { "<leader>xt", function() require("trouble").toggle("diagnostics") end },
      { "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end },
      { "<leader>xd", function() require("trouble").toggle("document_diagnostics") end },
      { "<leader>xl", function() require("trouble").toggle("loclist") end },
      { "<leader>lr", function() require("trouble").toggle("lsp_references") end },
      {
        "<C-j>",
        ---@diagnostic disable-next-line: missing-parameter, missing-fields
        function() require("trouble").next({ skip_groups = true, jump = true }) end,
        mode = { "i", "n" },
      },
      {
        "<C-k>",
        ---@diagnostic disable-next-line: missing-parameter, missing-fields
        function() require("trouble").prev({ skip_groups = true, jump = true }) end,
        mode = { "i", "n" },
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.4",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim", -- supports grep args in search
      "nvim-telescope/telescope-file-browser.nvim", -- for selecting files outside of cwd
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- recommended for better performance
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },
    keys = {
      {
        "<C-n>",
        function() require("telescope.builtin").find_files() end,
      },
      {
        "<C-S-n>",
        function() require("telescope").extensions.file_browser.file_browser({ path = "~" }) end,
      },
      { "<C-e>", function() require("telescope.builtin").buffers() end },
      {
        "<C-f>",
        function()
          vim.cmd('noau normal! "vy"')
          local search_text = vim.fn.getreg("v")
          vim.fn.setreg("v", {})
          search_text = string.gsub(search_text, "\n", "")
          require("telescope").extensions.live_grep_args.live_grep_args({ default_text = search_text })
        end,
        mode = { "n", "x", "i" },
      },
      { "<C-S-F>", function() vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-f>", false, false, true)) end },
      { "<C-Space>", function() require("telescope.builtin").builtin() end },
      { "<leader>lrr", function() require("telescope.builtin").lsp_references() end },
      {
        "<leader>lsd",
        function() require("telescope.builtin").lsp_document_symbols() end,
      },
      {
        "<leader>lsw",
        function() require("telescope.builtin").lsp_workspace_symbols() end,
      },
      {
        "<leader>lsf",
        function() require("telescope.builtin").lsp_document_symbols({ symbols = "function" }) end,
      },
      { "<C-b>", function() require("telescope.builtin").git_branches() end },
      {
        "<C-c>", -- file history
        function()
          require("telescope.builtin").git_commits({
            git_command = {
              "git",
              "log",
              "--pretty=oneline",
              "--abbrev-commit",
              "--",
              vim.fn.expand("%"),
            },
          })
        end,
      },
      { "<M-C-C>", function() require("telescope.builtin").git_commits() end },
    },
    config = function()
      local actions = require("telescope.actions")
      local telescope = require("telescope")
      local function send(prompt_bufnr)
        actions.smart_send_to_qflist(prompt_bufnr)
        require("trouble").open("qflist")
      end
      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- default or "ignore_case" or "respect_case"
          },
          live_grep_args = {
            theme = "ivy",
          },
          file_browser = {
            theme = "ivy",
            hijack_netrw = true, -- disables netrw and use telescope-file-browser in its place
            display_stat = false,
            -- previewer = false, TODO: customize to replace nvim-tree
            -- layout_config = {
            --   anchor = "NW",
            --   height = 100,
            --   width = 0.25,
            -- },
          },
        },
        defaults = {
          mappings = {
            n = {
              ["<Esc>"] = actions.close,
              ["q"] = actions.close,
              ["<C-q>"] = send,
              ["<S-j>"] = function(bufnr)
                require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = 1
                return require("telescope.actions").preview_scrolling_down(bufnr)
              end,
              ["<S-k>"] = function(bufnr)
                require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = 1
                return require("telescope.actions").preview_scrolling_up(bufnr)
              end,
            },
            i = {
              ["<C-q>"] = send,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "ivy",
          },
          buffers = {
            theme = "ivy",
          },
          builtin = {
            theme = "ivy",
          },
          lsp_document_symbols = {
            theme = "ivy",
          },
          lsp_workspace_symbols = {
            theme = "ivy",
          },
          git_branches = {
            theme = "ivy",
          },
          git_commits = {
            theme = "ivy",
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("file_browser")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua", -- TODO: Replace with telescope file_browser with side layout
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<A-1>", function() require("nvim-tree.api").tree.toggle() end },
      { "<A-S-1>", function() require("nvim-tree.api").open() end },
      { "<M-S-!>", function() require("nvim-tree.api").tree.focus() end },
    },
    opts = {
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set("n", "n", api.fs.create, opts("n"))
      end,
    },
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>dt", function() require("dapui").toggle() end },
      { "<leader>dr", function() require("dapui").open({ reset = true }) end },
    },
    config = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "eol" } },
      {
        "mfussenegger/nvim-dap",
        keys = {
          { "<leader>db", function() require("dap").toggle_breakpoint() end },
          { "<leader>di", function() require("dap").step_into() end },
          { "<leader>dd", function() require("dap").step_into() end },
          { "<leader>do", function() require("dap").step_over() end },
          { "<leader>du", function() require("dap").step_out() end },
          { "<leader>dc", function() require("dap").continue() end },
        },
      },
      {
        "mfussenegger/nvim-dap-python",
        config = function() require("dap-python").setup("python") end,
        dependencies = "microsoft/debugpy",
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        config = true,
        dependencies = {
          "microsoft/vscode-js-debug",
          commit = "7349abcd0aaf72375645a4a876afab6479e0ed7e",
          config = false,
          build = "pnpm i && pnpm run compile vsDebugServerBundle && rm -rf out && mv -f dist out",
        },
      },
    },
  },
  {
    "stevearc/dressing.nvim", -- enhanced UI for e.g. refactoring
    event = "VeryLazy",
    opts = {
      input = {
        enabled = false,
      },
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = true,
    ft = { "html", "css", "typescript", "javascript", "typescriptreact", "javascriptreact", "lua" },
  },
  {
    "MagicDuck/grug-far.nvim",
    config = true,
    cmd = "GrugFar",
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local theme = require("lualine.themes.onedark")
      theme.normal.a.bg = "#645394"
      theme.normal.b.fg = theme.normal.c.fg
      theme.inactive.c.fg = "grey"
      theme.inactive.c.gui = "underline"
      require("lualine").setup({
        options = {
          theme = theme,
        },
        sections = {
          lualine_b = {
            {
              "macro-recording",
              fmt = function()
                local recording_register = vim.fn.reg_recording()
                if recording_register == "" then
                  return ""
                else
                  return "Recording @" .. recording_register
                end
              end,
            },
          },
        },
      })
    end,
  },

  -- Git plugins
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>gp", function() require("gitsigns").preview_hunk() end },
      { "<leader>gs", function() require("gitsigns").stage_hunk() end },
      {
        "<leader>gs",
        function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        mode = "x",
      },
      {
        "<leader>ga",
        function()
          local actions = require("gitsigns").get_actions()
          actions["repo_logs"] = function() vim.cmd("DiffviewFileHistory") end
          actions["file_logs"] = function() vim.cmd("DiffviewFileHistory %") end
          vim.ui.select(vim.tbl_keys(actions), {
            prompt = "Git actions",
          }, function(selected)
            if selected ~= nil then actions[selected]() end
          end)
        end,
      },
    },
    opts = {
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 0,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    dev = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gg", function() require("lazygit").lazygit() end },
    },
  },
  {
    "FabijanZulj/blame.nvim",
    keys = {
      { "<leader>gb", "<CMD>BlameToggle<CR>", silent = true },
    },
    opts = { commit_detail_view = "split" },
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<A-0>", "<CMD>DiffviewOpen<CR>", silent = true },
      { "<leader>gh", "<CMD>DiffviewFileHistory<CR>", silent = true },
      { "<leader>ghh", "<CMD>DiffviewFileHistory %<CR>", silent = true },
    },
    cmd = {
      "DiffviewFileHistory",
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    config = true,
  },

  -- Other plugins
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost", -- needed
    -- won't be loaded on shortcut, but on event
    keys = { -- TODO: fix error on first lazy invocation
      { "<C-+>", "<CMD>silent! foldopen<CR>", silent = true },
      { "<C-*>", "<CMD>silent! foldopen<CR>", silent = true },
      { "<C-=>", "<CMD>silent! foldopen<CR>", silent = true },
      { "<C-_>", "<CMD>silent! foldclose<CR>", silent = true },
      { "<C-->", "<CMD>silent! foldclose<CR>", silent = true },
      { "<leader>up", function() require("ufo.preview"):peekFoldedLinesUnderCursor() end },
    },
    init = function()
      vim.o.foldcolumn = "0" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("ufo").setup({
        provider_selector = function(_, _, _) return { "treesitter", "indent" } end,
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = (" 󰁂 %d "):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "MoreMsg" })
          return newVirtText
        end,
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = true,
    keys = {
      { "<C-/>", "<Plug>(comment_toggle_linewise_current)", mode = "n" },
      { "<C-7>", "<Plug>(comment_toggle_linewise_current)", mode = "n" },
      { "<C-S-/>", "<Plug>(comment_toggle_linewise_current)", mode = "n" },
      { "<C-\\>", "<Plug>(comment_toggle_blockwise_current)", mode = "n" },
      { "<C-S-?>", "<Plug>(comment_toggle_blockwise_current", mode = "n" },
      { "<C-/>", "<Plug>(comment_toggle_linewise_visual)", mode = "x" },
      { "<C-7>", "<Plug>(comment_toggle_linewise_visual)", mode = "x" },
      { "<C-S-/>", "<Plug>(comment_toggle_linewise_visual)", mode = "x" },
      { "<C-\\>", "<Plug>(comment_toggle_blockwise_visual)", mode = "x" },
      { "<C-S-?>", "<Plug>(comment_toggle_blockwise_visual)", mode = "x" },
    },
  },
  {
    "stevearc/conform.nvim",
    keys = { { "<leader>lf", function() require("conform").format() end, mode = { "n", "x" } } },
    opts = {
      timemout_ms = 500,
      lsp_fallback = false,
      formatters = {
        stylua = {
          prepend_args = { "--collapse-simple-statement", "Always", "--indent-type", "Spaces", "--indent-width", 2 },
        },
      },
      formatters_by_ft = {
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        javascript = { "prettier" },
        awk = { "awk" },
        lua = { "stylua" },
        python = { "isort", "black" },
        go = { "goimports-reviser", "gofmt" },
        terraform = { "terraform_fmt" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        swift = { "swiftformat" },
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascriptreact", "javascript" },
    config = true,
    enabled = false,
  },
  {
    "LintaoAmons/bookmarks.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
    enabled = true,
    keys = {
      { "<leader>m", function() require("bookmarks.api").mark({ name = "" }) end },
      {
        "<leader>M",
        function()
          local name = vim.fn.input("Bookmark name: ")
          require("bookmarks.api").mark({ name = name })
        end,
      },
      {
        "<S-CR>",
        function()
          local api, picker = require("bookmarks.api"), require("bookmarks.adapter.picker")
          picker.pick_bookmark(
            function(bookmark) api.goto_bookmark(bookmark, { open_method = "vsplit" }) end,
            { all = false }
          )
        end,
      },
    },
    config = function()
      require("bookmarks").setup({})
      local api, cwd = require("bookmarks.api"), vim.fn.getcwd()
      -- set active list to cwd and create if not existing
      local exists = vim
        .iter(require("bookmarks.repo").bookmark_list.read.find_all())
        :any(function(list) return list.name == cwd end)
      api.set_active_list(cwd)
      if not exists then api.add_list({ name = cwd }) end
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "onsails/lspkind.nvim", -- fancy icons
      "hrsh7th/cmp-nvim-lsp",
      -- "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")
      local types = require("cmp.types")
      cmp.setup({
        experimental = {
          ghost_text = true,
        },
        snippet = {
          expand = function(args) vim.snippet.expand(args.body) end,
        },
        window = {
          documentation = cmp.config.window.bordered(),
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = { "" },
            menu = {
              nvim_lsp = "LSP",
              buffer = "buf",
              path = "path",
              treesitter = "TS",
              calc = "calc",
            },
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<S-k>"] = cmp.mapping.scroll_docs(-4),
          ["<S-j>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-c>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "path" },
          { name = "nvim_lsp_signature_help" },
          { name = "calc" },
        }, {
          { name = "buffer" },
        }),
      })
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" },
        }, {
          { name = "buffer" },
        }),
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
        ---@diagnostic disable-next-line: missing-fields
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
}, { dev = { path = "~/src" } })

-- ############################
-- #      GLOBAL KEYMAPS      #
-- ############################
local opts_silent = { noremap = true, silent = true }
vim.keymap.set("n", "<C-l>", "<CMD>Lazy<CR>", opts_silent)
vim.keymap.set("n", "<leader>q", "<CMD>q<CR>", opts_silent)
vim.keymap.set("n", "<leader>ec", "<CMD>vsplit ~/.config/nvim/init.lua<CR>", opts_silent)
vim.keymap.set("n", "<leader>,", "<CMD>write<CR>", opts_silent)
vim.keymap.set("n", "<leader>.", "<CMD>q<CR>", opts_silent)
vim.keymap.set("n", "YY", '"+yy') -- yank to clipboard
vim.keymap.set({ "n", "x" }, "Y", '"+y') -- yank to clipboard

-- LSP keymaps
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation)
vim.keymap.set("n", "<leader>ll", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action)
vim.keymap.set("n", "<C-h>", vim.lsp.buf.hover)
vim.keymap.set("n", "<C-h-h>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<A-Left>", "<C-O>", opts_silent)
vim.keymap.set("n", "<A-Right>", "<C-I>", opts_silent)

-- ############################
-- #            LSP           #
-- ############################
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, lsp in pairs({
  "terraformls",
  "clangd",
  "gopls",
  "rust_analyzer",
  "awk_ls",
  "dockerls",
  "bashls",
  "perlpls",
  "dartls",
  "sourcekit",
  "lua_ls",
}) do
  lspconfig[lsp].setup({ capabilities = capabilities })
end
lspconfig["pylsp"].setup({
  settings = {
    pylsp = {
      plugins = {
        ruff = { enabled = true }, -- disables pycodestyle, pyflakes, mccabe, autopep8 and yapf
      },
    },
  },
})
lspconfig.elixirls.setup({ capabilities = capabilities, cmd = { "/usr/bin/elixir-ls" } })
vim.capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig["html"].setup({
  capabilities = capabilities,
})
lspconfig["cssls"].setup({
  capabilities = capabilities,
})

-- ############################
-- #         AUTOCMD          #
-- ############################
vim.api.nvim_create_user_command("LuaLsLoadPlugins", function(_)
  require("lspconfig").lua_ls.manager.config.settings.Lua.workspace.library = vim.api.nvim_get_runtime_file("", true)
  vim.cmd("LspRestart lua_ls")
end, {})

-- create statusline indicator when recording a macro
local lualine = require("lualine")
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    lualine.refresh({
      place = { "statusline" },
    })
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    local timer = vim.loop.new_timer()
    timer:start(
      50,
      0,
      vim.schedule_wrap(function()
        lualine.refresh({
          place = { "statusline" },
        })
      end)
    )
  end,
})
-- local gid = vim.api.nvim_create_augroup("remember_folds", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
--   pattern = "?*",
--   group = gid,
--   callback = function() vim.cmd("silent! mkview 1") end,
-- })
-- vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
--   pattern = "?*",
--   group = gid,
--   callback = function() vim.cmd("silent! loadview 1") end,
-- })
