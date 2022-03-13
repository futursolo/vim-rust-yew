function! YewEnableSyntaxExtension() abort
    if exists("b:yew_syntax_extended")
        return
    endif

    if exists("b:current_syntax")
      unlet b:current_syntax
    endif

    execute 'syntax include @HTMLSyntax syntax/html.vim'
    execute 'syntax include @HTMLSyntax after/syntax/html.vim'

    execute 'syntax match   htmlTagN      contained                      +<\s*[-a-zA-Z0-9:]\++hs=s+1         contains=htmlTagName,rustModPath,htmlSpecialTagName,@htmlTagNameCluster'
    execute 'syntax match   htmlTagN      contained                      +</\s*[-a-zA-Z0-9:]\++hs=s+2        contains=htmlTagName,rustModPath,htmlSpecialTagName,@htmlTagNameCluster'

    execute 'syntax region  htmlRustValue contained matchGroup=Expr      start="={"hs=s+1       end="}"      contains=TOP'

    execute 'syntax region  htmlTag                                      start=+<[^/]+          end=+>+ fold contains=htmlRustValue,htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster'
    execute 'syn region  htmlEndTag                                      start=+</+             end=+>+      contains=htmlTagN,htmlTagError'

    execute 'syntax match   htmlArg       contained                      "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*"'

    execute 'syntax region  yewRustExpr   contained matchgroup=Expr      start="{"               end="}"     contains=TOP'
    execute 'syntax region  yewHtmlMacro            matchgroup=Expr      start="html!\s*{"ms=e-1 end="}"     contains=yewRustExpr,@HTMLSyntax'

    let b:current_syntax = 'rust'
    let b:yew_syntax_extended = 1
endfunction

autocmd BufEnter *.rs call YewEnableSyntaxExtension()

" vim: set et sw=4 sts=4 ts=8:
