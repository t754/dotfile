(use-package markdown-mode
  :ensure t
  :mode (;; ("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "markdown-it"))
;; (setq markdown-command "markdown_py") ;; pip install Markdown
