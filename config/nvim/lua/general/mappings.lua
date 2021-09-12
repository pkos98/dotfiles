local g = vim.g
local cmd = vim.cmd
local mapper = require('nvim-mapper')
local iron = require('iron')

g.mapleader = ','
g.localleader = ','


local function init_lsp_mappings(buf_set_keymap, opts)
  buf_set_keymap('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>', opts, "LSP", "lsp_definitions", "Go to definitions")
  buf_set_keymap('n','gD','<cmd>lua vim.lsp.buf.definition()<CR>', opts, "LSP", "lsp_definitions_2", "Go to definitions")
  buf_set_keymap('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>', opts, "LSP", "lsp_signature", "View signature")
  buf_set_keymap('n','ca','<cmd>lua vim.lsp.buf.code_action()<CR>', opts, "LSP", "lsp_quick_action", "Invoke quick actions")
  buf_set_keymap('n','<leader>qq','<cmd>lua vim.lsp.buf.hover()<CR>', opts, "LSP", "lsp_hover", "Hover")
  buf_set_keymap('n','<leader>rr','<cmd>lua vim.lsp.buf.rename()<CR>', opts, "LSP", "lsp_rename", "Rename symbol")
  buf_set_keymap('n','<leader>ff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts, "LSP", "lsp_format", "format")
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return index
        end
    end

    return false
end


-- Toggles an iron repl with the addition of creating a zsh repl as fallback if the
-- current buffer's filetype doesnt have any repl mapping
function Iron_repl_with_fallback()
  local ft = vim.bo.filetype
    if ft == '' or has_value(iron.core.list_fts(), ft) == false then
      cmd([[:IronRepl zsh]])
    else
      cmd([[:IronRepl]])
  end
end

function Iron_send_file()
  local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
  content = table.concat(content, "\n")
  local ft = vim.bo.filetype
  iron.core.send(ft, content)
end


mapper.map('n', '<C-f>', [[:Telescope live_grep<CR>]], { noremap = true, silent = false }, "Telescope", "telescope_grep", "Find text")
mapper.map('n', '<C-p>', [[:Telescope find_files<CR>]], { noremap = true, silent = false }, "Telescope", "telescope_file", "Find file")
--mapper.map('n', '<C-e>', [[:Telescope file_browser theme=get_ivy<CR>]], { noremap = true, silent = false }, "Telescope", "telescope_explorer", "File explorer")
mapper.map('n', '<leader>fn', [[:Telescope find_files follow=true cwd=~/.config/nvim prompt=nvim-config<CR>]], { noremap = true, silent = false }, "Telescope", "telescope_neovim_settings", "Neovim settings")
mapper.map('n', '<C-p>', [[:Telescope project<CR>]], { noremap = true, silent = true }, "Telescope", "telescope_project_find", "Find project")
mapper.map('n', '<leader>mm', [[\MM]], { noremap = false, silent = true }, "Telescope", "telescope_action", "Find action")
mapper.map('n', '<C-S-a>', [[\MM]], { noremap = false, silent = true }, "Telescope", "telescope_action2", "Find action")

-- for gui
mapper.map('n', '<C-S-n>', [[:Telescope find_files<CR>]], { noremap = true, silent = false }, "Telescope", "telescope_file_gui", "Find file")
mapper.map('n', '<C-n>', [[:Telescope find_files<CR>]], { noremap = true, silent = false }, "Telescope", "telescope_file_gui2", "Find file")
mapper.map('n', '<A-1>', [[:Telescope file_browser theme=get_ivy<CR>]], { noremap = true, silent = false }, "Telescope", "telescope_explorer_gui", "File explorer")

-- Support autocompletion navigation using TABs
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

cmd([[inoremap <silent><expr> <C-Space> compe#complete()]])
cmd([[inoremap <silent><expr> <CR>      compe#confirm('<CR>')]])
cmd([[inoremap <silent><expr> <C-e>     compe#close('<C-e>')]])
cmd([[inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })]])
cmd([[inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })]])

--mapper.map('n', '<C-t>', [[:IronRepl<CR>]], {}, "Iron", "iron_repl", "Toggle Iron REPL")
mapper.map('n', '<C-t>', [[:lua Iron_repl_with_fallback()<CR>]], {}, "Iron", "iron_repl", "Toggle Iron REPL")
mapper.map('t', '<C-t>', [[:lua Iron_repl_with_fallback()<CR>]], {}, "Iron", "iron_repl_terminal-mode", "Toggle Iron REPL")
mapper.map('n', '<leader>ta', [[:lua Iron_send_file()<CR>]], {}, "Iron", "iron_send_file", "Send file content to Iron REPL")
mapper.map('n', '<leader>tf', [[:lua Iron_send_file()<CR>]], {}, "Iron", "iron_send_file2", "Send file content to Iron REPL")
mapper.map('v', '<leader>tv', [[<Plug>(iron-visual-send)]], {}, "Iron", "iron_send_visual", "Send visual selection to Iron REPL")
mapper.map('n', '<leader>tl', [[<Plug>(iron-send-line)]], {}, "Iron", "iron_send_line", "Send current line to Iron REPL")
--cmd([[au BufLeave terminal noremap <silent> <C-t> :IronRepl<CR>]])


-- exit terminal mode with <Esc>
cmd([[tnoremap <Esc> <C-\><C-n>]])

return {
  init_lsp_mappings = init_lsp_mappings
}
