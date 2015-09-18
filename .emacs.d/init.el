(setq debug-on-error nil)
;;reload
(global-set-key [f12] 'eval-buffer)

(server-start)
(unless (server-running-p)
  (server-start))
;;package
 (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                          ("melpa" . "http://melpa.milkbox.net/packages/")
                          ("ELPA" . "http://tromey.com/elpa/" )
                          ("org" . "http://orgmode.org/elpa/")
                          ))
   (package-initialize)

;; (require 'cask "~/.cask/cask.el")
;; (cask-initialize)
;; (require 'pallet)
;; (pallet-mode t)
(load (concat user-emacs-directory "el-gets.el"))

;;inits -- start-els
(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")

(scroll-bar-mode 0)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-delay 0.4)
 '(ace-isearch-input-idle-delay 1)
 '(ace-isearch-input-length 5)
 '(haskell-mode-hook (quote (turn-on-haskell-indentation)) t)
 '(mozc-leim-title "も")
 '(org-latex-default-packages-alist
   (quote
    (("AUTO" "inputenc" t)
     ("T1" "fontenc" t)
     ("" "fixltx2e" nil)
     ("dvipdfmx" "graphicx" t)
     ("" "longtable" nil)
     ("" "float" nil)
     ("" "wrapfig" nil)
     ("" "rotating" nil)
     ("normalem" "ulem" t)
     ("" "amsmath" t)
     ("" "textcomp" t)
     ("" "marvosym" t)
     ("" "wasysym" t)
     ("" "amssymb" t)
     ("" "hyperref" nil)
     "\\tolerance=1000"
     ("" "svg" nil))))
 '(package-selected-packages
   (quote
    (mozc yascroll package-build shut-up epl git commander f dash s)))
 '(tab-width 4)
 '(yas-trigger-key "TAB"))

(put 'upcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
