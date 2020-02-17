(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((go-mode . (lambda ()
                      (lsp-deferred)
                      (add-hook 'before-save-hook
                                (lambda ()
                                  (lsp-format-buffer)
                                  (lsp-organize-imports))
                                t t)
                      ))
         (python-mode . (lambda ()
                          (lsp-python-enable))))
  :config
  ;; (lsp-define-stdio-client lsp-python "python"
  ;;                          #'projectile-project-root
  ;;                          '("pyls"))
  ;; (require 'lsp-imenu)
  ;; (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)
  (use-package lsp-ui
    :ensure t
    :init
    (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
    (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
    (setq lsp-ui-doc-enable nil
          lsp-ui-peek-enable t
          lsp-ui-sideline-enable t
          lsp-ui-imenu-enable t
          lsp-ui-flycheck-enable t)
    (setq lsp-ui-sideline-ignore-duplicate t)
    :hook (lsp-mode . lsp-ui-mode)
    ;; :config
    )

  (use-package company-lsp
    :commands company-lsp
    :config
    (push 'company-lsp company-backends))
  ;; NB: only required if you prefer flake8 instead of the default
  ;; send pyls config via lsp-after-initialize-hook -- harmless for
  ;; other servers due to pyls key, but would prefer only sending this
  ;; when pyls gets initialised (:initialize function in
  ;; lsp-define-stdio-client is invoked too early (before server
  ;; start)) -- cpbotha
  (defun lsp-set-cfg ()
    (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
      ;; TODO: check lsp--cur-workspace here to decide per server / project
      (lsp--set-configuration lsp-cfg)))

  (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg))
