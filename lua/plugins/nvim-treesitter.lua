return { 
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { "c", "html", "markdown", "markdown_inline", "lua", "python", "go", "vimdoc" },
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
                        enable = true,
                        -- Set to false if you have an `updatetime` of ~100.
                        clear_on_cursor_move = false,
                    }, 
                },
            })
        end
    }
}
