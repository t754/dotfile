(use-package ido-vertical-mode
  :config
  (ido-vertical-mode 1)
  (setq ido-vertical-define-keys 'C-n-and-C-p-only)    ;; C-n/C-pで候補選択する
  (setq ido-vertical-show-count t)
  )
