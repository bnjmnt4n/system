;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Themes
(package! modus-themes)

;; Extensions
(package! anki-editor)
(package! mathpix.el
  :recipe (:host github :repo "jethrokuan/mathpix.el"))
(package! magit-delta)
(package! org-gcal)
(package! org-download)
(package! smudge
  :recipe (:host github :repo "danielfm/smudge"))
(package! transmission)

;; TODO: temporarily pin lsp-mode to a newer version.
(package! lsp-mode :pin "7a37843b7986243579d86029caedd90f99d95684")
