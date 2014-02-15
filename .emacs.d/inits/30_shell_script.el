;;#!で始まるファイル +
    ; Check for shebang magic in file after save, make executable if found.
    
(add-hook 'after-save-hook
        #'(lambda ()
        (and (save-excursion
               (save-restriction
                 (widen)
                 (goto-char (point-min))
                 (save-match-data
                   (looking-at "^#!"))))
             (not (file-executable-p buffer-file-name))
             (shell-command (concat "chmod u+x " buffer-file-name))
             (message
              (concat "Saved as script: " buffer-file-name)))))
(add-hook 'after-save-hook
		  'executable-make-buffer-file-executable-if-script-p)
