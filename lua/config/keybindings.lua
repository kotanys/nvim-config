local map = vim.keymap.set

map({'n'}, '<Leader>dl', function() 
    local virt_lines_enabled = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({
        virtual_text = virt_lines_enabled,
        virtual_lines = not virt_lines_enabled,
    })
end)
