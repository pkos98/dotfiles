local function keymap_silent(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
end

-- Base Editor Control
keymap_silent("n", "<C-S-l>", "<CMD>Lazy<CR>")
keymap_silent("n", "<leader>q", "<CMD>q!<CR>")
keymap_silent("n", "<leader>ec", "<CMD>vsplit ~/.config/nvim/init.lua<CR>")
keymap_silent("n", "<leader>,", "<CMD>write<CR>")
keymap_silent("n", "<leader>.", "<CMD>q<CR>")

-- Clipboard integration
vim.keymap.set("n", "YY", '"+yy') -- yank to clipboard
vim.keymap.set({ "n", "x" }, "Y", '"+y') -- yank to clipboard
vim.keymap.set({ "n", "x" }, "D", '"+d') -- cut to clipboard

-- Navigation
keymap_silent("n", "<A-Left>", "<C-O>") -- go back
keymap_silent("n", "<M-b>", "<C-O>") -- go back
keymap_silent("n", "<Left>", "<C-O>") -- go back
keymap_silent("n", "<A-Right>", "<C-I>") -- go forward
keymap_silent("n", "<M-f>", "<C-I>") -- go forward
keymap_silent("n", "<Right>", "<C-I>") -- go forward

-- Lazy Reload Utility
vim.keymap.set("n", "<leader>pr", function()
  local plugins = require("lazy").plugins()
  local plugin_names = {}
  for _, plugin in ipairs(plugins) do
    table.insert(plugin_names, plugin.name)
  end

  vim.ui.select(plugin_names, {
    title = "Reload plugin",
  }, function(selected) require("lazy").reload({ plugins = { selected } }) end)
end)
