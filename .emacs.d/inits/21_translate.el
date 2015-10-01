(require 'google-translate)
(require 'google-translate-smooth-ui)
;; (global-set-key "\C-ct" 'google-translate-at-point)
;; (global-set-key "\C-cT" 'google-translate-query-translate)
(bind-keys*
 ("C-c t"       .   google-translate-smooth-translate)
 ("C-c C-t"     .   my/codic)
 ("C-c T"       .   search-web-dwim))
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


(require 'search-web)

;; (defadvice w3m-browse-url (around w3m-browse-url-popwin activate)
;;    (save-window-excursion ad-do-it)
;;    (unless (get-buffer-window "*w3m*")
;;      (pop-to-buffer "*w3m*")))
;; (push '("*w3m*" :height 0.4) popwin:special-display-config)

;; (defadvice eww-render (around eww-render-popwin activate)
;;   (interactive)
;;   (savee-window-excursion ad-do-it)
;;   (unless (get-buffer-window "*eww*")
;;     (pop-to-buffer "*eww*")))
;; (push '("*Google Translate*" :height 0.4) popwin:special-display-config)
;; (push '("*eww*" :height 0.4)  popwin:special-display-config)



(custom-set-variables
'(search-web-default-browser (quote eww-browse-url))
'(search-web-in-emacs-browser (quote eww-browse-url)))
