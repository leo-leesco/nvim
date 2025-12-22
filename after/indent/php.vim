" We must unlet b:did_indent, otherwise html.vim will see it and refuse to load.
if exists("b:did_indent")
  let s:did_indent_backup = b:did_indent
  unlet b:did_indent
endif

runtime! indent/html.vim

" Restore the guard variable (optional but good practice)
if exists("s:did_indent_backup")
  let b:did_indent = s:did_indent_backup
endif

" Define a smart wrapper function
function! GetPhpHtmlIndent()
    " A. Check if we are currently inside PHP tags (<?php ... ?>)
    " 'bW' means search backwards, don't wrap.
    if searchpair('<?', '', '?>', 'bW') > 0
        " We are inside PHP: use standard PHP indent
        return GetPhpIndent()
    else
        " B. We are in HTML (outside PHP tags)
        " Check if the HtmlIndent function exists (it should)
        if exists('*HtmlIndent')
            return HtmlIndent()
        endif
    endif
    
    " Fallback
    return -1
endfunction

setlocal indentexpr=GetPhpHtmlIndent()

setlocal indentkeys+=<>>
let g:php_htmlInStrings = 1
