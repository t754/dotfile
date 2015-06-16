;; (require 'moccur-edit nil t)
(require 'helm-ag);;agg
(require 'helm-config) 
(require 'all-ext)
(require 'helm-swoop)
(require 'ace-isearch)

;; (require 'color-moccur)
;; (require 'helm-c)
;; (require 'helm-c-moccur)
;; (global-set-key (kbd "C-s") 'helm-swoop)
;; (global-set-key (kbd "C-r") 'helm-swoop-back-to-last-point)

(global-ace-isearch-mode +1)

(custom-set-variables
 '(ace-isearch-input-length 5)
 '(ace-isearch-input-idle-delay 1))

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
(global-set-key (kbd "M-i") 'helm-swoop)
(bind-keys :map isearch-mode-map 
           ("M-i" . helm-swoop-from-isearch)
           ("C-o" . helm-occur-from-isearch)) ;; isearchからhelm-occurを起動
(unbind-key "C-o")
(bind-key   "C-c C-a" 'all-from-helm-occur helm-map) ;; helm-occurからall-extに受け渡し
(bind-keys*
 ("M-o"     . myfix-helm-occur)             ;; helm-occurの起動
 ("C-o ."   . helm-ag-pop-stack);;
 ("C-o C-o" . helm-ag-this-file);;;;;
 ("C-M-o"   . helm-ag))
;; M-n で現在地にある文字を入力


