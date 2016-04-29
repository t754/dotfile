;;  (require 'haskell-mode-autoloads)
(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-mode-hooks)

(defun haskell-mode-hooks ()
  (turn-on-haskell-unicode-input-method)
  (imenu-add-menubar-index)
  (haskell-indent-mode))
(with-eval-after-load 'haskell
  (bind-keys :map haskell-mode-map
             ("<f8>" . haskell-navigate-imports)
             ("C-c C-c" . haskell-compile)
             ("C-x C-d" . nil)
             ("C-c C-z" . haskell-interactive-switch)
             ("C-c C-l" . haskell-process-load-file)
             ("C-c C-b" . haskell-interactive-switch)
             ("C-c C-t" . haskell-process-do-type)
             ("C-c C-i" . haskell-process-do-info)
             ("C-c M-." . nil)
             ("C-c C-d" . nil)))

(with-eval-after-load 'haskell-cabal
  (bind-keys :map haskell-cabal-mode-map
             ("C-c C-c" . haskell-compile)))

(with-eval-after-load 'interactive-haskell-mode
  (bind-keys :map interactive-haskell-mode-map
             ("M-." . haskell-mode-goto-loc)
             ("C-c C-t" . haskell-mode-show-type-at)))


;; ‘C-c C-z’
;;      is bound to ‘switch-to-haskell’
;; ‘C-c C-b’
;;      is bound to ‘switch-to-haskell’
;; ‘C-c C-l’
;;      is bound to ‘inferior-haskell-load-file’
;; ‘C-c C-t’
;;      is bound to ‘inferior-haskell-type’
;; ‘C-c C-i’
;;      is bound to ‘inferior-haskell-info’
