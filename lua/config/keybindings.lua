local map = vim.keymap.set

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

-- Toggle highlight (View Highlight)
map({ 'n' }, '<Leader>vh', function()
    vim.opt['hlsearch'] = not vim.api.nvim_get_option_value('hlsearch', {})
end)

-- Remove command line keybindings
map('', 'q:', '')
map('', 'q/', '')
map('', 'q?', '')

map('n', '<Leader>S', '<cmd>source %<CR>')
map('n', '<Leader>f', vim.lsp.buf.format)

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
    return mode == 'v' or mode == 'V' -- TODO add block mode
end

-- Comment In
map({ 'n', 'x' }, '<Leader>ci', function()
    local was_visual = is_mode_visual()
    local command = [[:norm ^i]] .. extract_comment() .. [[<CR>]]
    if was_visual then
        command = command .. [[gv]]
    end
    return command
end, { expr = true, silent = true })
-- Comment Out
map({ 'n', 'x' }, '<Leader>co', function()
    local was_visual = is_mode_visual()
    local incsearch_was_enabled = vim.api.nvim_get_option_value('incsearch', {})
    vim.opt_local['incsearch'] = false
    local subcommand = [[:substitute/^\(\W*\)]] .. extract_comment(true) .. [[\W*/\1/e<CR> :let @/=''<CR>]]
    if incsearch_was_enabled then
        subcommand = subcommand .. [[ :setlocal incsearch<CR>]]
    end
    if was_visual then
        subcommand = subcommand .. [[gv]]
    end
    return subcommand
end, { expr = true, silent = true })
