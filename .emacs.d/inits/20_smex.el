(require 'smex)

;; (global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.


;;;;; C-h f, while Smex is active, runs describe-function on the currently selected command.
;;;
;;;;; M-. jumps to the definition of the selected command.
;;;
;;;;; C-h w shows the key bindings for the selected command. (Via where-is.)
(setq ido-max-window-height 0.75
      ido-enable-flex-matching t
      ido-vertical-define-keys 'C-n-and-C-p-only)
(ido-vertical-mode 1)
(smex-initialize)
(bind-key "M-x" 'smex)
(bind-key "M-X" 'smex-major-mode-commands)

;; (global-set-key (kbd "M-x") 'smex)
;; (global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; (defadvice smex (around space-inserts-hyphen activate compile)
;;   (let ((ido-cannot-complete-command
;;          `(lambda ()
;;             (interactive)
;;             (if (string= " " (this-command-keys))
;;                 (insert ?-)
;;               (funcall ,ido-cannot-complete-command)))))
;;     ad-do-it))
