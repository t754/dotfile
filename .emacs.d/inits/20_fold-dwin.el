(when (require 'fold-dwim nil t)
  (require 'hideshow nil t)
  ;; 機能を利用するメジャーモード一覧
  (let ((hook))
    (dolist (hook
             '(emacs-lisp-mode-hook
               c-mode-common-hook
               python-mode-hook
               php-mode-hook
               ruby-mode-hook
               js2-mode-hook
               css-mode-hook
               apples-mode-hook))
      (add-hook hook 'hs-minor-mode))))


(require 'fold-dwim)
(global-set-key (kbd "<f7>")      'fold-dwim-toggle)
(global-set-key (kbd "<M-f7>")    'fold-dwim-hide-all)
(global-set-key (kbd "<S-M-f7>")  'fold-dwim-show-all)
(add-hook 'python-mode-hook 'hs-minor-mode)
