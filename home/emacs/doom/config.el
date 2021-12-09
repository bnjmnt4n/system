;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; See https://github.com/hlissner/doom-emacs/issues/5785.
(general-auto-unbind-keys :off)
(remove-hook 'doom-after-init-modules-hook #'general-auto-unbind-keys)

(setq user-full-name "Benjamin Tan"
      user-mail-address "benjamin@dev.ofcr.se")

;; Basic display configuration.
(setq bnjmnt4n/is-wsl (file-exists-p "/run/WSL")
      bnjmnt4n/monospace-font "Iosevka"
      bnjmnt4n/monospace-font-size (if bnjmnt4n/is-wsl 26 18)
      bnjmnt4n/serif-font (if bnjmnt4n/is-wsl "DejaVu Serif" "Libre Baskerville"))

(setq doom-font (font-spec :family bnjmnt4n/monospace-font :size bnjmnt4n/monospace-font-size)
      doom-variable-pitch-font (font-spec :family bnjmnt4n/serif-font :height 1.0)
      doom-serif-font (font-spec :family bnjmnt4n/serif-font :height 1.0))

(setq doom-theme 'modus-operandi)

;; Display visual line numbers.
(setq display-line-numbers-type 'visual)
;; Ensure that line numbers are displayed in any coding buffer.
(setq-hook! 'prog-mode-hook display-line-numbers-type 'visual)

;; Loosen the split width threshold since my laptop screen width is smaller.
(setq split-width-threshold 140)

;; Customize Doom dashboard.
(defun bnjmnt4n/custom-banner ()
  (let* ((banner '(""))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat line (make-string (max 0 (- longest-line (length line))) 32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(setq +doom-dashboard-ascii-banner-fn #'bnjmnt4n/custom-banner)

;; Remove documentation and private configuration menu items.
(assoc-delete-all "Open documentation" +doom-dashboard-menu-sections)
(assoc-delete-all "Open private configuration" +doom-dashboard-menu-sections)

;; Shift open project to first item.
(let ((item (alist-get "Open project" +doom-dashboard-menu-sections nil nil 'equal)))
  (push "Open project" item)
  (assoc-delete-all "Open project" +doom-dashboard-menu-sections)
  (add-to-list '+doom-dashboard-menu-sections item))
(plist-put (alist-get "Open project" +doom-dashboard-menu-sections nil nil 'equal)
           :face '(:inherit (doom-dashboard-menu-title bold)))
(plist-put (alist-get "Reload last session" +doom-dashboard-menu-sections nil nil 'equal)
           :face '(:inherit doom-dashboard-menu-title))

;; Remove Doom Emacs icon.
(remove-hook! '+doom-dashboard-functions #'(doom-dashboard-widget-footer doom-dashboard-widget-loaded))

;; org-mode configuration.
(setq org-directory "~/org/"
      org-agenda-dir (concat org-directory "agenda/")
      org-agenda-files (directory-files-recursively org-agenda-dir "\\.org$")
      org-roam-directory (concat org-directory "kb/")
      +org-roam-open-buffer-on-find-file nil)

(after! org
  (setq org-capture-templates
        `(("i" "inbox" entry (file ,(concat org-agenda-dir "inbox.org"))
               "* TODO %?")
          ("e" "event" entry (file ,(concat org-agenda-dir "events.org"))
               "* %?\n%T"
               :time-prompt t)
          ("c" "org-protocol-capture" entry (file ,(concat org-agenda-dir "inbox.org"))
               "* TODO [[%:link][%:description]]\n\n %i"
               :immediate-finish t)))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
          (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))

;; Convert screenshots to LaTeX formulas.
(use-package! mathpix.el
  :commands (mathpix-screenshot)
  :init
  (map! "C-x m" #'mathpix-screenshot)
  ;; TODO: look into `:config`?
  (if (file-exists-p "/run/secrets/mathpix-app-id")
    (setq mathpix-screenshot-method "grimshot save area %s"
          mathpix-app-id (with-temp-buffer (insert-file-contents "/run/secrets/mathpix-app-id") (buffer-string))
          mathpix-app-key (with-temp-buffer (insert-file-contents "/run/secrets/mathpix-app-key") (buffer-string)))))

;; Sync with Google Calendar.
(use-package! org-gcal
  :commands (org-gcal-sync)
  :init
  (map! "C-x c" #'org-gcal-sync)
  :config
  (setq org-gcal-client-id (with-temp-buffer (insert-file-contents "/run/secrets/org-gcal-client-id") (buffer-string))
        org-gcal-client-secret (with-temp-buffer (insert-file-contents "/run/secrets/org-gcal-client-secret") (buffer-string))
        org-gcal-fetch-file-alist `(("demoneaux@gmail.com" .  ,(concat org-agenda-dir "schedule.org")))))

;; Easy copy-and-paste/screenshot of images.
;; Based on https://github.com/jethrokuan/dots/blob/ecac45367275e7b020f2bba591224ba23949286e/.doom.d/config.el#L513-L549.
(use-package! org-download
  :commands
  org-download-dnd
  org-download-yank
  org-download-screenshot
  org-download-clipboard
  org-download-dnd-base64
  :init
  (map! :after org
        :map org-mode-map
        :localleader
        (:prefix "a"
          "c" #'org-download-screenshot
          "p" #'org-download-clipboard
          "P" #'org-download-yank))
  (pushnew! dnd-protocol-alist
            '("^\\(?:https?\\|ftp\\|file\\|nfs\\):" . +org-download-dnd)
            '("^data:" . org-download-dnd-base64))
  (advice-add #'org-download-enable :override #'ignore)
  :config
  (defun +org/org-download-method (link)
    (let* ((filename
            (file-name-nondirectory
             (car (url-path-and-query
                   (url-generic-parse-url link)))))
           ;; Create folder name with current buffer name, and place in root dir
           (dirname (concat "./images/"
                            (replace-regexp-in-string " " "_"
                                                      (downcase (file-name-base buffer-file-name)))))
           (filename-with-timestamp (format "%s%s.%s"
                                            (file-name-sans-extension filename)
                                            (format-time-string org-download-timestamp)
                                            (file-name-extension filename))))
      (make-directory dirname t)
      (expand-file-name filename-with-timestamp dirname)))
  (setq org-download-screenshot-method "grimshot save area %s"
        org-download-method '+org/org-download-method))

;; Anki editor.
(use-package! anki-editor
  :commands (anki-editor-mode)
  :config
  ;; Used to transform bold and italics into cloze completions.
  (setq bnjmnt4n/anki-editor-cloze-counter 0)
  (defun bnjmnt4n/reset-anki-editor-cloze-counter ()
    (setq bnjmnt4n/anki-editor-cloze-counter 0))
  (defun bnjmnt4n/anki-editor-bold-italic-transcoder (_bold contents _info)
    (setq bnjmnt4n/anki-editor-cloze-counter (1+ bnjmnt4n/anki-editor-cloze-counter))
    (format "{{c%d::%s}}" bnjmnt4n/anki-editor-cloze-counter contents))
  ;; Override anki-editor's HTML backend.
  (setq anki-editor--ox-anki-html-backend
      (org-export-create-backend
       :parent 'html
       :transcoders '((latex-fragment . anki-editor--ox-latex-for-mathjax)
                      (latex-environment . anki-editor--ox-latex-for-mathjax)
                      (bold . bnjmnt4n/anki-editor-bold-italic-transcoder)
                      (italic . bnjmnt4n/anki-editor-bold-italic-transcoder))))
  (advice-add 'anki-editor--build-fields :before #'bnjmnt4n/reset-anki-editor-cloze-counter)
  (advice-add 'anki-editor-export-subtree-to-html :before #'bnjmnt4n/reset-anki-editor-cloze-counter)
  (advice-add 'anki-editor-convert-region-to-html :before #'bnjmnt4n/reset-anki-editor-cloze-counter))

;; Telegram client.
(use-package! telega
  :commands (telega)
  :init
  ;; Display chats on a split buffer to the right.
  (set-popup-rules!
    '(("^\\*Telega Root\\*$" :ignore t)
      ("^\\*Telegram Message Info\\*$" :height 0.35 :select t :modeline nil)
      ("^\\*Telegram Chat Info\\*$" :height 0.4 :select t :modeline nil)
      ("^◀" :side right :width 120 :quit current :select t :modeline t)))
  ;; Display system notifications.
  (add-hook 'telega-load-hook #'telega-notifications-mode)
  :config
  (map! :map telega-msg-button-map "k" nil))

(defun =telegram ()
  "Activate (or switch to) `telega' in its workspace."
  (interactive)
  (+workspace-switch "telegram" t)
  (doom/switch-to-scratch-buffer)
  (telega)
  (+workspace/display))

;; Update feeds when entering elfeed.
(after! elfeed
  (add-hook 'elfeed-search-mode-hook #'elfeed-update)
  (set-popup-rule! "^\\*elfeed-entry"
    :size 0.75 :actions '(display-buffer-below-selected)
    :select t :quit 'current :ttl t))

;; Enable syntax highlighting in Git diffs.
(use-package! magit-delta
  :commands (magit-delta-mode))
(after! magit
  (add-hook 'magit-mode-hook #'magit-delta-mode))

;; Notmuch config.
(setq +notmuch-sync-backend 'mbsync)

;; Modeline: remove border
(custom-set-faces!
  '(mode-line :box nil)
  '(mode-line-inactive :box nil))
