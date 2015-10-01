(require 'mykie)
(setq mykie:use-major-mode-key-override t)
(mykie:initialize)
;;;; You can set 'global or global-map instead of nil to specify global-map.
;;;; If you want to specify specific keymap, specify the keymap name
;;;; like emacs-lisp-mode-map instead of nil.
;; (mykie:set-keys nil
;;   "C-a"
;;   :default     (beginning-of-line)
;;   :C-u         mark-whole-buffer
;;   "C-e"
;;   :default     (end-of-line)
;;   :C-u         (message "Hello")
;;   ;; ... You can add more keybindds
;;   )

(mykie:global-set-key "C-w"
  :default my/delete-word-at-point
  :region kill-region)

(defun my/delete-word-at-point ()
  (interactive)
  (let ((now-point (point))
        (forward-point (progn (forward-word) (backward-word) (point))))
    (unless (= forward-point now-point)
      (goto-char now-point) (backward-word))
    (kill-word nil)))
