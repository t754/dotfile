(require 'rbenv)
;; (require 'bundle)
;; (require 'projectile)
(require 'projectile-rails)



;; ;; (setq rbenv-show-active-ruby-in-modeline nil)
(setq rbenv-modeline-function 'rbenv--modeline-plain)



;; (add-hook 'projectile-mode-hook 'projectile-rails-on)
;; ;; ;; rails project 始めるときに呼び出す

(defun my/rails-start ()
  (interactive)
  (global-rbenv-mode)
  (projectile-rails-mode t))
