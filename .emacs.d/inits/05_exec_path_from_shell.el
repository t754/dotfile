(let ((envs '("MANPATH" "PATH" "GOROOT" "GOPATH" )))
  (exec-path-from-shell-copy-envs envs))
;; (exec-path-from-shell-initialize)
(setq eshell-prompt-function
      (lambda () (concat "[" (eshell/pwd) (if (= (user-uid) 0) "]\n# " "]\n$ "))))
(setq eshell-command-aliases-list
      (append (list
        '("ll" "ls -ltr")
        '("la" "ls -a"))))
