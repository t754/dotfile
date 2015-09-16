(require 'rbenv)
(require 'projectile)
(require 'projectile-rails)
(require 'helm-rails)
;;
;;

;; (setq rbenv-show-active-ruby-in-modeline nil)
(setq rbenv-modeline-function 'rbenv--modeline-plain)


(add-hook 'projectile-mode-hook 'projectile-rails-on)
;; ;; rails project 始めるときに呼び出す

(defun my/rails-start ()
  (global-rbenv-mode)
  (projectile-global-mode))
