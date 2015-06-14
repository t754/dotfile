;; ;;elscreen設定
;; (global-unset-key "\C-o")
;; (setq elscreen-prefix-key (kbd "C-o"))
;; (elscreen-start)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;auto-complete
;; (require 'auto-complete)
;; (require 'auto-complete-config)
;; ;; グローバルでauto-completeを利用
;; (require 'ac-helm)
;; (global-auto-complete-mode t)



;;(setq ac-auto-start nil)
;;勝手に初まらない;(setq ac-ignore-case 'smart)										

(with-eval-after-load "auto-complete"
  (setq ac-use-menu-map t
      ac-dwim nil  ; 空気読んでほしいをnil
      ac-auto-start t 
      ac-ignore-case t)

  (global-set-key (kbd "C-:") 'ac-complete-with-helm)
  (define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)
  (bind-keys :map ac-menu-map
             ("M-n" . ac-next)
             ("M-p" . ac-previous))
  (bind-keys :map ac-mode-map
             ("M-TAB" . auto-complete)
             ("C-i" . (lambda (arg)
                        (interactive "p")
                        (case arg
                          (4 (ac-complete-with-helm))
                          (t (auto-complete))))))
  ;TABで大体補完
  (ac-set-trigger-key "TAB"))



(add-hook 'after-init-hook 'ac-config-default)




