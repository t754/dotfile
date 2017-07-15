;; go get -u github.com/nsf/gocode
;; go get -u github.com/dougm/goflymake
;; go get -u golang.org/x/tools/cmd/goimports
;; go get -u github.com/alecthomas/gometalinter && gometalinter --install


(defun go-mode-hooks ()
  (go-eldoc-setup)
  (flycheck-mode)
  (auto-complete-mode -1)
  (company-mode t)
  (setq company-backends '(company-go)))



(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-gometalinter-setup))




(load-file "~/.go/src/github.com/nsf/gocode/emacs-company/company-go.el")
(require 'company-go)
(with-eval-after-load 'go-mode
  ;; (load-file "~/.go/src/github.com/nsf/gocode/emacs/go-autocomplete.el")
  ;; (require 'go-autocomplete)
  ;; (require 'auto-complete-config)
  ;; (ac-config-default)

  ;; skips 'vendor' directories and sets GO15VENDOREXPERIMENT=1
  (setq flycheck-gometalinter-vendor t)
  ;; only run fast linters
  (setq flycheck-gometalinter-fast t)
  ;; use in tests files
  (setq flycheck-gometalinter-tets t)
  ;;disable linters
  (setq flycheck-gometalinter-disable-linters '("gotype" "gocyclo"))
  ;;Only enable selected linters
  (setq flycheck-gometalinter-disable-all t)
  (setq flycheck-gometalinter-enable-linters '("golint"))

  (setq company-tooltip-limit 20)                      ; bigger popup window
  (setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
  (setq company-echo-delay 0)                          ; remove annoying blinking
  (setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing)

  (setq gofmt-command "goimports")
  (define-key go-mode-map (kbd "M-.") 'godef-jump)
  (define-key go-mode-map (kbd "C-c C-r") 'go-remove-unused-imports))

(add-hook 'go-mode-hook 'go-mode-hooks)
(add-hook 'before-save-hook 'gofmt-before-save)
