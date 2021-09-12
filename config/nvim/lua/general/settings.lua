local global_opts = vim.o
local buffer_opts = vim.bo
local window_opts = vim.wo

local indent = 4

vim.cmd([[let g:python3_host_prog='/bin/python3.9']])
vim.cmd([[let g:loaded_python3_provider=0]])
vim.cmd([[let g:loaded_pythonx_provider=0]])

local global_options = {
    completeopt = 'menuone,noinsert,noselect';  -- Completion options (for deoplete)
    hidden = true;                              -- Enable modified buffers in background
    ignorecase = true;                          -- Ignore case
    joinspaces = false;                         -- No double spaces with join after a dot
    scrolloff = 4;                              -- Lines of context
    shiftround = true;                          -- Round indent
    sidescrolloff = 8;                          -- Columns of context
    smartcase = true;                           -- Don't ignore case with capitals
    splitbelow = true;                          -- Put new windows below current
    splitright = true;                          -- Put new windows right of current
    termguicolors = true;                       -- True color support
    wildmode = 'list:longest';                  -- Command-line completion mode
    mouse ='a';
    guifont = 'Jetbrains Mono:h12';
}

local window_options = {
    --list = true;                                -- Show some invisible characters (tabs...)
    number = true;                              -- Print line number
    relativenumber = true;                      -- Relative line numbers
    wrap = false;
}

local buffer_options = {
    expandtab = true;                           -- Use spaces instead of tabs
    shiftwidth = indent;                        -- Size of an indent
    smartindent = true;                         -- Insert indents automatically
    tabstop = indent;                           -- Number of spaces tabs count for
}

for key, value in pairs(global_options) do
     global_opts[key] = value
end
for key, value in pairs(window_options) do
     window_opts[key] = value
end
for key, value in pairs(buffer_options) do
     buffer_opts[key] = value
end
vim.cmd([[au BufRead,BufNewFile *.json set filetype=json]])
vim.cmd([[au BufRead,BufNewFile *.lua set shiftwidth=2]])
vim.cmd([[au BufRead,BufNewFile *.rkt set shiftwidth=2]])
vim.cmd([[au UIEnter * lua require('general/gui')]])
