(add-hook 'c-mode-common-hook
          (lambda ()
			(local-unset-key "\)")
            (local-unset-key ">")
			(c-toggle-auto-state 1)
			(c-toggle-hungry-state 1)
			;; (define-key c-mode-map(kbd "C-c p") 'smart-compile)

			;;;; C-c e で next-error コマンドを呼び出す
            (define-key mode-specific-map "e" 'next-error)
            ;; gdb
            (setq gdb-many-windows t)
            (setq gdb-use-separate-io-buffer t)
            (add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))

            
            ;;
			(flymake-mode t)
			(define-key c-mode-map(kbd "C-c C-p") 'c-indent-defun)
            ))

(dolist (hook
         '(c-mode-hook
           c++-mode-hook))
  
  (add-hook hook
            (lambda ()
              (local-set-key [f9]
                             (lambda ()
                               (interactive)
                               (manual-entry (current-word))))
              )
            )
  )

