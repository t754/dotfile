;; install roswell !
(load (expand-file-name "~/.roswell/helper.el"))

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
  (define-key slime-mode-map (kbd "C-c C-k") 'my/load-lisp)
  (setq inferior-lisp-program "ros -L sbcl -Q run"))

(defun my/load-lisp ()
  (interactive)
  (if (and (>= (buffer-size) 2)
           (save-restriction
             (widen) (buffer-substring (point-min) (+ 2 (point-min)))))
      (progn
        (beginning-of-buffer nil)
        (forward-line 1)
        (set-mark-command nil)
        (end-of-buffer nil)
        (slime-compile-defun)
        (deactivate-mark nil))
    (slime-compile-and-load-file)))


(require 'cl-lib)
(require 'color)


(defun rainbow-delimiters-mode-hooks ()
  (flet ((my/color-rainbow (i mx)
                           (let ((offset 0.43)
                                 (x 0.5))
                             (+ (* x (/ (* 1.0 i) mx)) offset))))
    (dotimes (i rainbow-delimiters-max-face-count)
      (set-face-foreground (intern (format "rainbow-delimiters-depth-%d-face" (1+ i)))
                           (apply 'color-rgb-to-hex
                                  (color-hsl-to-rgb
                                   (my/color-rainbow (- rainbow-delimiters-max-face-count i) rainbow-delimiters-max-face-count) 0.8 0.7))))))

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'rainbow-delimiters-mode-hook 'rainbow-delimiters-mode-hooks)
