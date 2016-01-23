;; 1. Install eclispe in local for eclim-mode
;; 2. Download [[http://eclim.org/install.html]] and install (run $ java -jar eclim.jar)
;;   2.1. put workspace in "~/workspace"
;; 3. start eclim server (M-x start-eclimd)
(defun java-mode-common-hooks ()
  (custom-set-variables
   '(eclim-eclipse-dirs '("~/eclipse"))
   '(eclim-executable "~/eclipse/eclim")
   '(eclimd-executable "~/eclipse/eclimd"))
  (setq help-at-pt-display-when-idle t
        help-at-pt-timer-delay 0.1)
  (help-at-pt-set-timer)
  ;; (require 'auto-complete-config)
  ;; (ac-config-default)
  (require 'ac-emacs-eclim-source)
  ;; (ac-emacs-eclim-config)
  (define-key eclim-mode-map (kbd "C-c C-e l") 'eclim-java-find-references)
  (global-eclim-mode)
  )

(require 'eclim)
(require 'eclimd)

(with-eval-after-load  'java-mode
  (define-key java-mode-map(kbd "C-c p") 'smart-compile)
  ;;
  (define-key java-mode-map(kbd "C-c C-p") 'c-indent-defun)
  )

(add-hook 'java-mode-hook 'eclim-mode)
(add-hook 'java-mode-hook 'java-mode-common-hooks)
