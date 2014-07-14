(add-hook 'ruby-mode-hook
 '(lambda ()
	;;C-m 改行&インデント
	(define-key ruby-mode-map (kbd "C-m") 'newline-and-indent)
	(define-key ruby-mode-map (kbd "C-c p") 'smart-compile)
	))

    
