local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')

cmd([[let g:python3_host_prog='/bin/python3.9']])
cmd([[let g:loaded_python3_provider=0]])
cmd([[let g:loaded_pythonx_provider=0]])

require('general/settings')                 -- General settings for global, window and buffer scopes
require('general/mappings')                 -- General keymappings independent from plugins


require('plugins')                          -- Load plugins using paq
require('base16-colorscheme').setup('schemer-dark')
