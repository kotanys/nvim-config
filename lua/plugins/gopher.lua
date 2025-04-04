return {
    "olexsmir/gopher.nvim",
    ft = "go",
    -- branch = "develop"
    -- (optional) will update plugin's deps on every update
    build = function()
        require('gopher').install_deps()
    end,
    ---@type gopher.Config
    opts = {},
}
