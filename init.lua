vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('config')

if vim.env.TERM ~= 'linux' then
    vim.cmd([[colorscheme mysorbet]])
else
    -- in tty mysorbet doesn't look fine
    vim.cmd([[colorscheme vim]])
end

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.undofile = true -- persistent undo
vim.opt.showcmd = true  -- show command in last line
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.ignorecase = true -- ignores case...
vim.opt.smartcase = true  -- ...unless there is an UPPERCASE letter
vim.opt.laststatus = 3
vim.opt.updatetime = 100
vim.opt.pumheight = 12      -- i.e. popup menu height
vim.opt.wrap = false
vim.opt.smoothscroll = true -- scroll inside of line if it's wrapped
vim.opt.scrolloff = 3       -- make that many lines always above and below the cursor
vim.opt.winborder = "rounded"
vim.opt.colorcolumn = "100"
vim.opt.virtualedit = "block"
vim.opt.exrc = true

-- Russian mapping
vim.opt.langmap = [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖЭХЪБЮЁ;]] ..
                  [[ABCDEFGHIJKLMNOPQRSTUVWXYZ:\"{}<>~,]] ..
                  [[фисвуапршолдьтщзйкыегмцчняжэхъбюё;]] ..
                  [[abcdefghijklmnopqrstuvwxyz\;\'[]\,.`]]

-- vim.g.c_syntax_for_h = true

vim.api.nvim_create_autocmd("VimResume", {
    group = vim.api.nvim_create_augroup("ResumeRedraw", { clear = true }),
    desc = "Redraw screen on resume",
    callback = function() vim.cmd([[mode]]) end,
})

vim.diagnostic.config({
    -- virtual_lines = {current_line = true},
    virtual_text = true
})

if vim.env.WSL_DISTRO_NAME then
    -- Running in WSL
    vim.cmd([[let g:clipboard = {
            \   'name': 'WslClipboard',
            \   'copy': {
            \      '+': 'clip.exe',
            \      '*': 'clip.exe',
            \    },
            \   'paste': {
            \      '+': 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \      '*': 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \   },
            \   'cache_enabled': 0,
            \ }]])
end

vim.opt.clipboard:append("unnamedplus")

vim.opt.guifont = "CaskaydiaCove NF"
