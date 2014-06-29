;;;(when(require 'flymake nil t)
;;;  ;; GUIの警告は表示しない
;;;  (setq flymake-gui-warnings-enabled nil)
;;;  
;;;(defun flymake-c-init ()
;;;  (flymake-simple-make-or-generic-init
;;;   "gcc" '("-Wall" "-Wextra" "-pedantic" "-fsyntax-only")))
;;; 
;;;(defun flymake-cc-init ()
;;;  (flymake-simple-make-or-generic-init
;;;   "g++" '("-Wall" "-Wextra" "-pedantic" "-fsyntax-only")))
;;; 
;;;(push '("\\.[cC]\\'" flymake-c-init) flymake-allowed-file-name-masks)
;;;(push '("\\.\\(?:cc\|cpp\|CC\|CPP\\)\\'" flymake-cc-init) flymake-allowed-file-name-masks)
;;;  
;;; 
;;;  )
