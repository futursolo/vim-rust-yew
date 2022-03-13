function! YewEnableSyntaxExtension() abort
    if exists("b:yew_syntax_extended")
        return
    endif

    if exists("b:current_syntax")
      unlet b:current_syntax
    endif

    execute 'syntax include @HTMLSyntax syntax/html.vim'
    execute 'syntax include @HTMLSyntax after/syntax/html.vim'

    execute 'syntax region yewRustExpr matchgroup=Expr  start="{" end="}" contained contains=TOP'
    execute 'syntax region yewHtmlMacro matchgroup=Macro start="html!\s*{" end="}" contains=yewRustExpr,@HTMLSyntax'

    execute 'syn match   htmlTagN     contained +<\s*[-a-zA-Z0-9:]\++hs=s+1 contains=rustModPath'
    execute 'syn match   htmlTagN     contained +</\s*[-a-zA-Z0-9:]\++hs=s+2 contains=rustModPath'

    execute 'syn region  htmlRustValue    contained start="={" end="}"   contains=yewRustExpr'
    execute 'syn region  htmlTag                start=+<[^/]+   end=+>+ fold contains=htmlRustValue,htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster,yewRustExpr'

    execute 'syn match htmlArg contained "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*"'

    let b:current_syntax = 'rust'
    let b:yew_syntax_extended = 1
endfunction

autocmd BufEnter *.rs call YewEnableSyntaxExtension()

" vim: set et sw=4 sts=4 ts=8:
