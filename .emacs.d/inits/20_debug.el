(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer t)
(add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))
