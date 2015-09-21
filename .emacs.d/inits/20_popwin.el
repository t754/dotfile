(when (require 'popwin nil t)
  (popwin-mode 1)
  (setq pop-up-windows nil
        helm-samewindow nil
        anything-samewindow nil
        display-buffer-function 'popwin:display-buffer
        popwin:special-display-config '(("*compilatoin*" :noselect t)
                                        ("*Compilatoin*" :noselect t)
                                        ("helm" :regexp t :height 0.5)
                                        (direx:direx-mode :position left :width 25 :dedicated t)))

  ;; (push '("helm" :regexp t :height 0.5) popwin:special-display-config)
  ;; (push '("anything" :regexp t :height 0.5) popwin:special-display-config)
  ;; (push '("*compilation*" :height 0.4 :noselect t :stick t) popwin:special-display-config)
  (global-set-key (kbd "M-z") popwin:keymap))

;; (push '
;;       popwin:special-display-config)
