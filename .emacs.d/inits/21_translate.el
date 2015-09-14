(require 'google-translate)
(require 'google-translate-smooth-ui)
;; (global-set-key "\C-ct" 'google-translate-at-point)
;; (global-set-key "\C-cT" 'google-translate-query-translate)
(bind-keys*
 ("C-c t"       .   google-translate-smooth-translate)
 ("C-c C-t"     .   my/codic))
(defun my/codic ()
  (interactive)
  (let ((my/codic-word
         (if (use-region-p)
             (google-translate--strip-string
              (buffer-substring-no-properties (region-beginning) (region-end)))
           (current-word t t))))
    (codic (read-string "(codic)Keyword: " my/codic-word 'codic--history))))


(setq google-translate-output-destination nil
      google-translate-translation-directions-alist '(("en" . "ja") ("ja" . "en")))
;; (setq google-translate-pop-up-buffer-set-focus t)
(push '("*Google Translate*" :height 0.4) popwin:special-display-config)
