return {
    "mfussenegger/nvim-lint",
    -- dependencies = {
    --     "rshkarin/mason-nvim-lint",
    -- },
    config = function() 
        lint = require('lint')
        lint.linters_by_ft = {
            python = {'mypy'},
            c = {'cpplint'},
        }
        lint_callback = function() 
            lint.try_lint() 
        end 
        -- local group = vim.api.nvim_create_augroup('lint.auto', {})
        -- vim.api.nvim_create_autocmd({'BufWritePost', 'BufReadPost'}, {
        --     group = group,
        --     callback = lint_callback
        -- })
    end
}
