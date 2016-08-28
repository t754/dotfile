;; go get -u github.com/dougm/goflymake
;; go get -u golang.org/x/tools/cmd/goimports
;; go get -u github.com/alecthomas/gometalinter && gometalinter --install


(defun go-mode-hooks ()
  (go-eldoc-setup)
  (flycheck-mode)
  (set (make-local-variable 'company-backends) '(company-go))
  (company-mode))

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-gometalinter-setup))

;; ;; skips 'vendor' directories and sets GO15VENDOREXPERIMENT=1
;; (setq flycheck-gometalinter-vendor t)
;; ;; only run fast linters
;; (setq flycheck-gometalinter-fast t)
;; ;; use in tests files
;; (setq flycheck-gometalinter-tets t)
;; disable linters
;; (setq flycheck-gometalinter-disable-linters '("gotype" "gocyclo"))
;; Only enable selected linters
;; (setq flycheck-gometalinter-disable-all t)
;; (setq flycheck-gometalinter-enable-linters '("golint"))

(with-eval-after-load 'go-mode
  (load-file "~/.go/src/github.com/nsf/gocode/emacs-company/company-go.el")
  ;;(setq gofmt-command "goimports")
  (add-hook 'go-mode-hook 'go-mode-hooks)
  (add-hook 'before-save-hook 'gofmt-before-save)
  (define-key go-mode-map (kbd "M-.") 'godef-jump)
  (define-key go-mode-map (kbd "C-c C-r") 'go-remove-unused-imports))
