;;; init.el -*- lexical-binding: t; -*-

; See https://github.com/doomemacs/doomemacs/blob/master/templates/init.example.el

(doom! :completion
       company
       (vertico +icons)

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
       format
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

       :tools
       direnv
       lookup
       magit

       :lang
       emacs-lisp
       (go +lsp)
       (javascript +lsp)
       ledger
       markdown
       (org +roam2)
       nix

       :app
       (rss +org)

       :config
       (default +bindings +smartparens))
