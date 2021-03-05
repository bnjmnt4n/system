;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Themes
(package! modus-operandi-theme)
(package! modus-vivendi-theme)

;; Extensions
(package! anki-editor)
(package! mathpix.el
  :recipe (:host github :repo "jethrokuan/mathpix.el"))
(package! magit-delta)
(package! org-gcal)
(package! org-download)
(package! spotify-client
  :recipe (:host github :repo "bnjmnt4n/spotify.el"))
(package! transmission)
