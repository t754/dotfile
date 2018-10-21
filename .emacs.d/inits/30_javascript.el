(use-package js2-mode
  :mode "\\.js\\'"
  :defer t
  ;;:init
  ;; (add-to-list 'company-backends 'company-tern)
  ;; :bind (:map js2-mode-map ("C-k" . js2r-kill))
  )

(setq js-indent-level 2)
(use-package js2-refactor
    :defer t
    :hook (js2-mode . js2-refactor-mode)
    :config
    (js2r-add-keybindings-with-prefix "C-c C-m"))

(use-package xref-js2
    :defer t
    :hook (xref-backend-functions . xref-js2-xref-backend))

(use-package indium
  :defer t
  :commands (indium-interaction-mode)
  :hook (js2-mode . (indium-interaction-mode)))

;; (use-package tern
;;     :defer t
;;     :hook js2-mode . (tern-mode 1))


;; (use-package company-tern
;;     :defer t
;;     ;; :hook
;;     :config
;;     (setq company-tern-property-marker "<J>")
;;     (add-to-list 'company-backends 'company-tern)
;;     (setq company-tooltip-align-annotations t))
