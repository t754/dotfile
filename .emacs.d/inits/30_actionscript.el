(autoload 'actionscript-mode "actionscript-mode" "Major mode for actionscript." t)

(defun my/actionscript-mode-hook ()
  (setq actionscript-indent-level 2)
  ;; (setq cua-auto-tabify-rectangles nil)
  ;; (setq indent-tabs-mode t)
  )


(add-hook 'actionscript-mode-hook 'my/actionscript-mode-hook)
(add-to-list 'auto-mode-alist '("\\.as$" . actionscript-mode))
;; (setq tab-width 2)


