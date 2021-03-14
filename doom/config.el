;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Benjamin Tan"
      user-mail-address "benjamin@dev.ofcr.se")

;; Private configuration.
(load! "secrets.el")

;; Basic display configuration.
(setq doom-font (font-spec :family "Iosevka" :size 16)
      doom-variable-pitch-font (font-spec :family "Libre Baskerville" :height 1.0)
      doom-serif-font (font-spec :family "Libre Baskerville" :height 1.0))

(setq doom-theme 'modus-operandi)

;; TODO: display relative line numbers in normal mode, and absolute line numbers in insert mode?
(setq display-line-numbers-type 'relative)

;; Loosen the split width threshold since my laptop screen width is smaller.
(setq split-width-threshold 140)

;; Custom frame title format, copied from https://tecosaur.github.io/emacs-config/config.html#window-title.
(setq frame-title-format
      '(""
        (:eval
         (if (s-contains-p org-roam-directory (or buffer-file-name ""))
             (replace-regexp-in-string
              "\.org$" ""
              (replace-regexp-in-string
               ".*/[0-9]*-?" "☰ "
               (subst-char-in-string ?_ ?  buffer-file-name)))
           "%b"))
        (:eval
         (let ((project-name (doom-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" " ● %s") project-name))))))

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
  (setq mathpix-screenshot-method "grimshot save area %s"
        mathpix-app-id bnjmnt4n/mathpix-app-id
        mathpix-app-key bnjmnt4n/mathpix-app-key))

;; Sync with Google Calendar.
(use-package! org-gcal
  :commands (org-gcal-sync)
  :init
  (map! "C-x c" #'org-gcal-sync)
  :config
  (setq org-gcal-client-id bnjmnt4n/org-gcal-client-id
        org-gcal-client-secret bnjmnt4n/org-gcal-client-secret
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

;; Transmission client.
(use-package! transmission
  :defer t)

;; Spotify client.
(use-package! spotify-client
  :commands (global-spotify-client-remote-mode)
  :config
  (setq spotify-client-transport 'connect
        spotify-client-oauth2-client-secret bnjmnt4n/spotify-app-client-secret
        spotify-client-oauth2-client-id bnjmnt4n/spotify-app-client-id)
  (set-popup-rules!
    '(("^\\*\\(Playlists:\\|Playlist \\(Tracks\\|Search\\):\\|Album:\\|Track Search:\\|\\(Featured Playlists\\|Recently Played\\)\\*$\\)"
        :side right :width 0.5 :select t :quit current :modeline t)
      ("^\\*Devices\\*$" :height 0.35 :select t))))

;; Update feeds when entering elfeed.
(after! elfeed
  (add-hook 'elfeed-search-mode-hook #'elfeed-update)
  (set-popup-rule! "^\\*elfeed-entry"
    :size 0.75 :actions '(display-buffer-below-selected)
    :select t :quit 'current :ttl t))

(use-package! magit-delta
  :commands (magit-delta-mode))
(after! magit
  (add-hook 'magit-mode-hook #'magit-delta-mode))

;; Notmuch config.
(setq +notmuch-sync-backend 'mbsync)
