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







(require 'flymake)
(require 'popup)

(setq flymake-run-in-place nil)
(setq flymake-gui-warnings-enabled nil)
;; Show error message under current line

(defun my-flymake-display-err-menu-for-current-line ()
  "Displays the error/warning for the current line via popup-tip"
  (interactive)
  (let* ((line-no (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (menu-data (flymake-make-err-menu-data line-no line-err-info-list)))
    (if menu-data
        (popup-tip (mapconcat #'(lambda (err)
                                  (nth 0 err))
                              (nth 1 menu-data) "\n")))))

;; If you don't set :height, :bold face parameter of 'pop-tip-face,
;; then seting those default values
(if (eq 'unspecified (face-attribute 'popup-tip-face :height))
    (set-face-attribute 'popup-tip-face nil :height 0.9))
(if (eq 'unspecified (face-attribute 'popup-tip-face :weight))
    (set-face-attribute 'popup-tip-face nil :weight 'normal))

(defun my/display-error-message ()
  (let ((orig-face (face-attr-construct 'popup-tip-face)))
    (set-face-attribute 'popup-tip-face nil
                        :height 1.5 :foreground "firebrick"
                        :background "LightGoldenrod1" :bold t)
    (unwind-protect
        (my-flymake-display-err-menu-for-current-line)
      (while orig-face
        (set-face-attribute 'popup-tip-face nil (car orig-face) (cadr orig-face))
        (setq orig-face (cddr orig-face))))))

(defadvice flymake-goto-prev-error (after flymake-goto-prev-error-display-message)
  (my/display-error-message))
(defadvice flymake-goto-next-error (after flymake-goto-next-error-display-message)
  (my/display-error-message))

(ad-activate 'flymake-goto-prev-error 'flymake-goto-prev-error-display-message)
(ad-activate 'flymake-goto-next-error 'flymake-goto-next-error-display-message)


(defun flymake-get-make-cmdline (source base-dir)
  (list "make"
	(list "-s"
	      "-C"
	      base-dir
	      (concat "CHK_SOURCES=" source)
	      "SYNTAX_CHECK_MODE=1"
          "LANG=C"
          "LC_MESSAGES=C"
	      "check-syntax")))
