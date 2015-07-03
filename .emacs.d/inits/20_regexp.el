(require 'visual-regexp-steroids)
(setq vr/engine 'python)                ;python regexpならばこれ
;; (setq vr/engine 'pcre2el)               ;elispでPCREから変換
(global-set-key (kbd "M-%") 'vr/query-replace)
;; multiple-cursorsを使っているならこれで
;; (global-set-key (kbd "C-c m") 'vr/mc-mark)
;; 普段の正規表現isearchにも使いたいならこれを
(global-set-key (kbd "C-M-r") 'vr/isearch-backward)
(global-set-key (kbd "C-M-s") 'vr/isearch-forward)
