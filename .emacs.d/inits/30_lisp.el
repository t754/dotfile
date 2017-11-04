;; install roswell !

(load (expand-file-name "~/.roswell/helper.el"))

(with-eval-after-load "slime"
  (require 'slime-autoloads)
  (require 'slime-repl)
  (setq slime-complete-symbol*-fancy t)
  (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
  (smartparens-strict-mode)
  (bind-keys :map company-active-map
             ("C-n" . company-select-next)
             ("C-p" . company-select-previous)
             ("C-d" . company-show-doc-buffer)
             ("M-." . company-show-location))
  (bind-keys :map slime-prefix-map
             ("M-h" . slime-documentation-lookup)
             ("s"   . slime-selector))
  (bind-keys :map slime-mode-map
             ("C-c C-k" . my/load-lisp)))
(setq inferior-lisp-program "ros -Q run")


(defun lisp-mode-hooks ()
  (smartparens-mode t))

(add-hook 'lisp-mode-hook 'lisp-mode-hooks)

(slime-setup '(
               slime-repl
               slime-fancy
               slime-banner
               slime-company
               slime-indentation
               ))

(defun my/load-lisp ()
  (interactive)
  (if (and (>= (buffer-size) 2)
           (save-restriction
             (widen) (buffer-substring (point-min) (+ 2 (point-min)))))
      (save-excursion
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
