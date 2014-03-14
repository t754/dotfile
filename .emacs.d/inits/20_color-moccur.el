;; (require 'moccur-edit nil t)
(require 'helm-ag);;agg
(require 'helm-config) 
(require 'all-ext)
(setq helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
(setq helm-ag-thing-at-point 'symbol)


(global-set-key (kbd "M-o") 'helm-occur) ;; helm-occurの起動
(define-key isearch-mode-map (kbd "C-o") 'helm-occur-from-isearch) ;; isearchからhelm-occurを起動
(define-key helm-map (kbd "C-c C-a") 'all-from-helm-occur) ;; helm-occurからall-extに受け渡し
(setq helm-ag-command-option "--all-text")
(setq helm-ag-thing-at-point 'symbol)
(global-set-key (kbd "C-o .") 'helm-ag-pop-stack);;
(global-set-key (kbd "C-o C-o") 'helm-ag-this-file);;;;;
(global-set-key (kbd "C-M-o") 'helm-ag)

