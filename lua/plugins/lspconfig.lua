local function config(_config)
    return vim.tbl_deep_extend('force', {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }, _config or {})
end

local function setup_gopls()
    util = require('lspconfig.util')
    vim.lsp.config('gopls', {
        on_attach = on_attach,
        cmd = { 'gopls', },
        filetypes = { 'go', 'go.mod' },
        root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                staticcheck = true,
            }
        }
    })
    vim.lsp.enable('gopls')
    vim.api.nvim_create_autocmd("BufWritePre", {
        desc = 'Automatic Golang formatting',
        pattern = "*.go",
        callback = function()
            local params = vim.lsp.util.make_range_params()
            params.context = {only = {"source.organizeImports"}}
            -- buf_request_sync defaults to a 1000ms timeout. Depending on your
            -- machine and codebase, you may want longer. Add an additional
            -- argument after params if you find that you have to write the file
            -- twice for changes to be saved.
            -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
            for cid, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                    if r.edit then
                        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                        vim.lsp.util.apply_workspace_edit(r.edit, enc)
                    end
                end
            end
            vim.lsp.buf.format({async = false})
        end
    })
end

function setup_lsps()
    setup_gopls()
    vim.lsp.enable("basedpyright")
end

vim.g.nolsp = vim.g.nolsp or 0
print(vim.g.nolsp)
if vim.g.nolsp ~= 1 then
    return {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim"
        },
        config = setup_lsps,
    }
else
    return {}
end
