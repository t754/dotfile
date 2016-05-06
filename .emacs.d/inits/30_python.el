;; (require 'smartrep)
;; (smartrep-define-key
;; (define-key python-mode-map (kbd "C-c f") 'flymake-goto-next-error)
(defun python-mode-hooks ()
  (highlight-indentation-mode)
  (highlight-indentation-current-column-mode)
  ;;(flymake-python-pyflakes-load)
  (flycheck-mode t)
  (auto-complete-mode)
  (company-mode -1)
  (key-chord-mode 1)
  (jedi:setup)
  ;; (whitespace-mode)
  (setq jedi:setup-keys t
		jedi:complete-on-dot t
		jedi:environment-virtualenv
		(list "virtualenv3" "--system-site-packages"))
  (set-face-background 'highlight-indentation-face "gray4")
  (set-face-background 'highlight-indentation-current-column-face "gray20")
  (add-to-list 'company-backends 'company-jedi)
  (setq-default tab-width 4 indent-tabs-mode t))

(with-eval-after-load 'python
  (bind-keys :map python-mode-map
			 ("M-<left>"  . python-indent-shift-left)
			 ("C-c h"     . python-indent-shift-left)
			 ("M-<right>" . python-indent-shift-right)
			 ("C-c l"     . python-indent-shift-right)
			 ("M-C-i"     . jedi:complete)
             ("C-c f"     . python-pep8)
			 ("C-c C-f"   . py-autopep8))

  (bind-keys :map goto-map				;M-g M-{n,p}
			 ("M-n" . flymake-goto-next-error)
			 ("M-p" . flymake-goto-prev-error))

  (add-hook 'python-mode-hook 'python-mode-hooks))
;; (require 'flymake-python-pyflakes)
;; (require 'highlight-indentation)
;; (require 'whitespace)
