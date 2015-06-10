;; (electric-pair-mode)
(require 'smartparens-config)
(smartparens-global-mode)
(sp-local-pair 'org-mode "$" "$")
(sp-local-pair 'org-mode "\\[" "\\]")

;; (require 'rainbow-delimiters)
;(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)



;; (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;; ;(global-rainbow-delimiters-mode)
;; (require 'cl-lib)
;; (require 'color)
;; (cl-loop
;;  for index from 1 to rainbow-delimiters-max-face-count
;;  do
;;  (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
;;    (cl-callf color-saturate-name (face-foreground face) 50)))
