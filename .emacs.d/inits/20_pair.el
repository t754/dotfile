;; (electric-pair-mode)
(require 'smartparens-config)
(smartparens-global-mode)
(sp-local-pair 'org-mode "$" "$")
(sp-local-pair 'org-mode "\\[" "\\]")

