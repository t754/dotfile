(require 'magit)
(require 'git-gutter)
;; (global-git-gutter-mode +1)
(add-hook 'ruby-mode-hook 'git-gutter-mode)
(add-hook 'c-mode-hook 'git-gutter-mode)
(add-hook 'python-mode-hook 'git-gutter-mode)
(add-hook 'c++-mode-hook 'git-gutter-mode)
(global-set-key (kbd "C-x C-g") 'git-gutter:toggle)
(global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)
;; Stage current hunk
(global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)
;; Revert current hunk
(global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)

;; (add-hook 'ruby-mode-hook 'git-gutter-mode)
;; (add-hook 'python-mode-hook 'git-gutter-mode)

 ;;;;;;;;;;;;;;;;;;;;;;;;
 ;; 何故か ediffの設定 ;;
 ;;;;;;;;;;;;;;;;;;;;;;;;
;; コントロール用のバッファを同一フレーム内に表示
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; diffのバッファを上下ではなく左右に並べる
(setq ediff-split-window-function 'split-window-horizontally)




