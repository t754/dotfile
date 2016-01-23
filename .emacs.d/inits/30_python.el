;; (require 'smartrep)
;; (smartrep-define-key
;;     global-map "M-g" '(("M-n" . 'flymake-goto-next-error)
;;                        ("M-p" . 'flymake-goto-prev-error)))
;; (define-key python-mode-map (kbd "C-c f") 'flymake-goto-next-error)

(defun python-mode-hooks ()
  (when (require 'highlight-indentation nil t)
    (highlight-indentation-mode)
    (highlight-indentation-current-column-mode)
    (set-face-background 'highlight-indentation-face "gray4")
    (set-face-background 'highlight-indentation-current-column-face "gray20"))
  (require 'flymake-python-pyflakes)
  (flymake-python-pyflakes-load)
  (define-key python-mode-map (kbd "M-<left>")  'python-indent-shift-left)
  (define-key python-mode-map (kbd "M-<right>")  'python-indent-shift-right)

  (setq jedi:complete-on-dot t)                 ;;optional
  (jedi:setup)

  (when (require 'whitespace nil t)
    (setq whitespace-style '(face trailing tabs spaces empty space-mark tab-mark)
		  whitespace-display-mappings '((space-mark ?\u3000 [?\u25a1])
										(tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t]))
		  whitespace-space-regexp "\\(\u3000+\\)"
		  whitespace-space 'underline)
    (setq-default tab-width 4 indent-tabs-mode t)
    (defvar my/bg-color "#232323")
    (set-face-attribute 'whitespace-trailing nil
                        :background my/bg-color
                        :foreground "DeepPink"
                        :underline t)
    (set-face-attribute 'whitespace-tab nil
                        :background my/bg-color
                        :foreground "LightSkyBlue"
                        :underline t)
    (set-face-attribute 'whitespace-space nil
                        :background my/bg-color
                        :foreground "GreenYellow"
                        :weight 'bold)
    (set-face-attribute 'whitespace-empty nil
                        :background "#000000")
    (set-face-attribute 'whitespace-hspace nil
                        :background my/bg-color
                        :foreground "#000000"
                        :underline t)

    (whitespace-mode)))

(add-hook 'python-mode-hook 'python-mode-hooks)
