local options = {
    -- line numbers
    number = true,
    relativenumber = true,
    signcolumn = 'yes',

    -- split settings
    splitbelow = true,
    splitright = true,

    -- persistent undo
    undofile = true,

    -- show command in last line
    showcmd = true,

    -- tab thingies
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smartindent = true,

    ignorecase = true, -- ignores case...
    smartcase = true, -- ...unless there is an UPPERCASE letter
    laststatus = 3,

    wrap = false,
    updatetime = 100,
    
    -- Russian mapping
    langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖЭХЪБЮЁ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:\"{}<>~,' ..
              'фисвуапршолдьтщзйкыегмцчняжэхъбюё;abcdefghijklmnopqrstuvwxyz;\'[]\\,`.',
}

vim.api.nvim_create_autocmd("VimResume", {
    desc = "Redraw screen on resume",
    callback = function() vim.cmd([[mode]]) end,
})

vim.g.c_syntax_for_h = true
for n, v in pairs(options) do
    vim.opt[n] = v
end

vim.diagnostic.config({
--    virtual_lines = {current_line = true},
    virtual_text = true
})
