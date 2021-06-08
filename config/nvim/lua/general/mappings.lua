local g = vim.g
local api = vim.api
local cmd = vim.cmd

g.mapleader = ','
g.localleader = ','

local function init_lsp_mappings(buf_set_keymap, opts) 
  buf_set_keymap('n', '<F12>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<C-q>', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-r>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<C-<F12>>', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

function _G.find_files_nvim_config()
  require("telescope.builtin").file_browser {
    follow = true,
    cwd = "~/.config/nvim",
    prompt = "dotfiles",
    heigth = 10,
    layout_strategy = "horizontal",
    layout_options = {
      preview_width = 0.75,
    },
  }
end

api.nvim_set_keymap('n', '<leader>fn', [[:lua find_files_nvim_config()<CR>]], { noremap = true, silent = false })
api.nvim_set_keymap('n', '<C-f>', [[:lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = false })
api.nvim_set_keymap('n', '<C-p>', [[:lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = false })
api.nvim_set_keymap('n', '<C-e>', [[:lua require('telescope.builtin').file_browser()<CR>]], { noremap = true, silent = false })
api.nvim_set_keymap('n', '<C-,>', [[:lua require('telescope.builtin').lsp_references()<CR>]], { noremap = true, silent = false })

-- Support autocompletion navigation using TABs
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

cmd([[inoremap <silent><expr> <C-Space> compe#complete()]])
cmd([[inoremap <silent><expr> <CR>      compe#confirm('<CR>')]])
cmd([[inoremap <silent><expr> <C-e>     compe#close('<C-e>')]])
cmd([[inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })]])
cmd([[inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })]])

cmd([[nmap <C-t>        :IronRepl<CR>]])
cmd([[nmap <leader>t    <Plug>(iron-send-motion)]])
cmd([[nmap <leader>a    <Plug>(iron-send-file)]])
cmd([[vmap <leader>v    <Plug>(iron-visual-send)]])
cmd([[nmap <leader>r    <Plug>(iron-repeat-cmd)]])
cmd([[nmap <leader>l    <Plug>(iron-send-line)]])
cmd([[nmap <localleader><CR> <Plug>(iron-cr)]])
cmd([[nmap <localleader>i    <plug>(iron-interrupt)]])
cmd([[nmap <localleader>q    <Plug>(iron-exit)]])
cmd([[nmap <localleader>c    <Plug>(iron-clear)]])

cmd([[tnoremap <Esc> <C-\><C-n>]])

return {
  init_lsp_mappings = init_lsp_mappings
}
