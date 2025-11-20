return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'latex-lsp/tree-sitter-latex',
        'echasnovski/mini.icons',
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        latex = {
            enabled = true,
        },
        heading = {
            position = 'inline',
        },
        bullet = {
            icons = { '•', '◦', '‣', '⁃', '·' },
        },
        code = {
            border = 'thin',
        },
    },
    config = function(_, opts)
        require('render-markdown').setup(opts)
        -- local headingHl = vim.api.nvim_get_hl(0, { name = 'RenderMarkdownH1' })
        -- local headingHlBg = vim.api.nvim_get_hl(0, { name = 'RenderMarkdownH1Bg' })
        -- local headingTextHl = vim.api.nvim_get_hl(0, { name = '@markup.heading.1.markdown' })
        --
        -- headingHlBg.bg = '#211d30'
        --
        -- for i = 1, 6 do
        -- vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. tostring(i), headingHl)
        -- vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. tostring(i) .. 'Bg', headingHlBg)
        -- vim.api.nvim_set_hl(0, '@markup.heading.' .. tostring(i) .. '.markdown', headingTextHl)
        -- end
        --
        -- local codeHl = vim.api.nvim_get_hl(0, { name = 'ColorColumn' })
        -- codeHl.bg = '#211d30'
        -- vim.api.nvim_set_hl(0, 'ColorColumn', codeHl)
        --
        -- local inlineCodeHl = vim.api.nvim_get_hl(0, { name = '@markup.raw.markdown_inline' })
        -- inlineCodeHl.fg = '#cdabd3'
        -- vim.api.nvim_set_hl(0, '@markup.raw.markdown_inline', inlineCodeHl)
        --
        -- local quoteTextHl = vim.api.nvim_get_hl(0, { name = '@markup.quote.markdown' })
        -- quoteTextHl.fg = '#cdabd3'
        -- vim.api.nvim_set_hl(0, '@markup.quote.markdown', quoteTextHl)
        --
        -- local quoteBorderHl = vim.api.nvim_get_hl(0, { name = '@markup.quote' })
        -- quoteBorderHl.fg = '#cdabd3'
        -- vim.api.nvim_set_hl(0, '@markup.quote', quoteBorderHl)
    end,
}
