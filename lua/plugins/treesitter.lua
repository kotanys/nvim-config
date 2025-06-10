return { 
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "c",
                    "go",
                    "html",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "vim",
                    "vimdoc"
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-refactor",
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        },
        config = function()
            require('nvim-treesitter.configs').setup({
                refactor = {
                    highlight_definitions = {
                        enable = false,
                        -- Set to false if you have an `updatetime` of ~100.
                        clear_on_cursor_move = false,
                    }, 
                },
            })
        end
    }
}
