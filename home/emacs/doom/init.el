;;; init.el -*- lexical-binding: t; -*-

; See https://github.com/hlissner/doom-emacs/blob/develop/init.example.el.

(doom! :completion
       company
       (ivy +prescient)

       :ui
       doom-dashboard
       hl-todo
       (modeline +light)
       nav-flash
       ophints
       (popup +defaults +all)
       vc-gutter
       vi-tilde-fringe
       workspaces
       zen

       :editor
       (evil +everywhere)
       fold

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

       :tools
       direnv
       lookup
       magit
       pdf

       :lang
       data
       emacs-lisp
       json
       ledger
       markdown
       (org +roam)
       yaml

       :email
       notmuch

       :app
       (rss +org)

       :config
       (default +bindings +smartparens))
