(require 'expand-region)
(global-set-key (kbd "C-SPC") 'er/expand-region)
(global-set-key (kbd "C-M-SPC") 'er/contract-region) ;; リージョンを狭める
(transient-mark-mode t)
