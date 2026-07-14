-- ########################
-- #    VIM SETTINGS      #
-- ########################
vim.g.mapleader = ","
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.shell = "/bin/zsh"
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
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cmdheight = 0
vim.g.updatetime = 500 -- recommended https://github.com/airblade/vim-gitgutter#when-are-the-signs-updated
vim.opt.exrc = true
vim.opt.diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram"
vim.diagnostic.config({ -- don't display text signs ('W', 'E') only highlight line and num
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = "WarningMsg",
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
    },
  },
})
vim.loader.enable()

-- Load global keymaps (non-plugin keymaps)
require("keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
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

require("lazy").setup(require("plugins"), { dev = { path = "~/src" } })

require("lsp")

require("cmd")
