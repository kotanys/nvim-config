local util = require('lspconfig.util')

local function setup_gopls()
    require('lspconfig').gopls.setup({
        on_attach = on_attach,
        cmd = { 'gopls', },
        filetypes = { 'go', 'gomod' },
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
    vim.api.nvim_create_autocmd("BufWritePre", {
        desc = 'Automatic Golang formatting',
        pattern = "*.go",
        callback = function()
            local params = vim.lsp.util.make_range_params(0, "utf-8")
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

function SetupLsps()
    if vim.g.nolsp then
        return
    end
    setup_gopls()

    vim.lsp.enable("pyright")

    vim.lsp.config("bashls", {
        settings = {
            bashIde = {
                -- Ignore:
                --  1090,1091: 'can't follow file' warnings
                --  2155: return code masking warnings
                shellcheckArguments = "--exclude=1090,1091,2155"
            }
        }
    })
    vim.lsp.enable("bashls")
    vim.lsp.config("powershell_es", {
        bundle_path = '/home/kotanys/.local/share/nvim/mason/packages/powershell-editor-services/',
        init_options = {
            enableProfileLoading = false,
        },
    })
    vim.lsp.enable("powershell_es")
    vim.lsp.config('lua_ls', {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath('config')
                    and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most
                    -- likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Tell the language server how to find Lua modules same way as Neovim
                    -- (see `:h lua-module-load`)
                    path = {
                        'lua/?.lua',
                        'lua/?/init.lua',
                    },
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        -- Depending on the usage, you might want to add additional paths
                        -- here.
                        -- '${3rd}/luv/library'
                        -- '${3rd}/busted/library'
                    }
                    -- Or pull in all of 'runtimepath'.
                    -- NOTE: this is a lot slower and will cause issues when working on
                    -- your own configuration.
                    -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                    -- library = {
                    --   vim.api.nvim_get_runtime_file('', true),
                    -- }
                }
            })
        end,
        settings = {
            Lua = {}
        },
        root_pattern = util.root_pattern('init.lua', '.git')
    })
    vim.lsp.enable("lua_ls")

    vim.lsp.enable("dockerls")
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim"
        },
        config = SetupLsps,
    },
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim"
        },
        opts = {
            ensure_installed = {
                "pyright",
                "lua_ls",
                "bashls",
                "gopls",
                "dockerls",
            },
            automatic_enable = false,
        },
    }
}
