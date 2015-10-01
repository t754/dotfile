;;; Emacs標準のctagsでは動作しない！！
(setq ctags-update-command "/usr/bin/ctags")
;;; 使う言語で有効にしよう
;; (add-hook 'c-mode-common-hook  'turn-on-ctags-auto-update-mode)
;; (add-hook 'emacs-lisp-mode-hook  'turn-on-ctags-auto-update-mode)
