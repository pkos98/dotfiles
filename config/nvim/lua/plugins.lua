return {
  -- Base plugins
  {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        identifiers = { italic = false },
        functions = {},
        variables = {},
      },
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)
      vim.cmd("colorscheme ex-tokyodark")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- c, lua, vim, vimdoc, query, markdown are bundled with nvim 0.12
      require("nvim-treesitter").install({
        "bash",
        "cmake",
        "cpp",
        "elixir",
        "gleam",
        "go",
        "hcl",
        "heex",
        "json",
        "make",
        "yaml",
        "helm",
        "perl",
        "python",
        "regex",
        "swift",
        "pkl",
      })
    end,
  },
  {
    "b0o/schemastore.nvim",
    ft = { "json", "yaml" },
    config = function()
      local schemastore = require("schemastore")
      local opd = vim.lsp.diagnostic.on_publish_diagnostics

      -- 1. Setup JSON Language Server Configuration
      vim.lsp.config.jsonls = {
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
        handlers = {
          ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            if (vim.bo.ft == "jsonc" or vim.bo.ft == "json5") and result.diagnostics ~= nil then
              local idx = 1
              while idx <= #result.diagnostics do
                if result.diagnostics[idx].code == 521 then
                  table.remove(result.diagnostics, idx)
                else
                  idx = idx + 1
                end
              end
            end
            opd(err, result, ctx, config)
          end,
        },
      }

      -- 2. Setup YAML Language Server Configuration with Kubernetes schema mapping
      vim.lsp.config.yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            -- Merge SchemaStore configurations with custom Kubernetes pattern matching
            schemas = vim.tbl_deep_extend("force", schemastore.yaml.schemas(), {
              kubernetes = {
                "k8s/*.yaml",
                "k8s/**/*.yaml",
                "kubernetes/*.yaml",
                "kubernetes/**/*.yaml",
                "deployment.yaml",
                "service.yaml",
                "ingress.yaml",
                "pod.yaml",
                -- Add other common Kubernetes manifest filenames/patterns here
              },
            }),
          },
        },
      }

      -- 3. Explicitly enable both language servers so they autostart on matching filetypes
      vim.lsp.enable({ "jsonls", "yamlls" })
    end,
  },
  -- UI plugins
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
      { "<leader>xq", function() require("trouble").toggle("quickfix") end },
      { "<leader>xx", function() require("trouble").toggle("diagnostics") end },
      { "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end },
      { "<leader>xd", function() require("trouble").toggle("document_diagnostics") end },
      { "<leader>xl", function() require("trouble").toggle("loclist") end },
      { "<leader>lr", function() require("trouble").toggle("lsp_references") end },
      {
        "<C-j>",
        function()
          local trouble = require("trouble")
          if trouble.is_open() then
            ---@diagnostic disable-next-line: missing-parameter, missing-fields
            trouble.next({ skip_groups = true, jump = true })
          end
        end,
        mode = { "i", "n" },
      },
      {
        "<C-k>",
        function()
          local trouble = require("trouble")
          if trouble.is_open() then
            ---@diagnostic disable-next-line: missing-parameter, missing-fields
            trouble.prev({ skip_groups = true, jump = true })
          end
        end,
        mode = { "i", "n" },
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      follow = false,
    },
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = true,
    ft = { "html", "css", "typescript", "javascript", "typescriptreact", "javascriptreact", "lua" },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "tiagovla/tokyodark.nvim" },
    config = function(_, _)
      local theme = require("lualine.themes.tokyodark")
      -- local theme = require("lualine.themes.onedark")
      -- theme.normal.a.bg = "#645394"
      -- theme.normal.b.fg = theme.normal.c.fg
      -- theme.inactive.c.fg = "grey"
      -- theme.inactive.c.gui = "underline"
      require("lualine").setup({
        options = {
          theme = theme,
        },
        sections = {
          lualine_x = { "filetype" },
          lualine_b = {
            "branch",
            "diagnostics",
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
      { "<leader>gb", function() require("gitsigns").blame() end },
      { "<leader>gp", function() require("gitsigns").preview_hunk() end },
      { "<leader>gs", function() require("gitsigns").stage_hunk() end },
      {
        "<leader>gs",
        function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        mode = "x",
      },
      { "<leader>gr", function() require("gitsigns").reset_hunk() end },
      { "<leader>gu", function() require("gitsigns").reset_hunk() end },
      {
        "<leader>ga",
        function()
          local actions = require("gitsigns").get_actions()
          vim.ui.select(vim.tbl_keys(actions), {
            prompt = "Git actions",
          }, function(selected)
            if selected ~= nil then actions[selected]() end
          end)
        end,
      },
      {
        "<leader>gd",
        function()
          local gs = require("gitsigns")
          gs.toggle_linehl()
          gs.toggle_word_diff()
          gs.toggle_deleted()
          gs.preview_hunk_inline()
        end,
      },
      {
        "<leader>gj",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end,
      },
      {
        "<leader>gk",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
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
    "Chaitanyabsprip/fastaction.nvim",
    config = true,
    keys = {
      { "<leader>la", function() require("fastaction").code_action() end },
      { "<leader>la", function() require("fastaction").range_code_action() end, mode = "x" },
    },
  },

  -- Other plugins
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy", -- needed
    -- won't be loaded on shortcut, but on event
    keys = { -- TODO: fix error on first lazy invocation
      { "+", "<CMD>silent! foldopen<CR>", silent = true, mode = "n" },
      { "-", "<CMD>silent! foldclose<CR>", silent = true, mode = "n" },
      { "<C-+>", "<CMD>silent! foldopen<CR>", silent = true },
      { "<C-*>", "<CMD>silent! foldopen<CR>", silent = true },
      { "<C-=>", "<CMD>silent! foldopen<CR>", silent = true },
      { "<C-_>", "<CMD>silent! foldclose<CR>", silent = true },
      { "<C-->", "<CMD>silent! foldclose<CR>", silent = true },
      { "<C-S-->", function() require("ufo").closeFoldsWith(1) end, silent = true },
      { "<C-S-_>", function() require("ufo").closeFoldsWith(1) end, silent = true },
      { "<C-+>", function() require("ufo").openAllFolds() end, silent = true },
      { "<C-S-=>", function() require("ufo").openAllFolds() end, silent = true },
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
        provider_selector = function(_, _, _) return { "indent" } end,
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
      { "<C-_>", "<Plug>(comment_toggle_linewise_current)", mode = "n" },
      { "<C-/>", "<Plug>(comment_toggle_linewise_current)", mode = "n" },
      { "<C-7>", "<Plug>(comment_toggle_linewise_current)", mode = "n" },
      { "<C-S-/>", "<Plug>(comment_toggle_linewise_current)", mode = "n" },
      { "<C-\\>", "<Plug>(comment_toggle_blockwise_current)", mode = "n" },
      { "<C-S-?>", "<Plug>(comment_toggle_blockwise_current", mode = "n" },
      { "<C-/>", "<Plug>(comment_toggle_linewise_visual)", mode = "x" },
      { "<C-_>", "<Plug>(comment_toggle_linewise_visual)", mode = "x" },
      { "<C-7>", "<Plug>(comment_toggle_linewise_visual)", mode = "x" },
      { "<C-S-/>", "<Plug>(comment_toggle_linewise_visual)", mode = "x" },
      { "<C-\\>", "<Plug>(comment_toggle_blockwise_visual)", mode = "x" },
      { "<C-S-?>", "<Plug>(comment_toggle_blockwise_visual)", mode = "x" },
    },
  },
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>lf",
        function() require("conform").format({ async = true }) end,
        mode = { "n", "x", "v" },
      },
    },
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
        scss = { "prettier", lsp_format = "prefer" },
        css = { "prettier" },
        awk = { "awk" },
        lua = { "stylua" },
        python = { "isort", "black" },
        go = { "goimports-reviser", "gofmt" },
        terraform = { "terraform_fmt" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        swift = { "swiftformat" },
        ruby = { "rubocop" },
        elixir = { "mix", lsp_format = "prefer" },
        gleam = { "gleam" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        cmake = { "gersemi" },
        heex = { "mix", lsp_format = "prefer" },
        rust = { "rustfmt" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        dockerfile = { "hadolint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        terraform = { "tflint" },
        ghaction = { "actionlint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function() lint.try_lint() end,
      })

      lint.try_lint()
    end,
  },
  { "Darazaki/indent-o-matic", event = "InsertEnter" },
  { "OXY2DEV/helpview.nvim", ft = "help" },
  "neovim/nvim-lspconfig",
  {
    "saghen/blink.cmp",
    lazy = true, -- lazy loading handled internally
    build = function()
      -- Reload the module during :Lazy update/build so the native artifact is
      -- named for the newly checked-out commit, not a cached blink.cmp module.
      package.loaded["blink.cmp"] = nil
      require("blink.cmp").build({ force = true }):pwait(60000)
    end,
    dependencies = "saghen/blink.lib",
    opts = {
      cmdline = { enabled = true },
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        menu = {
          border = "none",
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 750,
          window = {
            border = "rounded",
          },
        },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "rust" },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },
  {
    "aileot/ex-colors.nvim",
    cmd = { "ExColors" },
    config = true,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      animate = { enabled = true }, -- really??
      bigfile = { enabled = true }, -- disables LSP, TS highlighting for big files
      -- input = { enabled = true }, -- better vim.ui.input (really?)
      explorer = { enabled = true, auto_close = true }, -- file explorer. needed?
      quickfile = { enabled = true }, -- delays LSP and TS highlighting when opening a file
      scroll = { -- smooth scrolling animation. really?
        enabled = true,
        animate = {
          duration = { step = 15, total = 150 },
        },
      },
      picker = {
        matcher = {
          frecency = true, -- frecency bonus
        },
        sources = {
          files = {
            layout = { preset = function() return vim.o.columns >= 120 and "ivy" or "vertical" end },
          },
          grep = {
            layout = { preset = function() return vim.o.columns >= 120 and "ivy" or "vertical" end },
          },
          explorer = {
            layout = { preset = function() return vim.o.columns >= 120 and "ivy" or "vertical" end },
            auto_close = true,
          },
          lines = {
            layout = { preset = function() return vim.o.columns >= 120 and "ivy" or "vertical" end },
          },
          marks = {
            layout = { preset = function() return vim.o.columns >= 120 and "ivy" or "vertical" end },
          },
          buffers = {
            layout = { preset = function() return vim.o.columns >= 120 and "ivy" or "vertical" end },
          },
          recent = {
            layout = { preset = function() return vim.o.columns >= 120 and "ivy" or "vertical" end },
          },
          resume = {
            layout = { preset = function() return vim.o.columns >= 120 and "ivy" or "vertical" end },
          },
          git_diff = {
            layout = {
              preset = "sidebar",
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<c-t>"] = {
                "trouble_open",
                mode = { "n", "i" },
              },
              ["<S-NL>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-S-K>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["J"] = { "preview_scroll_down", mode = { "n" } },
              ["K"] = { "preview_scroll_up", mode = { "n" } },
            },
          },
          preview = {
            keys = {
              ["<S-NL>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-S-K>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["J"] = { "preview_scroll_down", mode = { "n" } },
              ["K"] = { "preview_scroll_up", mode = { "n" } },
            },
          },
          list = {
            keys = {
              ["<S-NL>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-S-K>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["J"] = { "preview_scroll_down", mode = { "n" } },
              ["K"] = { "preview_scroll_up", mode = { "n" } },
            },
          },
        },
        enabled = true,
      },
    },
    keys = {
      {
        "<leader>si",
        function()
          if Snacks.indent.enabled then
            Snacks.indent.disable()
          else
            Snacks.indent.enable()
          end
        end,
      },
      {
        "<leader>sd",
        function()
          if Snacks.dim.enabled then
            Snacks.dim.disable()
          else
            Snacks.dim.enable()
          end
        end,
      },

      { "<leader>gg", function() Snacks.lazygit() end },
      { "<C-r>", function() Snacks.picker.resume() end },
      { "<C-S-R>", function() Snacks.picker.recent() end },
      { "<C-b>", function() Snacks.picker.buffers() end },
      { "<C-e>", function() Snacks.picker.marks() end },
      { "<C-S-n>", function() Snacks.explorer.reveal() end },
      { "<C-n>", function() Snacks.picker.files() end },
      { "<C-f>", function() Snacks.picker.grep() end },
      { "<C-l>", function() Snacks.picker.lines() end },
      { "<C-d>", function() Snacks.picker.git_diff() end },
    },
  },
  {
    "qvalentin/helm-ls.nvim",
    ft = "helm",
    opts = {
      conceal_templates = {
        enabled = true,
      },
    },
  },
  {
    "carlos-algms/agentic.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    opts = {
      provider = "antigravity-acp",
      acp_providers = {
        ["antigravity-acp"] = {
          name = "Antigravity",
          command = "/Users/pkos98/src/pkos98/acp/dist/agy-acp-darwin-arm64",
          args = {},
          env = {
            AGY_BIN = "/Users/pkos98/.local/bin/agy",
          },
        },
      },
      settings = {
        move_cursor_to_chat_on_submit = false,
      },
      keymaps = {
        prompt = {
          submit = {
            "<CR>",
            { "<C-s>", mode = { "i", "n", "v" } },
            { "<C-CR>", mode = { "i", "n", "v" } },
          },
        },
      },
    },
    config = function(_, opts)
      require("agentic").setup(opts)

      -- Intercept prompt submissions to inject active editor context on-demand
      local acp_client = require("agentic.acp.acp_client")
      local original_send_prompt = acp_client.send_prompt

      acp_client.send_prompt = function(self, session_id, prompt, callback)
        -- Find a normal code window in the current tabpage
        local active_win = nil
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buftype = vim.bo[buf].buftype
          local name = vim.api.nvim_buf_get_name(buf)

          -- Find the window editing a real file, skipping agentic panels
          if buftype == "" and name ~= "" and not name:match("agentic://") and not name:match("Agentic") then
            active_win = win
            break
          end
        end

        if active_win then
          local buf = vim.api.nvim_win_get_buf(active_win)
          local file_path = vim.api.nvim_buf_get_name(buf)
          local cursor = vim.api.nvim_win_get_cursor(active_win)
          local line_num = cursor[1]

          local total_lines = vim.api.nvim_buf_line_count(buf)
          local start_mark = vim.api.nvim_buf_get_mark(buf, "<")
          local end_mark = vim.api.nvim_buf_get_mark(buf, ">")
          local start_line = start_mark[1]
          local end_line = end_mark[1]

          local code_start_line, code_end_line
          local is_visual = start_line > 0 and end_line > 0 and line_num >= start_line and line_num <= end_line

          if is_visual then
            code_start_line = start_line
            code_end_line = end_line
          else
            code_start_line = math.max(1, line_num - 50)
            code_end_line = math.min(total_lines, line_num + 50)
          end

          local lines = vim.api.nvim_buf_get_lines(buf, code_start_line - 1, code_end_line, false)
          local snippet = table.concat(lines, "\n")

          local context_text = string.format(
            "<active_editor_context>\n<path>%s</path>\n<cursor_line>%d</cursor_line>\n<context_type>%s</context_type>\n<surrounding_code line_start=\"%d\" line_end=\"%d\">\n%s\n</surrounding_code>\n</active_editor_context>",
            file_path,
            line_num,
            is_visual and "visual_selection" or "cursor_surroundings",
            code_start_line,
            code_end_line,
            snippet
          )

          -- Inject the code context into the prompt payload
          table.insert(prompt, 1, {
            type = "text",
            text = context_text,
          })
        end

        return original_send_prompt(self, session_id, prompt, callback)
      end

      -- Retain insert mode in prompt buffer after submission
      local chat_widget = require("agentic.ui.chat_widget")
      local original_submit_input = chat_widget._submit_input

      chat_widget._submit_input = function(self)
        original_submit_input(self)

        local Config = require("agentic.config")
        if not Config.settings.move_cursor_to_chat_on_submit then
          vim.schedule(function()
            if vim.api.nvim_get_current_buf() == self.buf_nrs.input then
              vim.cmd("startinsert!")
            end
          end)
        end
      end
    end,
    keys = {
      {
        "<leader>aa",
        function()
          local registry = require("agentic.session_registry")
          local session = registry.get_session_for_tab_page()
          if session and session.widget:is_open() then
            session.widget:hide()
          else
            require("agentic").toggle()
            vim.schedule(function()
              session = registry.get_session_for_tab_page()
              local win_nrs = session and session.widget.win_nrs
              local winid = win_nrs and win_nrs.input
              if winid and vim.api.nvim_win_is_valid(winid) then
                vim.api.nvim_set_current_win(winid)
                vim.cmd("startinsert!")
              end
            end)
          end
        end,
        desc = "Toggle Agentic Chat and Enter Insert Mode",
        mode = { "n", "v", "i" },
      },
      {
        "<leader>as",
        function()
          local registry = require("agentic.session_registry")
          local session = registry.get_session_for_tab_page()
          if not session or not session.widget:is_open() then
            require("agentic").toggle()
          end
          vim.schedule(function()
            session = registry.get_session_for_tab_page()
            local win_nrs = session and session.widget.win_nrs
            local winid = win_nrs and win_nrs.input
            if winid and vim.api.nvim_win_is_valid(winid) then
              vim.api.nvim_set_current_win(winid)
              vim.cmd("startinsert!")
            end
          end)
        end,
        desc = "Focus Agentic Chat (Insert Mode)",
        mode = { "n", "v", "i" },
      },
      {
        "<leader>AA",
        function()
          local registry = require("agentic.session_registry")
          local session = registry.get_session_for_tab_page()
          if not session or not session.widget:is_open() then
            require("agentic").toggle()
          end
          vim.schedule(function()
            session = registry.get_session_for_tab_page()
            local win_nrs = session and session.widget.win_nrs
            local winid = win_nrs and win_nrs.input
            if winid and vim.api.nvim_win_is_valid(winid) then
              vim.api.nvim_set_current_win(winid)
              vim.cmd("startinsert!")
            end
            vim.fn.jobstart({ "open", "-g", "wispr-flow://start-hands-free" })
          end)
        end,
        desc = "Open Agentic Chat (Insert Mode) and Start Wispr Flow (Async)",
        mode = { "n", "v", "i" },
      },
      {
        "<leader>ac",
        function() require("agentic").add_selection_or_file_to_context({ focus_prompt = false }) end,
        desc = "Add current file/selection to Agentic context",
        mode = { "n", "v" },
      },
    },
  },
  ---@diagnostic disable-next-line: missing-fields
}
