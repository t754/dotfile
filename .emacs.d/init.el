
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq debug-on-error nil)
;;reload
(global-set-key [f12] 'eval-buffer)

;; (server-start)
;; (unless (server-running-p)
;;   (server-start))
;;package

;; (require 'cask "~/.cask/cask.el")
;; (cask-initialize)
;; (require 'pallet)
;; (pallet-mode t)
(load (concat user-emacs-directory "init-el-gets.el"))

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
 '(git-gutter:added-sign "A")
 '(git-gutter:deleted-sign "D")
 '(git-gutter:handled-backends (quote (git hg)))
 '(git-gutter:lighter "_GG")
 '(git-gutter:modified-sign "X")
 '(git-gutter:unchanged-sign nil)
 '(git-gutter:update-interval 2)
 '(git-gutter:window-width 1)
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
 '(org-trello-current-prefix-keybinding "C-c o")
 '(package-selected-packages
   (quote
    (mykie nil robe mozc yascroll package-build shut-up epl git commander f dash s)))
 '(search-web-default-browser (quote eww-browse-url))
 '(search-web-in-emacs-browser (quote eww-browse-url))
 '(tab-width 4)
 '(yas-trigger-key "TAB"))

(put 'upcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bold ((t (:weight bold :height 0.8))))
 '(git-gutter:added ((t (:weight bold :height 0.8 :foreground "green"))))
 '(git-gutter:deleted ((t (:weight bold :height 0.8 :foreground "red"))))
 '(git-gutter:modified ((t (:weight bold :height 0.8 :foreground "magenta")))))
