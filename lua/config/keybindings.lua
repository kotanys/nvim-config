local VISUAL_BLOCK = '\22'
local map = vim.keymap.set

map({ 'n' }, '<Leader>o', '<cmd>make<CR>')

-- Choose virtual lines OR virtual text (View Lines)
map({ 'n' }, '<Leader>vl', function()
    local virt_lines_enabled = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({
        virtual_text = not not virt_lines_enabled,
        virtual_lines = not virt_lines_enabled,
    })
end)

-- Toggle wrap (View Wrap)
map({ 'n' }, '<Leader>vw', function()
    vim.opt['wrap'] = not vim.api.nvim_get_option_value('wrap', {})
end)

-- Unhighlight highlighted text (View Highlight)
map({ 'n' }, '<Leader>vh', function()
    vim.fn.setreg('/', '')
end)

-- Toggle inlay hints (View Inlay-hints)
map({ 'n', 'v' }, '<Leader>vi', function()
    local enabled = vim.lsp.inlay_hint.is_enabled()
    vim.lsp.inlay_hint.enable(not enabled)
end)

-- Remove command line keybindings
map('', 'q:', '')
map('', 'q/', '')
map('', 'q?', '')

-- TODO integrate code_action with vim-repeat
-- map({ 'n', 'v' }, 'gra', function()
-- vim.lsp.buf.code_action({
-- -- code_action has 'title'
-- filter = function(code_action)
-- return true
-- end,
-- })
-- end)

map({ 'n', 'x' }, 'q<CR>', 'q', { noremap = true })

-- Resizing windows
map('', '<M-h>', '<cmd>vertical resize -4<CR>')
map('', '<M-j>', '<cmd>resize -4<CR>')
map('', '<M-k>', '<cmd>resize +4<CR>')
map('', '<M-l>', '<cmd>vertical resize +4<CR>')

map('n', '<Leader>S', ':update<CR> :source %<CR>', { silent = false })

-- Emacs-like left-right motions for Insert Mode
map('i', '<C-b>', '<cmd>norm h<CR>', { silent = true })
map('i', '<C-f>', '<cmd>norm l<CR>', { silent = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp.rebinds", {}),
    desc = "Register LSP-specific keymaps",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then return end

        map('n', '<Leader>f', vim.lsp.buf.format, { buffer = args.buf })

        -- replace '=' with 'gq' if client supports range formatting
        -- reminder: if client is attached, gq performs lsp formatting
        if client:supports_method('textDocument/rangeFormatting') then
            map({ 'n', 'x', 'o' }, '=', 'gq', { buffer = args.buf, noremap = true })
        end
    end,
})

-- A more vimmy rename
local function rename_callback(tbl)
    local args = tbl.fargs
    vim.lsp.buf.rename(args[1])
end
local function rename_callback_complete(lead)

end

vim.api.nvim_create_user_command("Rename", rename_callback, {
    nargs = 1,
    complete = rename_callback_complete,
})

local extract_comment = function(trim)
    if trim == nil then
        trim = false
    end
    local commentstring = vim.api.nvim_get_option_value('commentstring', {})
    commentstring = string.gsub(commentstring, "%%s.*", "", 1)
    if trim then
        commentstring = string.gsub(commentstring, "%s*$", "", 1)
    end
    return commentstring
end

local is_mode_visual = function()
    local mode = vim.api.nvim_get_mode().mode
    return mode == 'v' or mode == 'V' or mode == VISUAL_BLOCK
end

-- Comment Out
map({ 'n', 'x' }, '<Leader>co', function()
    local was_visual = is_mode_visual()
    local command = [[:norm ^i]] .. extract_comment() .. [[<CR>]]
    if was_visual then
        command = command .. [[gv]]
    end
    return command
end, { expr = true, silent = true })
-- Comment In (meaning: revert 'Comment Out')
map({ 'n', 'x' }, '<Leader>ci', function()
    local was_visual = is_mode_visual()
    local incsearch_was_enabled = vim.api.nvim_get_option_value('incsearch', {})
    vim.opt_local['incsearch'] = false
    local comment = vim.fn.escape(extract_comment(true), [[/\]])
    local subcommand = [[:substitute/^\(\s*\)]] .. comment .. [[\s*/\1/e<CR> :let @/=''<CR>]]
    if incsearch_was_enabled then
        subcommand = subcommand .. [[ :setlocal incsearch<CR>]]
    end
    if was_visual then
        subcommand = subcommand .. [[gv]]
    end
    return subcommand
end, { expr = true, silent = true })
