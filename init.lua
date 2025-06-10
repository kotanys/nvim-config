-- Make sure to setup `mapleader` and `maplocalleader` before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require('options')

require('config.keybindings')
require('config.clipboard')
require('config.lazy')

vim.opt.guifont = "CaskaydiaCove NF"
