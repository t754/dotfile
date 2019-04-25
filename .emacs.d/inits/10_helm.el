;;; helm
(require 'recentf)
(require 'helm-config)
(require 'helm-descbinds)

(helm-descbinds-mode)

(setq recentf-exclude '("/.mozilla/firefox/" "^/tmp/" "~$"
                        "/TAGS$" "/var/tmp/" "/.git/" "/.cask/"
                        "recentf" )
      recentf-max-menu-items 700
      recentf-max-saved-items 700
      recentf-auto-cleanup 600
      recentf-count 0
      helm-use-migemo t
      helm-M-x-fuzzy-match t
      helm-delete-minibuffer-contents-from-point t
      helm-for-files-preferred-list '(helm-source-buffers-list
                                      helm-source-recentf
                                      helm-source-bookmarks
                                      helm-source-file-cache
                                      helm-source-files-in-current-dir
                                      ;; 必要とあれば
                                      helm-source-bookmark-set
                                      helm-source-locate))
(require 'recentf-ext)

(run-at-time t 600 'recentf-save-list)
(recentf-mode 1)
;; (require 'helm-git)
(require 'helm-ls-git)
(helm-autoresize-mode)
;;;;;;;;;;;;
;; migemo ;;
;;;;;;;;;;;;
(when (and (executable-find "cmigemo")
           (require 'migemo nil t)
           (locate-library "migemo"))
  (require 'helm-migemo)
  (setq migemo-command "cmigemo"
        migemo-options '("-q" "--emacs" "-i" "\g")
        migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict"
        migemo-user-dictionary nil
        migemo-regex-dictionary nil
        migemo-coding-system 'utf-8-unix)
  (load-library "migemo")
  (migemo-init)
  ;; この修正が必要
  (eval-after-load "helm-migemo"
    '(defun helm-compile-source--candidates-in-buffer (source)
       (helm-aif (assoc 'candidates-in-buffer source)
           (append source
                   `((candidates
                      . ,(or (cdr it)
                             (lambda ()
                               ;; Do not use `source' because other plugins
                               ;; (such as helm-migemo) may change it
                               (helm-candidates-in-buffer (helm-get-current-source)))))
                     (volatile) (match identity)))
         source))))
(setq ibus-isearch-cursor-type 'hollow)

;; (require 'helm-w3m) ; 情報源の定義元をrequire
;; (push '(migemo) helm-source-w3m-bookmarks)

;; for cmigemo

;; C-x b で helm-for-files
;; (eval-after-load 'helm
;;   '(progn
;; ("C-x c i" . helm-imenu)

(global-set-key (kbd "M-x") 'helm-M-x)



(bind-keys :map helm-map
           ;; ("C-h" . delete-backward-char)
           ;; ("C-z" . scroll-down-command)
           ("C-u C-z" . helm-buffer-run-kill-buffers)
           ("<tab>" . helm-execute-persistent-action)
           ("C-i" . helm-execute-persistent-action))

;; (define-key global-map (kbd "C-x C-g") 'helm-git-find-file)
