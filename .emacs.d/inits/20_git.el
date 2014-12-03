(require 'magit)
(require 'git-gutter-fringe)
(global-git-gutter-mode)
(setq git-gutter-fr:side 'right-fringe)
(global-set-key (kbd "C-x C-g") 'git-gutter)

;;  ;;;;;;;;;;;;;;;;;;;;;;;;
;;  ;; 何故か ediffの設定 ;;
;;  ;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; コントロール用のバッファを同一フレーム内に表示
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; ;; diffのバッファを上下ではなく左右に並べる
(setq ediff-split-window-function 'split-window-horizontally)

