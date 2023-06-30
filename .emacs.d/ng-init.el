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
  :preface
  (defun font-available-p (font-name)
    (find-font (font-spec :name font-name)))
  :config
  (setq default-frame-alist '((font . "Cica-12")))
  (set-fontset-font "fontset-default" 'unicode "Noto Color Emoji" nil 'prepend)
  ;; 日本語 | 🍣
  (cond
   ((font-available-p "Cica")
    (set-frame-font "Cica-12"))
   ((font-available-p "Cascadia Code")
    (set-frame-font "Cascadia Code-12"))
   ((font-available-p "Menlo")
    (set-frame-font "Menlo-12"))
   ((font-available-p "Inconsolata")
    (set-frame-font "Inconsolata-12"))))

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
           (recentf-auto-cleanup . 10)
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
    (org-refile-targets . '(("~/org/inbox.org" :maxlevel . 2)
                            ("~/org/daily.org" :level . 3))))
  :init
  (require 'org-protocol)
  (leaf ox-gfm
    :doc "Github Flavored Markdown Back-End for Org Export Engine"
    :tag "github" "markdown" "wp" "org"
    :added "2021-04-26"
    :ensure t))


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
  :init
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  
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
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-file consult--source-project-file consult--source-bookmark
   :preview-key (kbd "M-."))
  (setq consult-project-root-function
        (lambda ()
          (when-let (project (project-current))
            (car (project-roots project)))))
  :bind (
         ("C-x C-b" . consult-buffer)
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
         )
  )


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


(provide 'init)

;; Local Variables:
;; byte-compile-warnings: (not cl-functions obsolete)
;; indent-tabs-mode: nil
;; eval: (leaf-tree-mode)
;; End:

;;; init.el ends here
