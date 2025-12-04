" Vim filetype plugin for TODO files
" Maintainer: Vadim "Kotanys" Rudometov
" Latest Revision: 12-04-2025

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Set local options
setlocal foldmethod=expr
setlocal foldexpr=GetTodoFoldLevel(v:lnum)
setlocal foldtext=TodoFoldText()
setlocal nofoldenable

" Custom fold text function
function! TodoFoldText()
  let line = getline(v:foldstart)
  let indent = indent(v:foldstart)
  let indent_str = repeat(' ', indent)
  let line_count = v:foldend - v:foldstart + 1
  
  " Clean up the line for display
  let display_line = substitute(line, '^\s*-\s*', '', '')
  let display_line = substitute(display_line, '\s*$', '', '')
  
  let priority_counts = {'Must': 0, 'Should': 0, 'May': 0, 'Wont': 0}
  
  for lnum in range(v:foldstart, v:foldend)
    let line_text = getline(lnum)
    if line_text =~ '\<Must\>'
      let priority_counts.Must += 1
    elseif line_text =~ '\<Should\>'
      let priority_counts.Should += 1
    elseif line_text =~ '\<May\>'
      let priority_counts.May += 1
    elseif line_text =~ '\<Won''t\>\|\<Wont\>'
      let priority_counts.Wont += 1
    endif
    
  endfor
  
  " Build the fold text
  let fold_text = indent_str . '▸ ' . display_line . ' ['
  
  " Add priority summary
  let priority_summary = []
  if priority_counts.Must > 0
    call add(priority_summary, 'Musts:' . priority_counts.Must)
  endif
  if priority_counts.Should > 0
    call add(priority_summary, 'Shoulds:' . priority_counts.Should)
  endif
  if priority_counts.May > 0
    call add(priority_summary, 'Mays:' . priority_counts.May)
  endif
  
  if !empty(priority_summary)
    let fold_text .= join(priority_summary, ', ')
  endif
  
  let fold_text .= ']'
  
  return fold_text
endfunction

" Calculate fold level based on indentation (like YAML)
function! GetTodoFoldLevel(lnum)
  let line = getline(a:lnum)
  let next_line = getline(a:lnum + 1)
  
  " Empty lines get fold level of previous line
  if line =~ '^\s*$'
    return '-1'
  endif
  
  " Calculate indentation level (2 spaces per level)
  let indent = len(matchstr(line, '^\s*'))
  let level = indent / 2
  
  " Check if this line starts a fold (has children)
  if next_line != '' && len(matchstr(next_line, '^\s*')) > indent
    return '>' . (level + 1)
  endif
  
  return level
endfunction

" Set comment string for todo files
setlocal commentstring=#\ %s

let b:undo_ftplugin = "
      \ setlocal foldmethod< foldexpr< foldtext< foldenable<
      \ setlocal commentstring<
      \"

" Set up syntax highlighting if it hasn't been loaded
if !exists('g:syntax_on')
  syntax enable
endif
