(add-hook 'java-mode-common-hook
          (lambda ()
		
			(define-key java-mode-map(kbd "C-c p") 'smart-compile)
			;;
			(define-key java-mode-map(kbd "C-c C-p") 'c-indent-defun)))
