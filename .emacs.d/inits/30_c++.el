(defun my:ac-c-headers-init ()
  (require 'auto-complete-c-headers)
  (flymake-mode t)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (setq-default tab-width 4 indent-tabs-mode t))

(add-hook 'c++-mode-hook 'my:ac-c-headers-init)
(add-hook 'c-mode-hook 'my:ac-c-headers-init)

;; TODO:: irony mode いれたい
