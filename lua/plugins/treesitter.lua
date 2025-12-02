return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cpp",
                    "go",
                    "latex",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "query",
                    "regex",
                    "vim",
                    "vimdoc",
                },
                highlight = { enable = true },
                indent = { enable = true },
                folds = {
                    enable = true
                },
            })
        end,
    },
}

--[[ Notes
-- Dockerfile tree-sitter looks better then simple regex,
-- but still isn't consistent enough. Regex is fine.
-- Dockerfile highlighting is better handled via dockerfile lsp.
]] --
