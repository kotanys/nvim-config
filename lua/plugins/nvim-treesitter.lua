return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = { "c", "html", "latex", "gitignore", "markdown", "markdown_inline", "lua", "python", "go" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
