(when (require 'flymake nil t)
  (require 'flymake-cursor)
  
(custom-set-faces
 '(flymake-errline ((((class color)) (:underline "red"))))
 '(flymake-warnline ((((class color)) (:underline "yellow")))))
  (global-set-key (kbd "M-n") 'flymake-goto-next-error)
  (global-set-key (kbd "M-p") 'flymake-goto-prev-error)

(defun flymake-cc-init ()
	(let* ((temp-file   (flymake-init-create-temp-buffer-copy
						 'flymake-create-temp-inplace))
		   (local-file  (file-relative-name
						 temp-file
						 (file-name-directory buffer-file-name))))
	  (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))


  

  (defun flymake-c-init ()
    (let* ((temp-file   (flymake-init-create-temp-buffer-copy
						 'flymake-create-temp-inplace))
		   (local-file  (file-relative-name
						 temp-file
						 (file-name-directory buffer-file-name))))
	  (list "gcc" (list "-Wall""-pedantic" "-Wextra" "-fsyntax-only" local-file))))

  (push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
  (push '("\\.c$"    flymake-c-init) flymake-allowed-file-name-masks)	

  )

