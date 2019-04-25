(global-git-commit-mode +1)
(require 'magit)

(require 'git-gutter+)


(global-git-gutter+-mode)

(bind-keys :map global-map
             ("C-x C-g" . git-gutter+-mode)
             ("C-x v =" . git-gutter+-show-hunk)
             ("C-x n"   . git-gutter+-next-hunk)
             ("C-x p"   . git-gutter+-previous-hunk)
             ("C-x v r" . git-gutter+-revert-hunk)
             ("C-x g"   . magit-status))
(smartrep-define-key goto-map "C-g"
  '(("n"      . git-gutter+-next-hunk)
    ("p"      . git-gutter+-previous-hunk)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; 何故か ediffの設定 ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; コントロール用のバッファを同一フレーム内に表示
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; ;; diffのバッファを上下ではなく左右に並べる
(setq ediff-split-window-function 'split-window-horizontally)
