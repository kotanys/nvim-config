vim.keymap.set("n", "<C-p>", function () require('fzf-lua').files() end, { silent = true })
vim.keymap.set("n", "<c-\\>", function () require('fzf-lua').buffers() end, { silent = true })
vim.keymap.set("n", "<c-g>", function () require('fzf-lua').grep() end, { silent = true })
