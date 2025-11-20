-- stop complaints about undefined fields from lua_ls
---@type any
vim.uv = vim.uv

---@param lsp string
---@param config vim.lsp.Config?
local function lsp_enable(lsp, config)
    if config ~= nil then
        vim.lsp.config(lsp, config)
    end
    -- TODO ask user for permission to download from Mason?
    vim.lsp.enable(lsp)
end

---@param str string
---@param find string
---@param replace string
---@return string
local function replace_last_occurrence(str, find, replace)
    local pattern = "(.*)" .. find .. "(.*)"
    local before, after = str:match(pattern)
    if before and after then
        return before .. replace .. after
    end
    return str
end

---@param filename string
---@param search string
---@param replace string
---@param bufnr integer?
local function buf_substitute(filename, search, replace, bufnr)
    local buffer_was_created_here = bufnr == nil
    local was_modified_before = false
    if not bufnr then
        bufnr = vim.api.nvim_create_buf(false, false) -- listed=false, scratch=false
        vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = bufnr })
        vim.api.nvim_buf_set_name(bufnr, filename)
        vim.api.nvim_buf_call(bufnr, vim.cmd.edit)
    else
        was_modified_before = vim.api.nvim_get_option_value('modified', { buf = bufnr })
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local modified_lines = {}
    for _, line in ipairs(lines) do
        local modified_line = line:gsub(search, replace)
        table.insert(modified_lines, modified_line)
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, modified_lines)
    if not was_modified_before then
        vim.api.nvim_buf_call(bufnr, vim.cmd.update)
    end
    if buffer_was_created_here then
        vim.api.nvim_buf_delete(bufnr, { force = true })
    end
end

---@param old_buf_path string
---@param new_buf_path string
---@param client vim.lsp.Client
local function fix_cmake_lists(old_buf_path, new_buf_path, client)
    local dir_sep = '/' -- WINDOWS NOT SUPPORTED lol
    local dir = vim.fn.fnamemodify(old_buf_path, ":h")
    local cmake_path = nil
    while old_buf_path ~= client.root_dir do
        local test_path = vim.fn.simplify(dir .. dir_sep .. "CMakeLists.txt")
        local exists = vim.uv.fs_stat(test_path, nil) ~= nil
        if exists then
            cmake_path = test_path
            break
        end
        dir = vim.fn.fnamemodify(dir, ":h")
    end
    if cmake_path == nil then return end
    local cmake_bufnr = nil
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(bufnr)
        if buf_name == cmake_path then
            cmake_bufnr = bufnr
        end
    end

    local old_name = vim.fn.fnamemodify(old_buf_path, ":t")
    local new_name = vim.fn.fnamemodify(new_buf_path, ":t")
    buf_substitute(cmake_path, old_name, new_name, cmake_bufnr)
end

---@param old_buf_name string
---@param new_buf_name string
---@param client vim.lsp.Client
local function rename_async(old_buf_name, new_buf_name, client)
    vim.uv.fs_rename(old_buf_name, new_buf_name, function(fs_err, success)
        if not success then
            error(fs_err)
        end
        vim.schedule(function()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                local buf_name = vim.api.nvim_buf_get_name(bufnr)
                if buf_name == old_buf_name then
                    vim.api.nvim_buf_set_name(bufnr, new_buf_name)
                end
            end
            fix_cmake_lists(old_buf_name, new_buf_name, client)
        end)
    end
    )
end

---@param bufnr integer
---@param client vim.lsp.Client
local function rename_source_header(client, bufnr)
    local method_name = 'textDocument/switchSourceHeader'
    if not client or not client:supports_method(method_name) then
        return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
    end
    local params = vim.lsp.util.make_text_document_params(bufnr)
    client:request(method_name, params, function(err, result)
        if err then
            error(tostring(err))
        end
        if not result then
            vim.notify('corresponding file cannot be determined')
            return
        end
        local old_other = vim.uri_to_fname(result)
        local old_path = vim.uri_to_fname(params.uri)
        local old_name = vim.fn.fnamemodify(old_path, ":t:r")
        local new_name = vim.fn.input("New Name: ", old_name)
        if new_name == "" then return end

        local new_path = replace_last_occurrence(old_path, old_name, new_name)
        local new_other = replace_last_occurrence(old_other, old_name, new_name)
        local msg = "Rename:\n"
            .. old_path .. " -> " .. new_path .. "\n"
            .. old_other .. " -> " .. new_other .. "\n"

        if vim.fn.confirm(msg, "&Yes\n&No") == 1 then
            rename_async(old_path, new_path, client)
            rename_async(old_other, new_other, client)
        end
    end, bufnr)
end


local function setup_gopls()
    lsp_enable('gopls', {
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

    -- I don't like automatic formatting, but it seems to be the norm
    -- for golang development (this makes Go source files always
    -- comply with the gofmt style)
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("lsp.golang.formatting", { clear = true }),
        desc = 'Automatic Golang formatting',
        pattern = "*.go",
        callback = function()
            local params = vim.lsp.util.make_range_params(0, "utf-8")
            ---@diagnostic disable-next-line: inject-field
            params.context = { only = { "source.organizeImports" } }
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
            vim.lsp.buf.format({ async = false })
        end
    })
end

function SetupLsps()
    if vim.g.nolsp then
        return
    end
    setup_gopls()

    lsp_enable("pyright")

    lsp_enable("bashls", {
        settings = {
            bashIde = {
                -- Ignore:
                --  1090,1091: 'can't follow file' warnings
                --  2155: 'return code masking' warnings
                shellcheckArguments = "--exclude=1090,1091,2155"
            }
        }
    })
    lsp_enable("powershell_es", {
        -- TODO fix this to be not hardcoded
        bundle_path = '/home/kotanys/.local/share/nvim/mason/packages/powershell-editor-services/',
        init_options = {
            enableProfileLoading = false,
        },
    })
    lsp_enable('lua_ls', {
        on_init = function(client)
            if client.workspace_folders then
                -- If not inside Neovim config directory,
                -- DON'T load it's libraries
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath('config')
                    and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    return
                end
            end

            -- Else, DO load Neovim's libraries

            ---@diagnostic disable-next-line: param-type-mismatch
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
                        'lua/plugins/?.lua'
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
        root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git", "init.lua", },
    })

    lsp_enable("dockerls")

    lsp_enable("roslyn", {
        settings = {
            ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
            },
            ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
            },
        },
    })

    local old_on_attach_clangd = vim.lsp.config.clangd.on_attach
    lsp_enable("clangd", {
        ---@param client vim.lsp.Client
        ---@param bufnr integer
        on_attach = function(client, bufnr)
            if old_on_attach_clangd ~= nil then
                old_on_attach_clangd(client, bufnr)
            end
            vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdRenameSourceHeader', function()
                rename_source_header(client, bufnr)
            end, { desc = 'Rename both source and header' })
        end,
        cmd = { "clangd", "--clang-tidy", "--pch-storage=memory", "--fallback-style=Google" },
    })
end

return {
    {
        "neovim/nvim-lspconfig",
        config = SetupLsps,
    },
    {
        "seblyng/roslyn.nvim",
        ft = 'cs'
    },
    {
        "williamboman/mason.nvim",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
        },
    },
    -- {
    --     "mason-org/mason-lspconfig.nvim",
    --     dependencies = {
    --         "williamboman/mason.nvim"
    --     },
    --     opts = {
    --         ensure_installed = {
    --             "pyright",
    --             "lua_ls",
    --             "bashls",
    --             "gopls",
    --             "dockerls",
    --         },
    --         automatic_enable = false,
    --     },
    -- }
}
