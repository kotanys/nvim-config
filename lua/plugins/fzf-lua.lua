return {
    "ibhagwan/fzf-lua",
    lazy = false,
    -- optional for icon support
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    dependencies = { "echasnovski/mini.icons" },
    opts = {
        files = {
            file_ignore_patterns = {
                "%.cache/", -- clangd cache
                "%.o$"      -- object files
            },
        }
    },
    config = function()
        local fzf = require('fzf-lua')
        local map = vim.keymap.set
        map("n", "<F1>", fzf.help_tags, { silent = true })
        map("n", "<c-p>", fzf.files, { silent = true })
        map("n", "<c-\\>", fzf.buffers, { silent = true })
        map("n", "<c-g>", fzf.grep, { silent = true })
        map("n", "<Leader>K", fzf.manpages, { silent = true })
        map("n", "<Leader>g", fzf.grep_cword, { silent = true })
        map("n", "<Leader>G", fzf.grep_cWORD, { silent = true })
        map("v", "<Leader>g", fzf.grep_visual, { silent = true })
        map("n", "<Leader>ra", function()
            fzf.lsp_code_actions({ silent = true })
        end, { silent = true })
        map("n", "<Leader>rr", fzf.lsp_references, { silent = true })
        map("n", "<Leader>ri", fzf.lsp_implementations, { silent = true })
        map("n", "<Leader>rt", fzf.lsp_definitions, { silent = true })
    end,
}
