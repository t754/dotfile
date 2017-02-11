(defun rust-mode-hooks ()
  (racer-mode t)
  (company-mode t)
  (eldoc-mode t)
  (racer-turn-on-eldoc t)
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (flycheck-mode t)
  ;; (set (make-local-variable 'company-backends)
  ;;      '(company-racer)
  )

(with-eval-after-load 'rust
  (bind-keys :map rust-mode-map
             ("M-." . racer-find-definition)
             ("TAB" . racer-complete-or-indent)))
(setq racer-rust-src-path "~/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src")

(add-hook 'rust-mode-hook 'rust-mode-hooks)
