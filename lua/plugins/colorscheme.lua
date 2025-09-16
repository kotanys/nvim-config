vim.cmd([[
colorscheme sorbet
hi Identifier guifg=#ccccdc
hi clear Visual
hi Visual guibg=#264f78
hi NormalFloat guibg=#222230
]])

return {
    -- {
    --     "Mofiqul/vscode.nvim",
    --     lazy = false,
    --     priority = 1000,
    --         config = function()
    --         require('vscode').setup({
    --             transparent = true,
    --             italic_comments = true,
    --             disable_nvimtree_ng = true,
    --             terminal_colors = true,
    --         })
    --         vim.cmd([[colorscheme vscode]])
    --     end,
    -- },
    {}
}
