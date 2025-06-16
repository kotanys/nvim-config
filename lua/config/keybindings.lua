local map = vim.keymap.set

-- Choose virtual lines OR virtual text
map({'n'}, '<Leader>dl', function() 
    local virt_lines_enabled = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({
        virtual_text = virt_lines_enabled,
        virtual_lines = not virt_lines_enabled,
    })
end)

-- Toggle wrap
map({'n'}, '<Leader>dw', function() 
    vim.opt['wrap'] = not vim.opt['wrap']._value
end)

-- Remove command line keybindings
map('', 'q:', '')
map('', 'q/', '')
map('', 'q?', '')
