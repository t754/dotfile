
;; (require 'auto-complete-config)

;; go get -u github.com/dougm/goflymake
(add-hook 'before-save-hook 'gofmt-before-save)
(add-to-list 'load-path "/home/ztama/.go/src/github.com/dougm/goflymake/")


(with-eval-after-load 'go-mode
  (require 'go-autocomplete)
  (require 'go-flymake)
  (add-hook 'go-mode-hook 'go-eldoc-setup)
  ;; (add-hook 'go-mode-hook 'flycheck-mode)
  
  (define-key go-mode-map (kbd "M-.") 'godef-jump)
  (define-key go-mode-map (kbd "C-c C-r") 'go-remove-unused-imports))



;; (flycheck-add-next-checker 'go-golint
;;                            'go-gofmt)
