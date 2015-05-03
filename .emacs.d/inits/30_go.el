
;; (require 'auto-complete-config)

(add-hook 'before-save-hook 'gofmt-before-save)
(eval-after-load '(progn
                    (require 'go-autocomplete)
                    (add-hook 'go-mode-hook 'go-eldoc-setup)
                    (define-key go-mode-map (kbd "M-.") 'godef-jump)
                    (define-key go-mode-map (kbd "C-c C-r") 'go-remove-unused-imports)
                    ))


(flycheck-add-next-checker 'go-golint
                           'go-gofmt)
