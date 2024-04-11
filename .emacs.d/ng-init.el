;;; package --- Summary

;;; Commentary:
(defconst my/saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
;;; Code:
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

;; Now you can use leaf!

(leaf leaf
  :config
  (leaf leaf-tree :ensure t)
  (leaf leaf-convert  :ensure t))


(leaf server
  :require t
  :defun server-running-p
  :config
  (unless (server-running-p) (server-start)))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(leaf my/global-key-map
  :config
  (define-key key-translation-map (kbd "C-h") (kbd "<DEL>")))




(leaf my/window
  :hook (after-make-frame-functions
         .
         (lambda (frame)
           (when (display-graphic-p frame)
             (setq browse-url-browser-function 'browse-url-generic
                   browse-url-generic-program (executable-find "firefox"))
             ))))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file  . ,(locate-user-emacs-file "custom.el"))))


;; initial-frame-alist '((font . "Cica-13.5"))
;; default-frame-alist '((font . "Cica-13.5"))

;; |012345 678910|
;; |abcdef ghijkl|
;; |ABCDEF GHIJKL|
;; |αβγδεζ ηθικλμ|
;; |ΑΒΓΔΕΖ ΗΘΙΚΛΜ|
;; |∩∪∞≤≥∏ ∑∫×±⊆⊇|
;; |'";:-+ =/\~`?|
;; |日本語 の美観|
;; |あいう えおか|
;; |アイウ エオカ|
;; |ｱｲｳｴｵｶ ｷｸｹｺｻｼ|

