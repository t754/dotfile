(require 'magit)

(require 'git-gutter)
;;;; (require 'git-gutter-fringe)
;;;; (setq git-gutter-fr:side 'right-fringe)
(global-git-gutter-mode t)
(global-set-key (kbd "C-x C-g") 'git-gutter)
(git-gutter:linum-setup)
(global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)
;; (custom-set-variables
;;  '(git-gutter:handled-backends '(git hg )))
(custom-set-variables
 '(git-gutter:handled-backends '(git hg bzr)))



;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; 何故か ediffの設定   ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; コントロール用のバッファを同一フレーム内に表示
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; ;; diffのバッファを上下ではなく左右に並べる
(setq ediff-split-window-function 'split-window-horizontally)


