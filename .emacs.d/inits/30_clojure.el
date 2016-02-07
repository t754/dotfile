
(use-package clojure-mode
  :defer t
  :config
  (progn
    ;; (use-package smart-newline-mode)
    (use-package clojure-mode-extra-font-locking)
    (use-package align-cljlet
      :init (bind-keys :map clojure-mode-map
                       ("C-c j a l" . align-cljlet)))
    (use-package midje-mode)
    (use-package clj-refactor
      :config (cljr-add-keybindings-with-prefix "C-c j"))
    (use-package clojure-snippets)
    (use-package inf-clojure
      :config
      (progn
        (setq inf-clojure-prompt-read-only nil)
        ;; (setq inf-clojure-program "lein repl")

        (defun my/inf-clojure-refresh ()
          (interactive)
          (inf-clojure-eval-string
           "(require '[clojure.tools.namespace.repl])
            (apply clojure.tools.namespace.repl/set-refresh-dirs (get-env :directories))
            (clojure.tools.namespace.repl/refresh)"))

        ;; (defun my/find-tag-without-ns (tag)
        ;;   (interactive
        ;;    (list (my/helm-gtags--read-tagname 'tag-without-ns)))
        ;;   (helm-gtags--common '(helm-source-gtags-tags) tag))

        (defun my/run-clojure ()
          (interactive)
          (setq current-prefix-arg '(4))
          (call-interactively 'run-clojure)
          (paredit-mode))

        (defun my/in-ns-boot-home ()
          (interactive)
          (inf-clojure-eval-string "(in-ns 'boot.user)"))

        (bind-keys :map inf-clojure-minor-mode-map
                   ("C-c C-x" . my/inf-clojure-refresh)
                   ("C-c z" . my/run-clojure)
                   ("C-c C-z" . inf-clojure-switch-to-repl)
                   ("C-c C-h" . my/in-ns-boot-home)
                   ("M-." . my/find-tag-without-ns))))

    (defun my/clojure-mode-hook ()
      ;; (add-hook 'before-save-hook 'my/cleanup-buffer nil t)
      (clj-refactor-mode 1)
      (inf-clojure-minor-mode 1)
      (paredit-mode 1)
      (rainbow-delimiters-mode 1)
      (eldoc-mode)
      ;; (smart-newline-mode 1)
      (helm-gtags-mode 1))

    (add-hook 'clojure-mode-hook 'my/clojure-mode-hook)))
