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
if !exists('g:cmake_build_type')
    let g:cmake_build_type = 'Debug'
endif
if !exists('g:cmake_jobs')
    let g:cmake_jobs = 8
endif

let s:build = shellescape(g:cmake_build_dir)

let &l:makeprg = 'mkdir -p ' .. s:build .. ' && env'
            \ .. ' CXX=' .. shellescape(g:cmake_cxx)
            \ .. ' CC=' .. shellescape(g:cmake_cc) 
            \ .. ' cmake -B ' .. s:build 
            \ .. ' -DCMAKE_BUILD_TYPE=' .. shellescape(g:cmake_build_type)
            \ .. ' && make -j'.. string(g:cmake_jobs) .. ' -C ' .. s:build
exe 'CompilerSet makeprg='..escape(&l:makeprg, ' \|"')
CompilerSet errorformat&

let &cpo = s:cpo_save
unlet s:cpo_save s:build
