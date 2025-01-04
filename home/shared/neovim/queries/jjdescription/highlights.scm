(text) @spell
; TODO: add error highlight for commit subject
((text) @comment.error
  (#vim-match? @comment.error ".\{72,}")
  (#offset! @comment.error 0 72 0 0))

(filepath) @string.special.path

(change type: "A" @diff.plus)
(change type: "D" @diff.minus)
(change type: "M" @diff.delta)
(change type: "C" @diff.plus)
(change type: "R" @diff.delta)

(comment) @comment
