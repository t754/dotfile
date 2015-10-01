(add-hook 'c++-mode-hook
          (lambda ()
            ;; (define-key c++-mode-map(kbd "C-c d") 'my-insert-printf-debug)
            (flymake-mode t)
            ;; (define-key c-mode-map(kbd "C-c p") 'smart-compile)
            (setq-default tab-width 4 indent-tabs-mode t)
            ;; (setq tab-width 4)
            ))










