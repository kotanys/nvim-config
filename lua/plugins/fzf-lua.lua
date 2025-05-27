return {
    "ibhagwan/fzf-lua",
    lazy = false,
    -- optional for icon support
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    dependencies = { "echasnovski/mini.icons" },
    opts = {
        "hide",
        files = {
            file_ignore_patterns = { "%.cache/", -- clangd cache
                                     "%.o$" }, -- object files
        }
    },
    config = function() 
        vim.keymap.set("n", "<c-p>", function () require('fzf-lua').files() end, { silent = true })
        vim.keymap.set("n", "<c-\\>", function () require('fzf-lua').buffers() end, { silent = true })
        vim.keymap.set("n", "<c-g>", function () require('fzf-lua').grep() end, { silent = true })
    end,
}
