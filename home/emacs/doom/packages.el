;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Themes
(package! modus-themes :pin "91ef46502c277f325ddd757806667dfa741a64cc")

;; Extensions
(package! anki-editor :pin "546774a453ef4617b1bcb0d1626e415c67cc88df")
(package! mathpix.el
  :recipe (:host github :repo "jethrokuan/mathpix.el") :pin "1ce2d4aa7708271cf60ec929688c1ce420c3fc86")
(package! magit-delta :pin "5fc7dbddcfacfe46d3fd876172ad02a9ab6ac616")
(package! org-gcal :pin "6e26ae75aea521ea5dae67e34265da534bdad2d1")
(package! org-download :pin "947ca223643d28e189480e607df68449c15786cb")

(package! org-roam
  :recipe (:host github :repo "org-roam/org-roam"
           :files (:defaults "extensions/*")))
