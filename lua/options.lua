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
	
	showcmd = true,

	-- tab thingies
	tabstop = 4,
	shiftwidth = 4,
	expandtab = true,
	
	ignorecase = true,
	laststatus = 3,

}

vim.g.c_syntax_for_h = true
for n, v in pairs(options) do
	vim.opt[n] = v
end
