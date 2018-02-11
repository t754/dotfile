(use-package rust-mode
  :defer t
  :init
  (setq rust-format-on-save t)
  :config
  (use-package racer-mode
    :bind (:map rust-mode-map
                ("M-." . racer-find-definition))
    :init
    (setq company-tooltip-align-annotations t)
    (setq racer-rust-src-path (or (getenv "RUST_SRC_PATH")
                                  (concat  (shell-command-to-string "rustc --print sysroot | tr -d '\n'")
                                           "/lib/rustlib/src/rust/src")))
    :config
    (racer-turn-on-eldoc t))
  (use-package flycheck-rust)
  (add-hook 'rust-mode-hook  #'(lambda ()
                                 (flycheck-mode)
                                 (racer-mode)
                                 (flycheck-rust-setup))))
