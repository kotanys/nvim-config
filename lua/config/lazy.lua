-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local function expand_tilde(path)
    if path:sub(1, 1) == "~" then
        local home = os.getenv("HOME")
        if home then
            return home .. path:sub(2)
        end
    end
    return path
end

local function do_check_updates(file, timeout_seconds)
    local path = expand_tilde(file)
    local last_mod_attr = io.popen(string.format('stat -c %%Y "%s" 2>/dev/null', path)):read("*a")
    if not last_mod_attr or last_mod_attr == "" then
        os.execute(string.format('touch "%s"', path))
        return true
    end
    local last_mod_seconds = tonumber(last_mod_attr)
    local do_update = os.time() - last_mod_seconds > timeout_seconds
    if do_update then
        os.execute(string.format('touch "%s"', path))
    end
    return do_update
end

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "vscode" } },
    -- automatically check for plugin updates
    checker = { enabled = true, notify = do_check_updates("~/.last_lazy_update_check", 24*60*60) }, -- notify once a day
} )

