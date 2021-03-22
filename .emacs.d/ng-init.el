;;; package --- Summary

;;; Commentary:

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

(leaf my/font
  :config
  (setq default-frame-alist '((font . "Ricty-12")))
  (set-fontset-font "fontset-default" 'unicode "Noto Color Emoji" nil 'prepend))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file  . ,(locate-user-emacs-file "custom.el"))))



(leaf cus-start
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
           (recentf-auto-cleanup . 'never)
           )
  :config
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


(leaf linum
  :doc "display line numbers in the left margin"
  :tag "builtin"
  :added "2020-10-20"
  :preface
  (defadvice linum-schedule (around my-linum-schedule () activate)
    (run-with-idle-timer 0.2 nil #'linum-update-current))
  :custom ((linum-delay . t))
  :global-minor-mode global-linum-mode)

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

(leaf beacon
  :doc "Highlight the cursor whenever the window scrolls"
  :req "seq-2.14"
  :tag "convenience"
  :added "2020-10-24"
  :url "https://github.com/Malabarba/beacon"
  :ensure t
  :defun beacon--blink-on-focus
  :global-minor-mode t
  :custom ((beacon-blink-when-focused . t))
  :init   (add-function :after after-focus-change-function
                        (lambda ()
                          (beacon--blink-on-focus))))

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

(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-re-builders-alist . '((t . ivy--regex-fuzzy)
                                      (swiper . ivy--regex-plus)))
           (ivy-use-virtual-buffers . t)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf)
           ("C-x C-b" . counsel-ibuffer)
           ("M-s a" . counsel-ag)
           ("M-s g" . counsel-git-grep)
           ("M-x" . counsel-M-x))
    :config
    (add-to-list 'ivy-sort-functions-alist
                 '(counsel-recentf . file-newer-than-file-p))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t)
  (leaf ivy-hydra
  :doc "Additional key bindings for Ivy"
  :req "emacs-24.5" "ivy-0.13.0" "hydra-0.15.0"
  :tag "convenience" "emacs>=24.5"
  :added "2021-03-17"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :after ivy hydra))


(leaf ivy-rich
  :doc "More friendly display transformer for ivy."
  :req "emacs-24.5" "ivy-0.8.0"
  :tag "ivy" "emacs>=24.5"
  :emacs>= 24.5
  :ensure t
  :after ivy
  :global-minor-mode t)


(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :commands (prescient-persist-mode)
  :custom `((prescient-aggressive-file-save . t)
            (prescient-save-file . ,(locate-user-emacs-file "prescient")))
  :global-minor-mode prescient-persist-mode)

(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

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

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "async-20200113" "dash-20200524" "git-commit-20200516" "transient-20200601" "with-editor-20200522"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :added "2020-10-24"
  :emacs>= 25.1
  :ensure t
  ;; :after git-commit with-editor
  :bind (("C-x g" . magit-status)))

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

(leaf yasnippet
  :doc "Yet another snippet extension for Emacs"
  :req "cl-lib-0.5"
  :tag "emulation" "convenience"
  :added "2020-12-27"
  :url "http://github.com/joaotavora/yasnippet"
  :ensure t)

(leaf org
  :doc "Export Framework for Org Mode"
  :tag "builtin"
  :added "2020-10-30"
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c b" . org-iswitchb))
  :custom
  ((org-directory . "~/org")
   (org-default-notes-file .  "~/org/inbox.org")
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
      ("d" "daily-template"
       entry
       (file+olp+datetree "daily.org")
       "%[~/org/daily-template]"
       ;; :unnarrowed 1
       :time-prompt t)))
   (org-use-speed-commands . t)
   (org-refile-targets . '(("~/org/inbox.org" :maxlevel . 2)
                           ("~/org/daily.org" :level . 3))))
  :init
  (require 'org-protocol))

(leaf color-theme-sanityinc-tomorrow
  :doc "A version of Chris Kempson's \"tomorrow\" themes"
  :tag "themes" "faces"
  :added "2020-11-04"
  :url "https://github.com/purcell/color-theme-sanityinc-tomorrow"
  :ensure t
  :config (load-theme 'sanityinc-tomorrow-night t))

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
  :init
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

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; eval: (leaf-tree-mode)
;; End:

;;; init.el ends here
