;; ;;elscreen設定
;; (global-unset-key "\C-o")
;; (setq elscreen-prefix-key (kbd "C-o"))
;; (elscreen-start)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;auto-complete
(when (require 'auto-complete nil t)
  (require 'auto-complete-config)
;; グローバルでauto-completeを利用
  (require 'ac-helm)
(global-auto-complete-mode t)
  ;(ac-config-default)
(global-set-key (kbd "C-:") 'ac-complete-with-helm)
(define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)
;;(global-auto-complete-mode t)
  (ac-config-default)

  (setq ac-use-menu-map t)

  (define-key ac-menu-map (kbd "M-n") 'ac-next)      ; M-nで次候補選択
  (define-key ac-menu-map (kbd "M-p") 'ac-previous)  ; M-pで前候補選択
  (setq ac-dwim nil)  ; 空気読んでほしいをnil
  ;; 情報源として
  ;;(setq ac-auto-start nil) ;勝手に初まらない
 
  (setq ac-auto-start t)
										;(ac-set-trigger-key "))  ; TABで補完開始(トリガーキー)
  ;; or
  (setq ac-ignore-case t)
										;(setq ac-ignore-case 'smart)
(ac-set-trigger-key "TAB") ;TABで大体補完
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete) ) ; M-TABで補完開始

