(use-package counsel
  :config
  (defvar my/--ivy-current-buffer "")

   (defun my/ivy-insert-current-directory ()
     (interactive)
     (insert my/--ivy-current-buffer))

   (defvar my/find-file-map
     (let ((map (make-sparse-keymap)))
       (define-key map (kbd "C-s") 'my/ivy-insert-current-directory)
       map))

   (defun my/find-file (&optional initial-input)
     (interactive)
     (let* ((current-directory (file-name-directory (or buffer-file-name default-directory)))
            (default-directory (expand-file-name (or (locate-dominating-file default-directory ".git")
                                                     current-directory)))
            (find-dir-cmd "find . -not -path '*\/.git*'")
            (cands (split-string
                    (shell-command-to-string find-dir-cmd)
                    "\n"
                    t)))
       (setq my/--ivy-current-buffer
             (replace-regexp-in-string default-directory "" (expand-file-name current-directory)))
       (ivy-read "Choose: " cands
                 :initial-input initial-input
                 :action (lambda (x)
                           (let ((expanded-name (expand-file-name x)))
                             (if (file-directory-p expanded-name)
                                 (counsel-find-file (concat expanded-name "/"))
                               (find-file expanded-name))))
                 :caller 'my/find-file
                 :keymap my/find-file-map))))
