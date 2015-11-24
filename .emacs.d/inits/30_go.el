
;; (require 'auto-complete-config)

;; go get -u github.com/dougm/goflymake
;; go get golang.org/x/tools/cmd/goimports


(with-eval-after-load 'go-mode
  (add-to-list 'load-path "/home/ztama/.go/src/github.com/dougm/goflymake/")
  (require 'go-flymake)
  (require 'go-autocomplete)
  (setq gofmt-command "goimports")
  (add-hook 'go-mode-hook 'go-eldoc-setup)

  (add-hook 'before-save-hook 'gofmt-before-save)
  (flymake-cursor-mode 1)

  ;; (add-hook 'go-mode-hook 'flycheck-mode)

  (define-key go-mode-map (kbd "M-.") 'godef-jump)
  (define-key go-mode-map (kbd "C-c C-r") 'go-remove-unused-imports))



;; (flycheck-add-next-checker 'go-golint
;;                            'go-gofmt)
