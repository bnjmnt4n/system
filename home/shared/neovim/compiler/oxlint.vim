if exists("current_compiler")
  finish
endif
let current_compiler = "oxlint"

let s:save_cpo = &cpo
set cpo&vim

CompilerSet makeprg=oxlint\ -f\ unix
CompilerSet errorformat=
        \%f:%l:%c:\ %m\ [%trror/%.%#],
        \%f:%l:%c:\ %m\ [%tarning/%.%#],
        \%A%f:%l:%c:\ %m,
        \%Z%m\ [%trror/%.%#],
        \%Z%m\ [%tarning/%.%#],
        \%-G,
        \%-G%\\d%\\+\ problem%.%#,
        \%C%m

let &cpo = s:save_cpo
unlet s:save_cpo
