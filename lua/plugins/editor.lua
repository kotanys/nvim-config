return {
    { -- Adds SubstituteCase command and others
        "vim-scripts/keepcase.vim",
    },
    { -- Better TAB (does multiple indents at once, doesn't work well)
        "VidocqH/auto-indent.nvim",
        ft = { "c", "cpp" },
        opts = {},
    },
    { -- Use relative numbers for active buffer outside of insert mode; normal numbers otherwise
        "jeffkreeftmeijer/vim-numbertoggle",
    },
    { -- It's in the name
        "gen740/SmoothCursor.nvim",
        opts = {
            threshold = 1
        }
    },
    { -- Show unstaged git changes in sign column
        "airblade/vim-gitgutter",
    },
    { -- Nerd font icons
        "echasnovski/mini.icons",
        opts = {}
    },
    -- { -- Highlight unique letters when jumping with f/F/t/T
    --     'jinh0/eyeliner.nvim',
    --     opts = {
    --         highlight_on_key = true,
    --         dim = true,
    --     }
    -- },
    { -- Press F2 to add a header guard in C/C++ headers
        "kotanys/header-guard-macro",
    },
    {
        "tpope/vim-repeat"
    },
}
