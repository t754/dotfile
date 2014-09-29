(require 'google-translate)
(require 'google-translate-smooth-ui)
;; (global-set-key "\C-ct" 'google-translate-at-point)
;; (global-set-key "\C-cT" 'google-translate-query-translate)
(global-set-key "\C-ct" 'google-translate-smooth-translate)

(setq google-translate-output-destination 'echo-area)

(setq google-translate-translation-directions-alist '(("en" . "ja") ("ja" . "en")))



