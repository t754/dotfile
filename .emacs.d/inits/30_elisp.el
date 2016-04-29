(require 'elisp-format)
(setq eldoc-idle-delay 0.20
      eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)
