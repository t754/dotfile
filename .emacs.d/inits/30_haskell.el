;;  (require 'haskell-mode-autoloads)
 (require 'haskell-mode)
    (custom-set-variables
     '(haskell-mode-hook '(turn-on-haskell-indentation)))
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; (require 'haskell-cabal)
;; (autoload 'ghc-init "ghc" nil t)
;; (add-to-list 'exec-path (concat (getenv "HOME") "/.cabal/bin"))
;; (add-to-list 'auto-mode-alist '("\\.hs$".haskell-mode))
;; (add-hook 'haskell-mode-hook (lambda () (ghc-init) ))
;; (load "haskell-site-file")

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)
(require 'flymake-haskell-multi) ;; not needed if installed via package
 (add-hook 'haskell-mode-hook 'flymake-haskell-multi-load)

;; (defun flymake-get-Haskell-cmdline (source base-dir)
;;   (list "ghc"
;;         (list "--make" "-fbyte-code"
;;               (concat "-i"base-dir)
;;               source)))
;; (defvar multiline-flymake-mode nil)
;; (defvar flymake-split-output-multiline nil)
;; (defadvice flymake-split-output
;;   (around flymake-split-output-multiline activate protect)
;;   (if multiline-flymake-mode
;;       (let ((flymake-split-output-multiline t))
;;         ad-do-it)
;;     ad-do-it))
;; (defadvice flymake-split-string
;;   (before flymake-split-string-multiline activate)
;;   (when flymake-split-output-multiline
;;     (ad-set-arg 1 "^\\s *$")))


;; (add-hook
;;  'haskell-mode-hook
;;  '(lambda ()
;;     (add-to-list 'flymake-allowed-file-name-masks
;;                  '("\\.l?hs$" flymake-Haskell-init flymake-simple-java-cleanup))
;;     (add-to-list 'flymake-err-line-patterns
;;                  '("^\\(.+\\.l?hs\\):\\([0-9]+\\):\\([0-9]+\\):\\(\\(?:.\\|\\W\\)+\\)"
;;                    1 2 3 4))
;;     (set (make-local-variable 'multiline-flymake-mode) t)
;;     (if (not (null buffer-file-name)) (flymake-mode))
;;     ))
;; (autoload ghc-init "ghc" nil t)

