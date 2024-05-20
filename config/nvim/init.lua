-- ########################
-- #    VIM SETTINGS      #
-- ########################
vim.g.mapleader = ","
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.o.number = true
vim.o.mouse = "a"
vim.o.termguicolors = true
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
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
		lazy = false,
		config = function()
			require("onedarkpro").setup({
				colors = {
					bg = "#1f2329",
				},
				highlights = {},
			})
			vim.cmd.colorscheme("onedark")
		end,
		enabled = true,
	},

	{
		"folke/neodev.nvim",
		opts = {
			override = function(_, lib)
				lib.enabled = true
				lib.plugins = true
			end,
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

	{
		"folke/trouble.nvim",
		keys = {
			{ "<leader>xx", function() require("trouble").toggle() end },
			{ "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end },
			{ "<leader>xd", function() require("trouble").toggle("document_diagnostics") end },
			{ "<leader>xq", function() require("trouble").toggle("quickfix") end },
			{ "<leader>xl", function() require("trouble").toggle("loclist") end },
			{ "<leader>lr", function() require("trouble").toggle("lsp_references") end },
			{
				"<C-j>",
				function() require("trouble").next({ skip_groups = true, jump = true }) end,
				mode = { "i", "n" },
			},
			{
				"<C-k>",
				function() require("trouble").previous({ skip_groups = true, jump = true }) end,
				mode = { "i", "n" },
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{ "gabrielpoca/replacer.nvim", enabled = false },

	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.4",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
		keys = {
			{ "<C-n>", function() require("telescope.builtin").find_files() end },
			{ "<C-e>", function() require("telescope.builtin").buffers() end },
			{
				"<C-f>",
				function()
					vim.cmd('noau normal! "vy"')
					local search_text = vim.fn.getreg("v")
					vim.fn.setreg("v", {})
					search_text = string.gsub(search_text, "\n", "")
					require("telescope.builtin").live_grep({ default_text = search_text })
				end,
				mode = { "n", "x", "i" },
			},
			{ "<C-S-F>", function() require("telescope.builtin").live_grep() end },
			{ "<C-Space>", function() require("telescope.builtin").builtin() end },
			{ "<leader>lrr", function() require("telescope.builtin").lsp_references() end },
			{
				"<leader>ls",
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
		},
		config = function()
			local actions = require("telescope.actions")
			local trouble = require("trouble.providers.telescope")
			local telescope = require("telescope")
			telescope.setup({
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- default or "ignore_case" or "respect_case"
					},
				},
				defaults = {
					mappings = {
						n = {
							["<Esc>"] = actions.close,
							["q"] = actions.close,
							["<C-q>"] = trouble.open_with_trouble,
						},
						i = { ["<C-q>"] = trouble.open_with_trouble },
					},
					pickers = {
						buffers = {
							mappings = {
								i = {
									["<C-e>"] = actions.move_selection_next,
								},
							},
						},
					},
				},
			})
			telescope.load_extension("fzf")
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		keys = {
			{ "<A-1>", function() require("nvim-tree.api").tree.toggle() end },
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
		"folke/which-key.nvim",
		keys = { { "<leader>wk", "<CMD>WhichKey<CR>" } },
	},

	{
		"rcarriga/nvim-dap-ui",
		init = function() vim.fn.sign_define("DapBreakpoint", { text = "•", texthl = "red", linehl = "", numhl = "" }) end,
		--[[ vim.fn.sign_define("DapBreakpoint", { text = "🔺", texthl = "", linehl = "", numhl = "" }) end, ]]
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
	},

	{
		"numToStr/Comment.nvim",
		config = true,
		keys = {
			{ "<C-/>", "<Plug>(comment_toggle_linewise_current)", mode = "n" },
			{ "<C-S-/>", "<Plug>(comment_toggle_linewise_current)", mode = "n" },
			{ "<C-\\>", "<Plug>(comment_toggle_blockwise_current)", mode = "n" },
			{ "<C-S-?>", "<Plug>(comment_toggle_blockwise_current", mode = "n" },
			{ "<C-/>", "<Plug>(comment_toggle_linewise_visual)", mode = "x" },
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
					prepend_args = { "--collapse-simple-statement", "Always", "--indent-type", "Tabs", "--indent-width", 2 },
				},
			},
			formatters_by_ft = {
				typescript = { "biome-check" },
				typescriptreact = { "biome-check" },
				javascriptreact = { "biome-check" },
				javascript = { "biome-check" },
				awk = { "awk" },
				lua = { "stylua" },
				python = { "isort", "black" },
				go = { "goimports-reviser", "gofmt" },
				terraform = { "terraform_fmt" },
				bash = { "shfmt" },
				sh = { "shfmt" },
			},
		},
	},

	{
		"jackMort/ChatGPT.nvim",
		event = "InsertEnter",
		opts = { api_host_cmd = "echo http://127.0.0.1:4000" },
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

	{ "grapp-dev/nui-components.nvim", dependencies = "MunifTanjim/nui.nvim" },

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				theme = "onedark",
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
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>gp", function() require("gitsigns").preview_hunk() end },
			{ "<leader>gc", function() require("gitsigns").toggle_current_line_blame() end },
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
			"LazyGitBranch",
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
		keys = { { "<leader>gB", "<CMD>BlameToggle<CR>", silent = true } },
		opts = { commit_detail_view = "split" },
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		keys = { -- TODO: fix error on first invocation
			{ "<C-S-+>", "<CMD>silent! foldopen<CR>", silent = true },
			{ "<C-S-*>", "<CMD>silent! foldopen<CR>", silent = true },
			{ "<C-S-_>", "<CMD>silent! foldclose<CR>", silent = true },
			{ "<leader>up", function() require("ufo.preview"):peekFoldedLinesUnderCursor() end },
		},
		init = function()
			vim.o.foldcolumn = "0" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		opts = {
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
						-- str width returned from truncate() may less than 2nd argument, need padding
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
		},
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "typescriptreact", "javascriptreact", "javascript" },
		config = true,
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"onsails/lspkind.nvim", -- fancy icons
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-calc",
			-- "hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"dcampos/cmp-snippy",
			{
				"dcampos/nvim-snippy",
        "honza/vim-snippets",
				event = "InsertEnter",
				config = function()
					require("snippy").setup({
						mappings = {
							is = {
								["<Tab>"] = "expand_or_advance",
								["<S-Tab>"] = "previous",
							},
							nx = {
								["<leader>x"] = "cut_text",
							},
						},
					})
				end,
			},
		},
		config = function()
			local cmp = require("cmp")
			local types = require("cmp.types")
			cmp.setup({
				experimental = {
					ghost_text = true,
				},
				snippet = {
					expand = function(args) require("snippy").expand_snippet(args.body) end,
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
							luasnip = "✂",
						},
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
					["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					-- { name = "nvim_lua" },
					{ name = "snippy" },
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
vim.keymap.set("n", "YY", '"+yy') -- yank to clipboard
vim.keymap.set({ "n", "x" }, "Y", '"+y') -- yank to clipboard

-- LSP keymaps
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation)
vim.keymap.set("n", "<leader>ll", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader><space>", vim.lsp.buf.code_action)
vim.keymap.set("n", "<C-h>", vim.lsp.buf.hover)
vim.keymap.set("n", "<C-h-h>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<A-Left>", "<C-O>", opts_silent)
vim.keymap.set("n", "<A-Right>", "<C-I>", opts_silent)

-- ############################
-- #            LSP           #
-- ############################
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
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- library = vim.api.nvim_get_runtime_file("", true),
				library = { require("neodev.config").types() },
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
			hint = {
				enable = true,
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})
capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig["html"].setup {
  capabilities = capabilities,
}

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
