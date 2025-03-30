return {
    "ibhagwan/fzf-lua",
    lazy = false,
    -- optional for icon support
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    dependencies = { "echasnovski/mini.icons" },
    opts = {
        files = {
            file_ignore_patterns = { "%.cache/", -- clangd cache
                                     "%.o$" }, -- object files
        }
    }
}
