source $VIMRUNTIME/colors/sorbet.vim 
let g:colors_name = 'mysorbet'
hi Identifier guifg=#ddddef
hi clear Visual
hi Visual guibg=#264f78
hi NormalFloat guibg=#222230

hi link @lsp.type.namespace Identifier
hi @lsp.type.namespace guifg=#aaaabb
"hi link @keyword Special
"hi link @keyword.type Special
