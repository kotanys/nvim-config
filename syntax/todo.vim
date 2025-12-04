" Vim syntax file for TODO files
" Language: TODO
" Maintainer: Vadim "Kotanys" Rudometov
" Latest Revision: 12-04-2025

if exists("b:current_syntax")
  finish
endif

" Case-sensitive matching
syntax case match

syntax match todoComment "^\s*#.*$"
highlight link todoComment Comment

" Keywords with specific highlighting
" Must - bold
syntax keyword todoMust Must
highlight link todoMust TodoBold

" Should
syntax keyword todoShould Should
highlight link todoShould TodoShould

" May - dimmed
syntax keyword todoMay May
highlight link todoMay TodoMay

" Won't and Wont - grayed out
syntax keyword todoWont Won't Wont
highlight link todoWont TodoWont

" Indentation-based folding markers
syntax region todoFold start="^\s*-\s" end="^\s*-\s" fold transparent

" Define highlight groups
highlight TodoBold term=bold cterm=bold gui=bold
highlight TodoShould term=italic cterm=italic gui=italic
highlight TodoMay term=standout ctermfg=8 guifg=#808080
highlight TodoWont term=standout ctermfg=7 guifg=#AAAAAA

let b:current_syntax = "todo"
