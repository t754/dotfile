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
  (setq flycheck-checker 'ruby-rubocop)
  ;; (flycheck-mode t)
  (robe-mode t)
  ;; (ruby-end-mode +1)
  (setq ruby-insert-encoding-magic-comment nil)
  (setq company-backends
        (quote
         (company-robe company-nxml company-css company-semantic company-capf company-files
                       (company-dabbrev-code
                         ;; company-etags
                        company-keywords)
                       company-oddmuse company-dabbrev)))
  )

(eval-after-load 'company
  '(push 'company-robe company-backends))
(bind-keys* ("M-p"       . codesearch-search))
(add-to-list 'company-backends 'company-robe)


;; (add-hook 'robe-mode-hook 'ac-robe-setup)
(add-hook 'ruby-mode-hook 'my/ruby-mode-hook)
