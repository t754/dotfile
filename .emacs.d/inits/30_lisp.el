(with-eval-after-load "slime"
  (slime-setup '(slime-repl slime-fancy slime-banner))
  (add-hook 'slime-mode-hook 'set-up-slime-ac)
  (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
  (setq inferior-lisp-program (executable-find "sbcl")))
