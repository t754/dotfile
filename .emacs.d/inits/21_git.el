(global-git-commit-mode +1)
(require 'magit)

;; (require 'git-gutter)
;;;; (require 'git-gutter-fringe)
;;;; (setq git-gutter-fr:side 'right-fringe)
;;
(custom-set-variables
 '(git-gutter:modified-sign "X") ;; two space
 '(git-gutter:added-sign "A")    ;; multiple character is OK
 '(git-gutter:deleted-sign "D")
 '(git-gutter:unchanged-sign nil)
 '(git-gutter:update-interval 2)
 '(git-gutter:window-width 1)
 '(git-gutter:lighter "_GG")
 '(git-gutter:handled-backends '(git hg)))


(bind-keys :map global-map
             ("C-x C-g" . git-gutter:toggle)
             ("C-x v =" . git-gutter:popup-hunk)
             ("C-x p" . git-gutter:previous-hunk)
             ("C-x n" . git-gutter:next-hunk)
             ("C-x v s" . git-gutter:stage-hunk)
             ("C-x v r" . git-gutter:revert-hunk)
             ("C-x g" . magit-status))
(smartrep-define-key goto-map "M-f"
  '(("n"      . 'git-gutter:next-hunk)
    ("p"      . 'git-gutter:previous-hunk)))

(global-git-gutter-mode t)
(git-gutter:linum-setup)


;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; 何故か ediffの設定   ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; コントロール用のバッファを同一フレーム内に表示
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; ;; diffのバッファを上下ではなく左右に並べる
(setq ediff-split-window-function 'split-window-horizontally)
