;; install roswell !
;; (load (expand-file-name "~/.roswell/lisp/quicklisp/slime-helper.el"))

(with-eval-after-load "slime"
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-d") 'company-show-doc-buffer)
  (define-key company-active-map (kbd "M-.") 'company-show-location)
  (define-key slime-prefix-map (kbd "M-h") 'slime-documentation-lookup))

(add-to-list 'load-path (expand-file-name "~/slime"))
(setq inferior-lisp-program "sbcl")
(require 'slime)
(require 'slime-autoloads)
(slime-setup '(
               slime-repl
               slime-fancy
               slime-banner
               slime-company
               ))

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
