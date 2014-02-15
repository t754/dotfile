;;; helm
(require 'recentf)
(require 'helm-config)
(require 'helm-descbinds)
(helm-descbinds-mode)
;; (helm-descbinds-mode)


(setq helm-use-migemo t)
(require 'helm-ls-git)

;;;;;;;;;;;;
;; migemo ;;
;;;;;;;;;;;;
(when (and (executable-find "cmigemo")
           (require 'migemo nil t))
  (require 'helm-migemo)
  (setq migemo-command "cmigemo"
      migemo-options '("-q" "--emacs" "-i" "\g")
      migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict"
      migemo-user-dictionary nil
      migemo-regex-dictionary nil
      migemo-coding-system 'utf-8)

  (load-library "migemo")
  (migemo-init)
)


;; for cmigemo

;; C-x b で helm-for-files
;; (eval-after-load 'helm
;;   '(progn

(global-set-key (kbd "M-r") 'helm-resume)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
;; (define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "C-x b") 'helm-buffers-list)
(define-key global-map (kbd "C-x C-b") 'helm-for-files)
(define-key helm-map (kbd "C-h") 'delete-backward-char)

;; TABで任意補完。選択肢が出てきたらC-nやC-pで上下移動してから決定することも可能
;; (define-key helm-c-read-file-map (kbd "TAB") 'helm-execute-persistent-action)










