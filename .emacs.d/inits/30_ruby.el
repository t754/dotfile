;; (require 'smartparens-ruby)

;; (eval-after-load "ruby-mode"
;;    '(progn
;;      (define-key ruby-mode-map (kbd "C-c ?") 'robe-doc)))


;; (custom-set-variables
;;  '(robe-completing-read-func 'helm-robe-completing-read))

(setq ruby-insert-encoding-magic-comment nil)
(defun ruby-mode-set-encoding () nil)
;;;;;; gem → rubocop ruby-lint pry  pry-doc  method_source
(defun my/ruby-mode-hook ()
  (show-smartparens-mode t)
  ;; (setq flycheck-checker 'ruby-rubocop)
  ;; (flycheck-mode t)
  ;; (robe-mode t)
  ;; (ruby-end-mode +1)
  )


;; (add-hook 'robe-mode-hook 'ac-robe-setup)
(add-hook 'ruby-mode-hook 'my/ruby-mode-hook)
