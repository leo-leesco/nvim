" In Vim, <BS> (`\`) is used to escape special characters (which toggles their
" |magic| meaning)
"
" The goal of this file is to conceal the escape character and highlight the
" escaped character (much like what is achieved with |K|lickable keywords in Vim |help| pages) so as to make vimscript more readable

" creates a new syntax group `VimHideEscape`, which matches <BS> (`/\\/`), in the
" context of comments and strings
"
" this syntax group is concealed
"
" nextgroup and contained work together to ensure that VimHideEscape is followed
" by VimEscapedChar, and VimEscapedChar is triggered only when called as a
" nextgroup from another syntax group
syntax match VimHideEscape /\\/ conceal containedin=vimLineComment,vimString nextgroup=VimEscapedChar
syntax match VimEscapedChar /./ contained

" disables concealing per line
" simply add a comment 'noconceal' somewhere on the line
syntax match VimNoConceal /^.*noconceal.*$/ transparent contains=VimRevealEscape containedin=vimComment
syntax match VimRevealEscape /\\/ contained containedin=vimLineComment,vimString "reverts the concealing mechanism if disabled on the given line

highlight link VimEscapedChar Keyword " Special " @markup.link is also another option in order to replicate the exact appearance of Vim |help| pages

set conceallevel=2
set concealcursor=nc
