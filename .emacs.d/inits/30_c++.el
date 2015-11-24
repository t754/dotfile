(defun my:ac-c-headers-init ()
  (require 'auto-complete-c-headers)
  (flymake-mode t)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (setq-default tab-width 4 indent-tabs-mode t))
;; (local-set-key clang-format-region)
;; (bind-keys :map c++-mode-map
;;              ("M-S-i" . ac-previous))
(add-hook 'c++-mode-hook 'my:ac-c-headers-init)
(add-hook 'c-mode-hook 'my:ac-c-headers-init)

(defun clang-format-before-save ()
  "Add this to .emacs to clang-format on save
 (add-hook 'before-save-hook 'clang-format-before-save)."
  (interactive)
  (when (eq major-mode 'c++-mode) (clang-format-buffer)))

(with-eval-after-load 'c++-mode
  (require 'clang-format)
  (add-hook 'before-save-hook 'clang-format-before-save)
  ;; (add-hook 'go-mode-hook 'flycheck-mode)
  )
;; TODO:: irony mode いれたい
