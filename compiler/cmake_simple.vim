if exists('current_compiler')
    finish
endif
let current_compiler = 'cmake_simple'

let s:cpo_save = &cpo
set cpo&vim

if !exists('g:cmake_cxx')
    let g:cmake_cxx = 'c++'
endif
if !exists('g:cmake_cc')
    let g:cmake_cc = 'cc'
endif
if !exists('g:cmake_build_dir')
    let g:cmake_build_dir = 'build'
endif

let s:build = shellescape(g:cmake_build_dir)

let &l:makeprg = 'mkdir -p ' .. s:build .. ' && env'
            \ .. ' CXX=' .. shellescape(g:cmake_cxx)
            \ .. ' CC=' .. shellescape(g:cmake_cc) 
            \ .. ' cmake -B ' .. s:build
            \ .. ' && make -j8 -C ' .. s:build
exe 'CompilerSet makeprg='..escape(&l:makeprg, ' \|"')
CompilerSet errorformat&

let &cpo = s:cpo_save
unlet s:cpo_save s:build
