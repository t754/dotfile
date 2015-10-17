(with-eval-after-load "imenu-list"
  (define-key imenu-list-major-mode-map (kbd "j") 'next-line)
  (define-key imenu-list-major-mode-map (kbd "k") 'previous-line)
  (setq imenu-list-focus-after-activation t
        imenu-list-auto-resize t))
