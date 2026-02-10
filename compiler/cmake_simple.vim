" Vim compiler file
" Compiler:	CMake + make
" Maintainer:	Vadim Rudometov <rudometov.vadim123@gmail.com>
" Last Change:	2026 Feb 09

" Options:
" g:cmake_cxx         : C++ compiler to use
" g:cmake_cc          : C compiler to use
" g:cmake_build_dir   : Output directory
" g:cmake_build_type  : CMake build type
" g:cmake_jobs        : The number of jobs to run make with (-j option)

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

let s:makeprg = 'mkdir -p ' .. s:build .. ' && env'
            \ .. ' CXX=' .. shellescape(g:cmake_cxx)
            \ .. ' CC=' .. shellescape(g:cmake_cc) 
            \ .. ' cmake -B ' .. s:build 
            \ .. ' -DCMAKE_BUILD_TYPE=' .. shellescape(g:cmake_build_type)
            \ .. ' && make -j' .. string(g:cmake_jobs) .. ' -C ' .. s:build
exe 'CompilerSet makeprg=' .. escape(s:makeprg, ' \|"')
CompilerSet errorformat&

let &cpo = s:cpo_save
unlet s:cpo_save s:build s:makeprg
