;; install roswell !
(load (expand-file-name "~/.roswell/lisp/quicklisp/slime-helper.el"))
(with-eval-after-load "slime"
  (require 'slime-autoloads)
  (slime-setup '(slime-repl slime-fancy slime-banner slime-company))
  ;; (add-hook 'slime-mode-hook 'set-up-slime-ac)
  ;; (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-d") 'company-show-doc-buffer)
  (define-key company-active-map (kbd "M-.") 'company-show-location)
  (define-key slime-prefix-map (kbd "M-h") 'slime-documentation-lookup)
  (setq inferior-lisp-program "ros -L sbcl -Q run"))

(require 'cl-lib)
(require 'color)
(defun rainbow-delimiters-using-stronger-colors ()
  (interactive)
  (cl-loop
   for index from 1 to rainbow-delimiters-max-face-count
   do
   (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
    (cl-callf color-saturate-name (face-foreground face) 80))))
(add-hook 'emacs-startup-hook 'rainbow-delimiters-using-stronger-colors)
