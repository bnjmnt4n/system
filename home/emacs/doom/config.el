;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

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
(let* ((item (alist-get "Open project" +doom-dashboard-menu-sections nil nil 'equal)))
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
      org-roam-directory org-directory
      org-agenda-files nil
      +org-roam-open-buffer-on-find-file nil)

;; org-roam: add TODOs in org-roam files to org-agenda.
;; Based on:
;; - https://magnus.therning.org/2021-07-23-keeping-todo-items-in-org-roam-v2.html
;; - https://d12frosted.io/posts/2021-01-16-task-management-with-roam-vol5.html

(defun roam-extra:get-filetags ()
  "Return the list of filetags for the current buffer."
  (split-string (or (org-roam-get-keyword "filetags") "")))

(defun roam-extra:add-filetag (tag)
  "Add the given TAG to the list of filetags for the current buffer."
  (let* ((new-tags (cons tag (roam-extra:get-filetags)))
         (new-tags-str (combine-and-quote-strings new-tags)))
    (org-roam-set-keyword "filetags" new-tags-str)))

(defun roam-extra:del-filetag (tag)
  "Remove the given TAG from the list of filetags for the current buffer."
  (let* ((new-tags (seq-difference (roam-extra:get-filetags) `(,tag)))
         (new-tags-str (combine-and-quote-strings new-tags)))
    (org-roam-set-keyword "filetags" new-tags-str)))

(defun roam-extra:todo-p ()
  "Return non-nil if current buffer has any TODO entry.

TODO entries marked as done are ignored, meaning that this
function returns nil if current buffer contains only completed
tasks."
  (org-element-map
      (org-element-parse-buffer 'headline)
      'headline
    (lambda (h)
      (eq (org-element-property :todo-type h)
          'todo))
    nil 'first-match))

(defun roam-extra:update-todo-tag ()
  "Update TODO tag in the current buffer."
  (when (and (not (active-minibuffer-window))
             (org-roam-file-p))
    (org-with-point-at 1
      (let* ((tags (roam-extra:get-filetags))
             (is-todo (roam-extra:todo-p)))
        (cond ((and is-todo (not (seq-contains-p tags "todo")))
               (roam-extra:add-filetag "todo"))
              ((and (not is-todo) (seq-contains-p tags "todo"))
               (roam-extra:del-filetag "todo")))))))

(defun roam-extra:todo-files ()
  "Return a list of note files containing the 'todo' filetag." ;
  (seq-uniq
   (seq-map
    #'car
    (org-roam-db-query
     [:select [nodes:file]
      :from tags
      :left-join nodes
      :on (= tags:node-id nodes:id)
      :where (like tag (quote "%\"todo\"%"))]))))

(defun roam-extra:update-todo-files (&rest _)
  "Update the value of `org-agenda-files'."
  (setq org-agenda-files (roam-extra:todo-files)))

;; Add CREATED and UPDATED tags when nodes and files are edited.

(defun org-roam--insert-timestamp ()
  "Insert timestamp for new org-roam file."
  (org-with-point-at 1
    (when (not (org-entry-get nil "CREATED"))
      (org-entry-put nil "CREATED" (format-time-string "[%Y-%m-%d %a %H:%M]"))
      (org-entry-put nil "UPDATED" (format-time-string "[%Y-%m-%d %a %H:%M]")))))

(defun roam-extra:update-timestamp ()
  "Update UPDATED timestamps for node at current point and file in the current buffer."
  (when (and (not (active-minibuffer-window))
             (org-roam-file-p)
             (buffer-modified-p))
    (let* ((timestamp (format-time-string "[%Y-%m-%d %a %H:%M]")))
      (when (org-roam-db-node-p)
        (org-with-point-at (point)
          (org-entry-put nil "UPDATED" timestamp)))
      (org-with-point-at 1
        (org-entry-put nil "UPDATED" timestamp)))))

(defun roam-extra:add-timestamps-on-org-id-creation (&optional force)
  "Add timestamps when org-id is created."
  (when (and (not (active-minibuffer-window))
             (org-roam-file-p)
             (not (org-entry-get nil "ID")))
    (let* ((timestamp (format-time-string "[%Y-%m-%d %a %H:%M]")))
      (org-with-point-at (point)
        (when (not (org-entry-get nil "CREATED"))
          (org-entry-put nil "CREATED" timestamp))
        (org-entry-put nil "UPDATED" timestamp))
      (org-with-point-at 1
        (org-entry-put nil "UPDATED" timestamp)))))

(add-hook 'find-file-hook #'roam-extra:update-todo-tag)
(add-hook 'before-save-hook #'roam-extra:update-todo-tag)
(add-hook 'before-save-hook #'roam-extra:update-timestamp)
(add-hook 'org-roam-capture-new-node-hook #'org-roam--insert-timestamp)
(advice-add 'org-agenda :before #'roam-extra:update-todo-files)
(advice-add 'org-id-get-create :before #'roam-extra:add-timestamps-on-org-id-creation)

(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t!)" "NEXT(n!)" "|" "DONE(d!)")
          (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))
  (setq org-log-into-drawer t)
  (add-to-list 'org-modules 'org-habit))

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
        org-gcal-fetch-file-alist `(("demoneaux@gmail.com" .  ,(concat org-directory "schedule.org")))))

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

;; Modeline: remove border
(custom-set-faces!
  '(mode-line :box nil)
  '(mode-line-inactive :box nil))
