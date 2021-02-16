;;; lang/zig/config.el -*- lexical-binding: t; -*-

(after! projectile
  (pushnew! projectile-project-root-files "build.zig"))


;;
;; zig-mode

(use-package! zig-mode
  :mode "\\.zig$"
  :init
  :config
  (setq zig-format-on-save nil)

  (when (featurep! +lsp)
    (add-hook 'zig-mode-local-vars-hook #'lsp!)
    (after! lsp-mode
      (add-to-list 'lsp-language-id-configuration '(zig-mode . "zig"))
      (lsp-register-client
        (make-lsp-client
          :new-connection (lsp-stdio-connection "~/repos/zls/zig-cache/bin/zls")
          :major-modes '(zig-mode)
          :server-id 'zls)))))

(map! :localleader
      (:after zig-mode
        :map zig-mode-map
        "b" #'zig-compile
        "f" #'zig-format-buffer
        "r" #'zig-run
        "t" #'zig-test-buffer))

(when (featurep! :checkers syntax)
  (flycheck-define-checker zig
    "A zig syntax checker using the zig-fmt interpreter."
    :command ("zig" "fmt" (eval (buffer-file-name)))
    :error-patterns
    ((error line-start (file-name) ":" line ":" column ": error: " (message) line-end))
    :modes zig-mode)
  (add-to-list 'flycheck-checkers 'zig))
