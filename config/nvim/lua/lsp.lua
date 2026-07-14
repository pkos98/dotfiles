-- ==========================================
-- =               LSP Keymaps              =
-- ==========================================
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation)
vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>ll", function()
  vim.lsp.buf.hover()
  vim.lsp.buf.hover()
end)
vim.keymap.set("n", "<leader>le", function()
  vim.diagnostic.config({
    virtual_text = not vim.diagnostic.config().virtual_text,
  })
end, { desc = "Toggle diagnostic virtual text" })

vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>lci", vim.lsp.buf.incoming_calls)

-- ==========================================
-- =               LSP Config               =
-- ==========================================
vim.o.winborder = "single"
local capabilities = require("blink.cmp").get_lsp_capabilities()

local default_config_lsps = {
  "terraformls",
  "clangd",
  "gopls",
  "rust_analyzer",
  "dockerls",
  "lua_ls",
  "ts_ls",
  "gleam",
  "helm_ls",
  "pkl-lsp",
}
for _, lsp in ipairs(default_config_lsps) do
  vim.lsp.config[lsp] = { capabilities = capabilities }
end

vim.lsp.config.ruff = {
  on_attach = function(client, _)
    if client.name == "ruff" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
}
vim.lsp.config.basedpyright = {
  capabilities = capabilities,
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        ignore = { "*" },
        typeCheckingMode = "off",
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}

vim.lsp.config.bashls = {
  filetypes = { "sh", "bash", "zsh" },
  capabilities = capabilities,
  bashIde = {
    globPattern = "*@(.sh|.inc|.bash|.command)",
    explainshellEndpoint = "http://localhost:8888",
  },
}
vim.lsp.config.sourcekit = {
  filetypes = { "swift" },
  capabilities = capabilities,
}
vim.lsp.config("dexter", {
  cmd = { "dexter", "lsp" },
  root_markers = { ".dexter.db", ".git", "mix.exs" },
  filetypes = { "elixir", "eelixir", "heex" },
  init_options = {
    followDelegates = true, -- jump through defdelegate to the target function
  },
})

vim.lsp.enable("dexter")
vim.capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config.html = {
  capabilities = capabilities,
}
vim.lsp.config.cssls = {
  capabilities = capabilities,
}

local all_lsps =
  vim.list_extend(default_config_lsps, { "sourcekit", "html", "cssls", "bashls", "basedpyright", "ruff", "dexter" })
vim.lsp.enable(all_lsps)

-- LSP User Commands
vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", { desc = "Show LSP Info" })
vim.api.nvim_create_user_command(
  "LspLog",
  function() vim.cmd.edit(vim.fs.joinpath(vim.fn.stdpath("state"), "lsp.log")) end,
  { desc = "Show LSP log" }
)
vim.api.nvim_create_user_command("LspRestart", "lsp restart", { desc = "Restart LSP" })

-- Helm Template Toggle Utility & Keymap
vim.keymap.set("n", "<leader>lh", function()
  local ok, helm_ls = pcall(require, "helm-ls")
  if not ok then
    vim.notify("helm-ls plugin not loaded (open a helm file first)", vim.log.levels.WARN)
    return
  end

  local enabled = not helm_ls.config.conceal_templates.enabled
  helm_ls.setup({
    conceal_templates = {
      enabled = enabled,
    },
  })

  local bufnr = vim.api.nvim_get_current_buf()
  local ns_id = vim.api.nvim_create_namespace("helm-ls-conceal")
  if not enabled then
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
    vim.opt_local.conceallevel = 0
  else
    vim.opt_local.conceallevel = 2
    require("helm-ls.conceal").update_conceal_templates()
  end
  vim.notify("Helm virtual text: " .. (enabled and "Enabled" or "Disabled"), vim.log.levels.INFO)
end, { desc = "Toggle Helm template virtual text" })
