;; ;; (require 'moccur-edit nil t)
;; (require 'helm-ag);;agg
;; (require 'helm-config)
;; (require 'all-ext)
(require 'helm-swoop)
;; (require 'ace-isearch)

;; (require 'color-moccur)
;; (require 'helm-c)
;; (require 'helm-c-moccur)
;; (global-set-key (kbd "C-s") 'helm-swoop)
;; (global-set-key (kbd "C-r") 'helm-swoop-back-to-last-point)


;; 値がtの場合はウィンドウ内に分割、nilなら別のウィンドウを使用
(setq helm-swoop-split-with-multiple-windows nil
      helm-multi-swoop-edit-save t
      helm-ag-base-command "ag --nocolor --nogroup --ignore-case"
      helm-ag-thing-at-point 'symbol
      helm-ag-command-option "--all-text"
      helm-ag-thing-at-point 'symbol)

(defun myfix-helm-occur ()
  (interactive)
  (let ((line truncate-lines))
    (setq truncate-lines nil)
    (helm-occur)
    (setq truncate-lines line)))




;;;; C-u 4 M-x helm-swoop ← で 4行まとめ検索
;; (global-set-key (kbd "M-i") 'helm-swoop)
(bind-keys :map isearch-mode-map
           ;; ("M-j" . helm-swoop-from-isearch)
           ;; ("M-j" . avy-isearch)
		   ("M-i" . helm-swoop-from-isearch)
           ("C-o" . helm-occur-from-isearch))
;; isearchからhelm-occurを起動
;; (unbind-key "C-o")

(bind-keys :map helm-swoop-map
		   ("C-r" . helm-previous-line)
		   ("C-s" . helm-next-line)
		   ("M-i" .helm-multi-swoop-all-from-helm-swoop))
;; (bind-keys :map  helm-map
;; 		   ("C-c C-a" . all-from-helm-occur )) ;; helm-occurからall-extに受け渡し
(bind-keys*
 ("C-c M-o" . myfix-helm-occur)             ;; helm-occurの起動
 ("M-o"     . helm-swoop)
 ("C-c M-i" . helm-multi-swoop)
 ("C-M-o"   . my/grep))

(defun my/grep ()
  (interactive)
  (if (magit-toplevel)
      (helm-git-grep) (helm-ag)))

(bind-keys :map helm-multi-swoop-map
		   ("C-r" . helm-previous-line)
		   ("C-s" . helm-next-line))
