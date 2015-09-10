;; ;;anything設定
(eval-after-load "anything"
  '(define-key anything-map (kbd "C-h") 'delete-backward-char))
;; (when (require 'anything nil t)
;; ;;  (require 'anything-startup)
;;   ;(require 'recentf-ext)
;;   (global-set-key (kbd "C-x C-b") 'anything-filelist+)
;;   (global-set-key (kbd "M-y") 'anything-show-kill-ring)
;;   (setq
;;    anything-idle-delay 0.3
;;    anything-input-idle-delay 0.2
;;    anything-andidate-number-limit 100
;;    anything-quick-update t
;;    anything-enable-shortcuts 'alphabet)
;;   (when (require 'anything-config nil t)
;;  (setq anything-su-or-sudo "sudo")
;; (setq anything-sources (list anything-c-source-buffers
;;                              anything-c-source-bookmarks
;;                              anything-c-source-recentf
;;                              anything-c-source-file-name-history
;;                              anything-c-source-locate))  )
;;   (require 'anything-match-plugin nil t)
;;   (when (and (executable-find "cmigemo")
;;           (ewquire 'migemo nil t))
;;  (require 'anything-migemo nil t))
;;   (when(require 'anything-complete nil t)
;;  (anything-lisp-complete-symbol-set-timer 150))
;;   (require 'anything-show-completion nil t)
;;   (when (require 'auto-install nil t)
;;  (require 'anything-auto-install))
;;  (when (require 'descbinds-anything nil t)
;;   (descbinds-anything-install)))
;; (global-set-key (kbd "C-}") 'anything)

;; ;;ファイルアクセスの覆歴
;; (when (require 'recentf nil t)
;;   (setq-default find-file-visit-truename t)
;;   (setq recentf-max-saved-items 2000)
;;   (setq recentf-exclude '(".recentf"))
;;   (setq recentf-auto-cleanup 10)
;;   (setq recentf-auto-save-timer
;;         (run-with-idle-timer 30 t 'recentf-save-list))
;;   (recentf-mode 1)
;;   (require 'recentf-ext))


;;
;;------------------------------------------
;(require 'one-key)
;(require 'one-key-default) ; one-key.el も一緒に読み込んでくれる
;(require 'one-key-config) ; one-key.el をより便利にする
;(one-key-default-setup-keys) ; one-key- で始まるメニュー使える様になる
;(define-key global-map " " 'one-key-menu-C-x) ;; C-x にコマンドを定義
