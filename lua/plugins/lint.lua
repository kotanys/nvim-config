return {
    "mfussenegger/nvim-lint",
    keys = '<Leader>l',
    config = function()
        local lint = require('lint')
        lint.linters_by_ft = {
            python = { 'mypy' },
            c = { 'cpplint' },
            cpp = { 'cpplint' },
            make = { 'checkmake' },
        }
        local lint_callback = function()
            lint.try_lint()
        end
        vim.keymap.set('n', '<Leader>l', lint_callback)
        -- local group = vim.api.nvim_create_augroup('lint.auto', {})
        -- vim.api.nvim_create_autocmd({'BufWritePost', 'BufReadPost'}, {
        --     group = group,
        --     callback = lint_callback
        -- })
    end
}
