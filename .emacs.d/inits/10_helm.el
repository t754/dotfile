;;; helm
(require 'recentf)
(require 'helm-config)
(require 'helm-descbinds)

(helm-descbinds-install)
(helm-descbinds-mode)

(setq recentf-exclude '("/dotfile/.emacs.d/" "/.mozilla/firefox/" "^/tmp/" "~$" )
      recentf-max-menu-items 200
      recentf-max-saved-items 200
      recentf-count 0
      helm-use-migemo t
      helm-delete-minibuffer-contents-from-point t)
;; (require 'helm-git)
;; (require 'helm-ls-git)

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
  (migemo-init))

;; for cmigemo

;; C-x b で helm-for-files
;; (eval-after-load 'helm
;;   '(progn
(bind-keys* 
 ("M-r"     . helm-resume)
 ("M-y"     . helm-show-kill-ring)
 ("C-<f6>"  . helm-ls-git-ls)
 ("C-x C-r" . helm-recentf)
 ("C-x b"   . helm-buffers-list)
 ("C-x C-b" . helm-for-files)
 ;; ("C-x c i" . helm-imenu)
 )
(global-set-key (kbd "M-x") 'helm-M-x)
 
;; (define-key global-map (kbd "C-x C-f") 'helm-find-files)

(bind-keys :map helm-map 
           ;; ("C-h" . delete-backward-char)
           ;; ("C-z" . scroll-down-command)
           ("C-u C-z" . helm-buffer-run-kill-buffers))


;; (define-key global-map (kbd "C-x C-g") 'helm-git-find-file)

;; TABで任意補完。選択肢が出てきたらC-nやC-pで上下移動してから決定することも可能
;; (define-key helm-c-read-file-map (kbd "TAB") 'helm-execute-persistent-action)