(leaf fonts
  :defun my/configure-font
  :preface
  (defun my/configure-font (frame)
    (interactive)
    (when (display-graphic-p frame)
      (let* ((family "Cica")
             (fontspec (font-spec :family family :weight 'normal))
             (fsize 12))
        (setq use-default-font-for-symbols nil)
        (add-to-list 'default-frame-alist '(font . (concat family "-" (number-to-string fsize))))
        (set-fontset-font "fontset-default" 'unicode family)
        (set-face-attribute 'default nil :family "monospace" :height (* fsize 10)))
      (remove-hook 'after-make-frame-functions #'my/configure-font)))
  :hook
  (after-make-frame-functions . my/configure-font))





(leaf cus-starts
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))
  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom ((user-login-name . "t754")
           (truncate-lines . t)
           (menu-bar-mode . nil)
           (tool-bar-mode . nil)
           (scroll-bar-mode . nil)
           (indent-tabs-mode . nil)
           (text-quoting-style . 'straight)
           (browse-url-browser-function . 'eww-browse-url)
           (tab-width . 4)
           (abbrev-file-name . "~/.emacs.d/abbrev_defs")
           (recentf-max-saved-items . 2000)
           (recentf-auto-cleanup . 10)
           (use-short-answers . t)
           )
  :init
  (recentf-mode 1)
  :config
  (run-at-time nil (* 5 60) 'recentf-save-list)
  (defalias 'yes-or-no-p 'y-or-n-p))


(leaf dired
  :doc "directory-browsing commands"
  :tag "builtin" "files"
  :added "2020-12-26"
  :bind (("C-c o" . my/dired-open-file))
  :custom ((dired-dwim-target . t))
  :config
  (defun my/dired-open-file ()
    "In dired, open the file named on this line."
    (interactive)
    (let* ((file (dired-get-filename nil t)))
      (call-process "xdg-open" nil 0 nil file))))


(leaf display-line-numbers
  :doc "interface for display-line-numbers"
  :tag "builtin"
  :added "2022-05-15"
  :global-minor-mode global-display-line-numbers-mode)

(leaf exec-path-from-shell
  :doc "Get environment variables such as $PATH from the shell"
  :req "emacs-24.1" "cl-lib-0.6"
  :tag "environment" "unix" "emacs>=24.1"
  :added "2020-12-18"
  :url "https://github.com/purcell/exec-path-from-shell"
  :emacs>= 24.1
  :ensure t
  :init
  (exec-path-from-shell-copy-envs '("MANPATH" "PATH" "GOROOT" "GOPATH" )))

(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)


(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))
(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))


(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :custom ((kill-ring-max . 100)
           (kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))


(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 0.1))
  :global-minor-mode global-auto-revert-mode)

(leaf doom-themes
  :doc "an opinionated pack of modern color-themes"
  :req "emacs-25.1" "cl-lib-0.5"
  :tag "faces" "themes" "emacs>=25.1"
  :url "https://github.com/doomemacs/themes"
  :added "2024-04-10"
  :emacs>= 25.1
  :ensure t
  :config
  (load-theme 'doom-nord t)
  (doom-themes-org-config))

(leaf dimmer
  :doc "Visually highlight the selected buffer"
  :req "emacs-25.1"
  :tag "editing" "faces" "emacs>=25.1"
  :url "https://github.com/gonewest818/dimmer.el"
  :added "2024-04-11"
  :emacs>= 25.1
  :ensure t
  :global-minor-mode dimmer-mode)

(leaf indent-guide
  :doc "show vertical lines to guide indentation"
  :url "http://hins11.yu-yake.com/"
  :added "2024-04-11"
  :ensure t
  :global-minor-mode indent-guide-global-mode)

(leaf nerd-icons
  :doc "Emacs Nerd Font Icons Library"
  :req "emacs-24.3"
  :tag "lisp" "emacs>=24.3"
  :url "https://github.com/rainstormstudio/nerd-icons.el"
  :added "2024-04-11"
  :emacs>= 24.3
  :ensure t
  :init
  (leaf ibuffer
    :doc "operate on buffers like dired"
    :tag "builtin"
    :added "2024-04-11"
    :bind ("C-x C-b" . ibuffer))
  (leaf nerd-icons-ibuffer
    :doc "Display nerd icons in ibuffer"
    :req "emacs-24.3" "nerd-icons-0.0.1"
    :tag "ibuffer" "icons" "convenience" "emacs>=24.3"
    :url "https://github.com/seagle0128/nerd-icons-ibuffer"
    :added "2024-04-11"
    :emacs>= 24.3
    :ensure t
    :hook (ibuffer-mode-hook . nerd-icons-ibuffer-mode)
    :custom ((inhibit-compacting-font-caches . t)))

  (leaf dirvish
    :doc "A modern file manager based on dired mode"
    :req "emacs-27.1" "transient-0.3.7"
    :tag "convenience" "files" "emacs>=27.1"
    :url "https://github.com/alexluigit/dirvish"
    :added "2024-04-11"
    :emacs>= 27.1
    :ensure t
    :global-minor-mode dirvish-override-dired-mode dirvish-peek-mode
    :custom '(
              (dirvish-mode-line-format . '(:left (sort file-time " " file-size symlink) :right (omit yank index)))
              (dirvish-header-line-format . '(:left (path) :right (free-space)))
              (dirvish-mode-line-height . 10)
              (dirvish-attributes . '(nerd-icons file-time file-size collapse subtree-state vc-state git-msg))
              ;; (dirvish-subtree-state-style . 'arrow)
              (delete-by-moving-to-trash . t)
              ;; (dirvish-path-separators . '(
              ;;                              ,(format "  %s " (nerd-icons-codicon "nf-cod-home"))
              ;;                              ,(format "  %s " (nerd-icons-codicon "nf-cod-root_folder"))
              ;;                              ,(format " %s " (nerd-icons-faicon "nf-fa-angle_right"))))
              (dired-listing-switches .  "-l --almost-all --human-readable --group-directories-first --no-group")
              )))

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :custom ((flycheck-emacs-lisp-initialize-packages . t))
  :hook (emacs-lisp-mode-hook lisp-interaction-mode-hook)
  :config
  (leaf flycheck-package
    :doc "A Flycheck checker for elisp package authors"
    :ensure t
    :config
    (flycheck-package-setup))

  (leaf flycheck-elsa
    :doc "Flycheck for Elsa."
    :emacs>= 25
    :ensure t
    :config
    (flycheck-elsa-setup)))

(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode)


(leaf helpful
  :doc "A better *help* buffer"
  :req "emacs-25" "dash-2.18.0" "s-1.11.0" "f-0.20.0" "elisp-refs-1.2"
  :tag "lisp" "help" "emacs>=25"
  :url "https://github.com/Wilfred/helpful"
  :added "2024-04-10"
  :emacs>= 25
  :ensure t
  :custom ((counsel-describe-function-function . #'helpful-callable)
           (counsel-describe-variable-function . #'helpful-variable))
  :bind  (("C-h f" . helpful-callable)
          ("C-h v" . helpful-variable)
          ("C-h k" . helpful-key)
          ("C-h x" . helpful-command)
          ("C-c C-d" . helpful-at-point)))


(leaf pulsar
  :doc "Pulse highlight on demand or after select functions"
  :req "emacs-27.1"
  :tag "highlight" "pulse" "convenience" "emacs>=27.1"
  :url "https://git.sr.ht/~protesilaos/pulsar"
  :added "2024-04-10"
  :emacs>= 27.1
  :ensure t
  :custom ((pulsar-pulse . t)
           (pulsar-delay . 0.055)
           (pulsar-iterations . 10)
           (pulsar-face . 'pulsar-magenta)
           (pulsar-highlight-face . 'pulsar-yellow))
  :global-minor-mode pulsar-global-mode)

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "async-20200113" "dash-20200524" "git-commit-20200516" "transient-20200601" "with-editor-20200522"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :added "2020-10-24"
  :emacs>= 25.1
  :ensure t
  ;; :after git-commit with-editor
  :bind (("C-x g" . magit-status)))
(leaf vc
  :doc "drive a version-control system from within Emacs"
  :tag "builtin"
  :added "2024-04-12"
  :require t)

(leaf pcre2el
  :doc "regexp syntax converter"
  :req "emacs-24" "cl-lib-0.3"
  :tag "emacs>=24"
  :added "2020-12-18"
  :url "https://github.com/joddie/pcre2el"
  :emacs>= 24
  :ensure t)

(leaf find-file-in-project
  :doc "Find file/directory and review Diff/Patch/Commit efficiently everywhere"
  :req "ivy-0.10.0" "emacs-24.4"
  :tag "convenience" "project" "emacs>=24.4"
  :added "2020-10-30"
  :url "https://github.com/technomancy/find-file-in-project"
  :emacs>= 24.4
  :ensure t
  :after ivy
  :bind (("C-M-o" . find-file-in-project)))

(leaf projectile
  :doc "Manage and navigate projects in Emacs easily"
  :req "emacs-25.1"
  :tag "convenience" "project" "emacs>=25.1"
  :url "https://github.com/bbatsov/projectile"
  :added "2023-10-06"
  :emacs>= 25.1
  :ensure t
  :bind ((projectile-mode-map ("C-c p" . projectile-command-map)))
  :config
  (projectile-mode +1))

(leaf yasnippet
  :doc "Yet another snippet extension for Emacs"
  :req "cl-lib-0.5"
  :tag "emulation" "convenience"
  :added "2020-12-27"
  :url "http://github.com/joaotavora/yasnippet"
  :ensure t
  :defun yas-reload-all
  ;; :hook (prog-mode-hook . #'yas-minor-mode)
  ;; :global-minor-mode yas-minor-mode
  :hook (after-init . yas-global-mode)
  :bind ((yas-minor-mode-map
          ("C-c i n" . yas-new-snippet)
          ("C-c i v" . yas-visit-snippet-file)
          ("C-c i i" . yas-insert-snippet)))
  :config
  (yas-reload-all)
   )

(leaf org
  :doc "Export Framework for Org Mode"
  :tag "builtin"
  :added "2020-10-30"
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c b" . org-iswitchb))
  :custom
  `((org-directory . "~/org")
    (org-default-notes-file .  "~/org/inbox.org")
    (org-agenda-files . '("~/org/work.org" "~/org/daily.org" "~/org/inbox.org"))
    (org-capture-templates
     .
     '(
       ("p" "Protocol" entry (file+headline "inbox.org" "Inbox")
        "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
       ("L" "Protocol Link" entry (file+headline "inbox.org" "Inbox")
        "* %? %:annotation\n")
       ("i" "inbox" entry
        (file "~/org/inbox.org")
        "* %?\n %T\n %a\n %i\n"
        :empty-lines 1 )
       ("h" "hobby"
        entry (file "~/org/hobby.org")
        "* %?\n %T\n %a\n %i\n"
        :empty-lines 1)
       ("w" "work"
        entry (file "~/org/work.org")
        "* %?\n %T\n %i\n"
        :empty-lines 1)
       ("t" "todo-work"
        entry
        (file+headline "~/org/work.org" "tasks")
        "** TODO %?\n  SCHEDULED: %^t\n ")
       ("d" "daily-template"
        entry
        (file+olp+datetree "daily.org")
        "%[~/org/daily-template]"
        ;; :unnarrowed 1
        :tree-type week
        ;; :time-prompt t
        )))
    (org-archive-location . ,(format-time-string "%%s_archive_%Y::" (current-time)))
    (org-use-speed-commands . t)
    (org-todo-keywords . '("TODO(t)" "DOING(g)" "WAITING(w)" "|" "DONE(d)"))
    (org-log-done . 'note)
    (org-tag-alist . '(("crypt" . ?c)))
    (org-refile-targets . '(
                            ;; ("~/org/inbox.org" :maxlevel . 2)
                            ;; ("~/org/daily.org" :level . 3)
                            
                            )))
  :init
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t)))
  (require 'org-protocol)
  (leaf org-crypt
    :doc "Public Key Encryption for Org Entries"
    :tag "builtin"
    :added "2022-06-14"
    :custom
    (org-tags-exclude-from-inheritance . '("crypt"))
    (org-crypt-key . nil)
    (auto-save-default . nil)
    :init
    (org-crypt-use-before-save-magic))
    
  
  (leaf ox-gfm
    :doc "Github Flavored Markdown Back-End for Org Export Engine"
    :tag "github" "markdown" "wp" "org"
    :added "2021-04-26"
    :ensure t)

  
  (leaf org-journal
    :doc "a simple org-mode based journaling mode"
    :req "emacs-25.1" "org-9.1"
    :tag "emacs>=25.1"
    :url "http://github.com/bastibe/org-journal"
    :added "2022-12-20"
    :emacs>= 25.1
    :ensure t
    :after org
    :bind (("C-c j" . org-journal-new-entry))
    :custom `((org-journal-dir . ,(file-truename "~/org/roam"))
              (org-journal-date-format . "%Y-%m-%d, %A")
              (org-journal-time-format . "%R\n\n")
              (org-journal-file-format . "%Y%m%d.org")
              (org-journal-file-type . 'weekly)
              ))
  (leaf org-roam
    :doc "A database abstraction layer for Org-mode"
    :req "emacs-26.1" "dash-2.13" "org-9.4" "emacsql-3.0.0" "emacsql-sqlite-1.0.0" "magit-section-3.0.0"
    :tag "convenience" "roam" "org-mode" "emacs>=26.1"
    :url "https://github.com/org-roam/org-roam"
    :added "2022-12-20"
    :emacs>= 26.1
    :ensure t
    :after org emacsql emacsql-sqlite magit-section
    :custom `((org-roam-directory . ,(file-truename "~/org/roam"))))
  (leaf org-roam-ui
    :doc "User Interface for Org-roam"
    :req "emacs-27.1" "org-roam-2.0.0" "simple-httpd-20191103.1446" "websocket-1.13"
    :tag "outlines" "files" "emacs>=27.1"
    :url "https://github.com/org-roam/org-roam-ui"
    :added "2022-12-20"
    :emacs>= 27.1
    :ensure t
    :after org-roam websocket))


;; (leaf color-theme-sanityinc-tomorrow
;;   :doc "A version of Chris Kempson's \"tomorrow\" themes"
;;   :tag "themes" "faces"
;;   :added "2020-11-04"
;;   :url "https://github.com/purcell/color-theme-sanityinc-tomorrow"
;;   :ensure t
;;   :config (load-theme 'sanityinc-tomorrow-night t))

(leaf my/scratch
  :defun my/make-scratch
  :hook
  (kill-buffer-query-functions
   .
   (lambda ()
     (let ((is-sc (string= "*scratch*" (buffer-name))))
       (when is-sc
         (my/make-scratch 0))
       (not is-sc))))

  :init
  (defun my/make-scratch (&optional arg)
    (interactive)
    (progn
      (set-buffer (get-buffer-create "*scratch*"))
      (funcall initial-major-mode)
      (erase-buffer)
      (when (and initial-scratch-message (not inhibit-startup-message))
        (insert initial-scratch-message))
      (or arg (progn (setq arg 0)
                     (switch-to-buffer "*scratch*")))
      (cond ((= arg 0) (message "*scratch* is cleared up."))
            ((= arg 1) (message "another *scratch* is created"))))))


(leaf yaml-mode
  :doc "Major mode for editing YAML files"
  :req "emacs-24.1"
  :tag "yaml" "data" "emacs>=24.1"
  :added "2020-12-02"
  :emacs>= 24.1
  :ensure t
  :custom ((flycheck-disabled-checkers . '(yaml-ruby))))

(leaf emamux
  :doc "Interact with tmux"
  :req "emacs-24.3"
  :tag "emacs>=24.3"
  :added "2020-12-02"
  :url "https://github.com/syohex/emacs-emamux"
  :emacs>= 24.3
  :ensure t)


(leaf python-mode
  :doc "Python major mode"
  :added "2020-12-16"
  :ensure t
  :custom ((python-indent-guess-indent-offset . t)
           (python-indent-guess-indent-offset-verbose . nil))
  :init
  (leaf lsp-python-ms
    :doc "The lsp-mode client for Microsoft python-language-server"
    :req "emacs-25.1" "lsp-mode-6.1"
    :tag "tools" "languages" "emacs>=25.1"
    :added "2020-12-16"
    :url "https://github.com/emacs-lsp/lsp-python-ms"
    :emacs>= 25.1
    :ensure t
    :after lsp-mode
    :custom ((lsp-python-ms-auto-install-server . t)))
  :hook (python-mode-hook . (lambda ()
                              (require 'lsp-python-ms)
                              (lsp-deferred))))
(leaf go-mode
  :doc "Major mode for the Go programming language"
  :tag "go" "languages"
  :added "2020-12-18"
  :url "https://github.com/dominikh/go-mode.el"
  :ensure t
  :defun lsp-format-buffer lsp-organize-imports
  :hook
  (go-mode-hook . (lambda ()
                    (lsp-deferred)
                    (add-hook 'before-save-hook
                              (lambda ()
                                (lsp-format-buffer)
                                (lsp-organize-imports))
                              t t))))

(leaf lsp-mode
  :doc "LSP mode"
  :req "emacs-26.1" "dash-2.14.1" "dash-functional-2.14.1" "f-0.20.0" "ht-2.0" "spinner-1.7.3" "markdown-mode-2.3" "lv-0"
  :tag "languages" "emacs>=26.1"
  :added "2020-12-10"
  :url "https://github.com/emacs-lsp/lsp-mode"
  :emacs>= 26.1
  :ensure t
  :after spinner markdown-mode lv
  :custom ((lsp-log-io . t))
  :defvar my/format-on-save
  :hook (before-save-hook . (lambda ()
                              ;; consider setproject-local variables on `.dir-locals.el`
                              (when (intern-soft (concat "my/" (symbol-name 'format-on-save)))
                                (lsp-format-buffer))))
  :init
  (leaf lsp-ui
    :doc "UI modules for lsp-mode"
    :req "emacs-26.1" "dash-2.18.0" "lsp-mode-6.0" "markdown-mode-2.3"
    :tag "tools" "languages" "emacs>=26.1"
    :added "2022-05-01"
    :url "https://github.com/emacs-lsp/lsp-ui"
    :emacs>= 26.1
    :ensure t
    :bind ((:lsp-ui-mode-map
            ([remap xref-find-definitions] . #'lsp-ui-peek-find-definitions)
            ([remap xref-find-references]  . #'lsp-ui-peek-find-references)))
    :after lsp-mode markdown-mode)
  
  (leaf lsp-ivy
    :doc "LSP ivy integration"
    :req "emacs-25.1" "dash-2.14.1" "lsp-mode-6.2.1" "ivy-0.13.0"
    :tag "debug" "languages" "emacs>=25.1"
    :added "2020-12-10"
    :url "https://github.com/emacs-lsp/lsp-ivy"
    :emacs>= 25.1
    :ensure t
    :after lsp-mode ivy)
  (setq read-process-output-max 10240)
  (setq gc-cons-threshold  (* 1024 1024 10)))


(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :added "2024-04-11"
  :emacs>= 24.5
  :ensure t
  :custom ((ivy-use-virtual-buffers . t))
  :global-minor-mode ivy-mode
  :bind (("C-h b" .  counsel-descbinds)))

(leaf consult
  :doc "Consulting completing-read"
  :req "emacs-26.1"
  :tag "emacs>=26.1"
  :added "2021-06-14"
  :url "https://github.com/minad/consult"
  :emacs>= 26.1
  :ensure t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :defun consult-customize project-roots
  :defvar consult-theme consult-ripgrep consult-git-grep consult-grep
  consult-bookmark consult-recent-file consult-xref
  consult--source-file consult--source-project-file consult--source-bookmark
  consult-project-root-function
  consult--source-recent-file
  consult--source-project-recent-file
  consult-narrow-key
  :init
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)

  (leaf counsel-projectile
    :doc "Ivy integration for Projectile"
    :req "counsel-0.13.4" "projectile-2.5.0"
    :tag "convenience" "project"
    :url "https://github.com/ericdanan/counsel-projectile"
    :added "2023-10-10"
    :ensure t
    :after counsel projectile)
  
  (leaf counsel-tramp
    :doc "Tramp ivy interface for ssh, docker, vagrant"
    :req "emacs-24.3" "counsel-0.10"
    :tag "emacs>=24.3"
    :url "https://github.com/masasam/emacs-counsel-tramp"
    :added "2022-11-01"
    :emacs>= 24.3
    :ensure t
    :after counsel
    :custom (tramp-default-method . "ssh"))
  
  (leaf consult-ghq
    :doc "Ghq interface using consult"
    :req "emacs-26.1" "consult-0.8" "affe-0.1"
    :tag "ghq" "consult" "usability" "convenience" "emacs>=26.1"
    :added "2021-06-18"
    :url "https://github.com/tomoya/consult-ghq"
    :emacs>= 26.1
    :ensure t
    :after consult affe)
  (leaf orderless
    :doc "Completion style for matching regexps in any order"
    :req "emacs-24.4"
    :tag "extensions" "emacs>=24.4"
    :added "2021-06-14"
    :url "https://github.com/oantolin/orderless"
    :emacs>= 24.4
    :ensure t
    :custom ((completion-styles . '(orderless))))

  (leaf vertico
    :doc "VERTical Interactive COmpletion"
    :req "emacs-27.1"
    :tag "emacs>=27.1"
    :added "2021-06-14"
    :url "https://github.com/minad/vertico"
    :emacs>= 27.1
    :ensure t
    :hook (after-init-hook . vertico-mode)
    :custom ((vertico-count . 20)))

  (leaf marginalia
    :doc "Enrich existing commands with completion annotations"
    :req "emacs-26.1"
    :tag "emacs>=26.1"
    :added "2021-06-14"
    :url "https://github.com/minad/marginalia"
    :emacs>= 26.1
    :ensure t
    :hook (after-init-hook . (lambda()
                               (marginalia-mode)
                               (savehist-mode))))
  :config
  (setq consult-narrow-key "<")
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark
   consult--source-recent-file
   consult--source-project-recent-file
   )
  ;; (setq consult-project-root-function
  ;;       (lambda ()
  ;;         (when-let (project (project-current))
  ;;           (car (project-roots project)))))
  ;; :global-minor-mode consult-mode
  :bind (
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ("C-x C-r" . consult-recent-file)
         ("C-x b" . consult-buffer)
         ("M-s f" . consult-find)
         ("M-s L" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("C-s" . consult-line)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ("M-y" . consult-yank-pop)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         (minibuffer-local-map
               ("M-s" . consult-history)                 ;; orig. next-matching-history-element
               ("M-r" . consult-history))
         ))




(leaf embark
  :doc "Conveniently act on minibuffer completions"
  :req "emacs-26.1"
  :tag "convenience" "emacs>=26.1"
  :added "2021-06-14"
  :url "https://github.com/oantolin/embark"
  :emacs>= 26.1
  :ensure t
  :init
  (leaf embark-consult
    :doc "Consult integration for Embark"
    :req "emacs-25.1" "embark-0.9" "consult-0.1"
    :tag "convenience" "emacs>=25.1"
    :added "2021-06-14"
    :url "https://github.com/oantolin/embark"
    :emacs>= 25.1
    :ensure t
    :after embark consult))



(leaf js
  :doc "Major mode for editing JavaScript"
  :tag "builtin"
  :added "2022-05-01"
  :custom ((js-indent-level . 2)))


(leaf typescript-mode
  :doc "Major mode for editing typescript"
  :req "emacs-24.3"
  :tag "languages" "typescript" "emacs>=24.3"
  :added "2022-05-01"
  :url "http://github.com/ananthakumaran/typescript.el"
  :emacs>= 24.3
  :ensure t
  :custom ((typescript-indent-level . 2)))


(leaf lua-mode
  :doc "a major-mode for editing Lua scripts"
  :req "emacs-24.3"
  :tag "tools" "processes" "languages" "emacs>=24.3"
  :added "2021-12-02"
  :url "https://immerrr.github.io/lua-mode"
  :emacs>= 24.3
  :ensure t)

(leaf terraform-mode
  :doc "Major mode for terraform configuration file"
  :req "emacs-24.3" "hcl-mode-0.3" "dash-2.17.0"
  :tag "emacs>=24.3"
  :url "https://github.com/syohex/emacs-terraform-mode"
  :added "2022-05-19"
  :emacs>= 24.3
  :ensure t
  :after hcl-mode)

(leaf jinja2-mode
  :doc "A major mode for jinja2"
  :added "2022-05-23"
  :ensure t)
(leaf php-mode
  :doc "Major mode for editing PHP code"
  :req "emacs-25.2"
  :tag "php" "languages" "emacs>=25.2"
  :url "https://github.com/emacs-php/php-mode"
  :added "2023-02-06"
  :emacs>= 25.2
  :ensure t)
(leaf xml-format
  :doc "XML reformatter using xmllint"
  :req "emacs-25" "reformatter-0.4"
  :tag "languages" "emacs>=25"
  :url "https://github.com/wbolster/emacs-xml-format"
  :added "2023-05-19"
  :emacs>= 25
  :ensure t
  :after reformatter)

(leaf dashboard
  :doc "A startup screen extracted from Spacemacs"
  :req "emacs-26.1"
  :tag "dashboard" "tools" "screen" "startup" "emacs>=26.1"
  :url "https://github.com/emacs-dashboard/emacs-dashboard"
  :added "2023-10-06"
  :emacs>= 26.1
  :ensure t
  :hook (elpaca-after-init-hook . dashboard-insert-startupify-lists)
  :hook (elpaca-after-init-hook . dashboard-initialize)
  :defvar dashboard-projects-switch-function
  :init
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  (setq dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name)
  (dashboard-setup-startup-hook)
  :custom ((dashboard-items . '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        (agenda . 5)
                        (registers . 5)))))

(leaf editorconfig
  :doc "EditorConfig Emacs Plugin"
  :req "emacs-26.1" "nadvice-0.3"
  :tag "editorconfig" "convenience" "emacs>=26.1"
  :url "https://github.com/editorconfig/editorconfig-emacs#readme"
  :added "2023-10-25"
  :emacs>= 26.1
  :ensure t
  :after nadvice
  :defun editorconfig-mode
  :config
  (editorconfig-mode 1)
  )

(leaf ansible-vault
  :doc "Minor mode for editing ansible vault files"
  :req "emacs-24.3"
  :tag "tools" "ansible-vault" "ansible" "emacs>=24.3"
  :url "http://github.com/zellio/ansible-vault-mode"
  :added "2023-12-08"
  :emacs>= 24.3
  :ensure t)
(provide 'init)

(setq file-name-handler-alist my/saved-file-name-handler-alist)
;; Local Variables:
;; byte-compile-warnings: (not cl-functions obsolete)
;; indent-tabs-mode: nil
;; eval: (leaf-tree-mode)
;; End:

;;; init.el ends here
