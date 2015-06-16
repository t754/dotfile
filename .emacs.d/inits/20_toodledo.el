;; toooooooooooooooooooooodledo
(setq org-toodledo-userid "td554c376170911"
      org-toodledo-file (concat (getenv "HOME") "/task.org"))


;;    << *NOT* your email!


;; (setq org-toodledo-password "<toodled-password>")
;; PASSWORD → 21_toodledo.el

;; Useful key bindings for org-mode
;; (defun toodledo-org-agenda-mode-hooks()
;;   (local-set-key ("C-c C-x d") 'org-toodledo-agenda-mark-task-deleted))
(defun toodledo-org-mode-hooks ()
    (when (and (stringp buffer-file-name)
               (string= buffer-file-name org-toodledo-file))
      (require 'org-toodledo)
      (require 'my-password "my-password.el.gpg")
      (local-set-key (kbd "C-c C-x d") 'org-toodledo-mark-task-deleted)
      (local-set-key (kbd "C-c C-x s") 'org-toodledo-sync)))

(add-hook 'find-file-hook 'toodledo-org-mode-hooks)




