;; toooooooooooooooooooooodledo
(require 'org-toodledo)
;;    << *NOT* your email!
(setq org-toodledo-userid "td554c376170911"
      org-toodledo-file (concat (getenv "HOME") "/task.org"))

;; (setq org-toodledo-password "<toodled-password>")
;; PASSWORD → 21_toodledo.el

;; Useful key bindings for org-mode
(add-hook 'org-mode-hook
       (lambda ()
         (local-set-key (kbd "C-c C-x d") 'org-toodledo-mark-task-deleted)
         (local-set-key (kbd "C-c C-x s") 'org-toodledo-sync)
         )
       )
(add-hook 'org-agenda-mode-hook
       (lambda ()
         (local-set-key ("C-c C-x d") 'org-toodledo-agenda-mark-task-deleted)))

