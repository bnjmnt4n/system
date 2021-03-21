;;; init.el -*- lexical-binding: t; -*-

; See https://github.com/hlissner/doom-emacs/blob/develop/init.example.el.

(doom! :completion
       company
       (ivy +prescient)

       :ui
       doom-dashboard
       hl-todo
       ;;hydra
       (modeline +light)
       nav-flash
       ophints
       (popup +defaults +all)
       treemacs
       ;;unicode
       vc-gutter
       vi-tilde-fringe
       ;;window-select
       workspaces
       zen

       :editor
       (evil +everywhere)
       file-templates
       fold
       format ; (format +onsave)
       snippets

       :emacs
       dired
       electric
       ibuffer
       undo
       vc

       :term
       vterm

       :checkers
       syntax
       spell
       ;;grammar

       :tools
       (debugger +lsp)
       direnv
       ;;docker
       editorconfig
       (eval +overlay)
       lookup
       (lsp +peek)
       magit
       pdf

       :lang
       (cc +lsp)
       data
       (elixir +lsp)
       emacs-lisp
       ;;(haskell +dante)
       json
       (java +lsp)
       ;; TODO: https://github.com/hlissner/doom-emacs/pull/3258#issuecomment-801278842
       web
       (javascript +lsp)
       ;;latex
       ledger
       markdown
       nix
       (org +roam)
       ;;python
       ;;(ruby +rails +lsp)
       (rust +lsp)
       sh
       yaml
       (zig +lsp)

       :email
       notmuch

       :app
       (rss +org)

       :config
       (default +bindings +smartparens))
