if exists('current_compiler')
    finish
endif
let current_compiler = 'cmake_simple'

CompilerSet errorformat&
CompilerSet makeprg=mkdir\ -p\ build\ &&\ cmake\ -B\ build\ &&\ make\ -j8\ -C\ build
