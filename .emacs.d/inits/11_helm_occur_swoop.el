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
;; Save bufer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)
(custom-set-variables
 '(ace-isearch-input-length 5)
 '(ace-isearch-input-idle-delay 0.3))

;; 値がtの場合はウィンドウ内に分割、nilなら別のウィンドウを使用
(setq helm-swoop-split-with-multiple-windows nil)

(global-unset-key "\C-o")
(setq helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
(setq helm-ag-thing-at-point 'symbol)

(global-set-key (kbd "M-o") '(lambda () (interactive)
   (setq truncate-lines nil)
   (helm-occur)))                   ;; helm-occurの起動


(setq helm-ag-command-option "--all-text")
(setq helm-ag-thing-at-point 'symbol)

;;;; C-u 4 M-x helm-swoop ← で 4行まとめ検索
(global-set-key (kbd "M-i") 'helm-swoop)
(define-key isearch-mode-map (kbd "C-h") 'delete-backward-char)
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)

(define-key isearch-mode-map (kbd "C-o") 'helm-occur-from-isearch) ;; isearchからhelm-occurを起動
(define-key helm-map (kbd "C-c C-a") 'all-from-helm-occur) ;; helm-occurからall-extに受け渡し
(global-set-key (kbd "C-o .") 'helm-ag-pop-stack);;
(global-set-key (kbd "C-o C-o") 'helm-ag-this-file);;;;;
(global-set-key (kbd "C-M-o") 'helm-ag)
;; M-n で現在地にある文字を入力


