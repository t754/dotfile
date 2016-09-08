(defun c-mode-common-hooks ()
  (local-unset-key "\)")
  (local-unset-key ">")
  (c-toggle-auto-state 1)
  ;; (set (make-local-variable 'eldoc-idle-delay) 0.05)
  ;; (c-turn-on-eldoc-mode)
  ;; (define-key c-mode-map(kbd "C-c p") 'smart-compile)
            ;;;; C-c e で next-error コマンドを呼び出す
  (define-key mode-specific-map "e" 'next-error)
  ;; gdb
  (setq gdb-many-windows           t
        gdb-use-separate-io-buffer t)
  (add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))
  (set (make-local-variable 'eldoc-idle-delay) 0.20))

(add-hook 'c-mode-common-hook 'c-mode-common-hooks)


(dolist (hook '(c-mode-hook
                c++-mode-hook))
  (add-hook hook
            (lambda () (local-set-key [f9]
                             (lambda ()
                               (interactive)
                               (manual-entry (current-word)))))))
