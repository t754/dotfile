
(setq eldoc-idle-delay 0.20
      eldoc-echo-area-use-multiline-p t)
(defun elisp-hooks ()
   "elisp hook function"
   (rainbow-delimiters-mode t)
   (turn-on-eldoc-mode t))
(add-hook 'emacs-lisp-mode-hook 'elisp-hooks)
(add-hook 'lisp-interaction-mode-hook 'elisp-hooks)
(add-hook 'ielm-mode-hook 'elisp-hooks)
;; (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)
