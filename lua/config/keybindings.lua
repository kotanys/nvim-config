vim.keymap.set("n", "<C-p>", function () require('fzf-lua').files() end, { silent = true })
vim.keymap.set("n", "<C-\\>", function () require('fzf-lua').buffers() end, { silent = true })
