(require 'google-translate)
(require 'google-translate-smooth-ui)
;; (global-set-key "\C-ct" 'google-translate-at-point)
;; (global-set-key "\C-cT" 'google-translate-query-translate)
(global-set-key "\C-ct" 'google-translate-smooth-translate)

(setq google-translate-output-destination nil
      google-translate-translation-directions-alist '(("en" . "ja") ("ja" . "en")))
;; (setq google-translate-pop-up-buffer-set-focus t)
(push '("*Google Translate*" :height 0.4) popwin:special-display-config )




