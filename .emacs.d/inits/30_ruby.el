;;; (add-hook 'ruby-mode-hook
;;;  '(lambda ()
;; 	;;C-m 改行&インデント
;; 	(define-key ruby-mode-map (kbd "C-m") 'newline-and-indent)
;; 	;; (define-key ruby-mode-map (kbd "C-c p") 'smart-compile
;; 	))

(eval-after-load "ruby-mode"
  '(progn
     (require 'smartparens-ruby)
     ;; (flycheck-mode 1)
     ;; (set-face-attribute 'sp-show-pair-match-face nil
     ;;                     :background "grey20" :foreground "green"
     ;;                     :weight 'semi-bold)
     ))
(add-hook 'ruby-mode-hook '(lambda()  (show-smartparens-mode) (flycheck-mode) ))

