
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

(setq debug-on-error nil)
;;reload
(global-set-key [f12] 'eval-buffer)

 (server-start)
 (unless (server-running-p)
   (server-start))
;;package

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
 '(flycheck-display-errors-delay 0.5)
 '(flycheck-display-errors-function
   (lambda
     (errors)
     (let
         ((messages
           (mapcar
            (function flycheck-error-message)
            errors)))
       (popup-tip
        (mapconcat
         (quote identity)
         messages "
")))))
 '(git-gutter:added-sign "A")
 '(git-gutter:deleted-sign "D")
 '(git-gutter:handled-backends (quote (git hg)))
 '(git-gutter:lighter "GG")
 '(git-gutter:modified-sign "X")
 '(git-gutter:unchanged-sign nil)
 '(git-gutter:update-interval 2)
 '(git-gutter:window-width 1)
 '(haskell-mode-hook (quote (turn-on-haskell-indentation)) t)
 '(help-at-pt-display-when-idle (quote (flymake-overlay)) nil (help-at-pt))
 '(help-at-pt-timer-delay 0.9)
 '(irony-additional-clang-options (quote ("-std=c++11")))
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
     "\\let\\equation\\gather
\\let\\endequation\\endgather"
     ("" "textcomp" t)
     ("" "marvosym" t)
     ("" "wasysym" t)
     ("" "amssymb" t)
     "\\ifx\\kanjiskip\\undefined\\else
  \\usepackage{atbegshi}
  \\ifx\\ucs\\undefined
    \\ifnum 42146=\\euc\"A4A2
      \\AtBeginShipoutFirst{\\special{pdf:tounicode EUC-UCS2}}
    \\else
      \\AtBeginShipoutFirst{\\special{pdf:tounicode 90ms-RKSJ-UCS2}}
    \\fi
  \\else
    \\AtBeginShipoutFirst{\\special{pdf:tounicode UTF8-UCS2}}
  \\fi
  \\usepackage[dvipdfmx]{hyperref}
\\fi" "\\tolerance=1000"
     ("" "svg" nil))))
 '(org-latex-hyperref-template
   "\\hypersetup{
 pdfauthor={%a},
 hidelinks,
 pdftitle={%t},
 pdfkeywords={%k},
 pdfsubject={%d},
 pdfcreator={%c},
 pdflang={%L}}
")
 '(org-trello-current-prefix-keybinding "C-c o")
 '(package-selected-packages
   (quote
    (company-jedi inflections mykie nil robe mozc yascroll package-build shut-up epl git commander f dash s)))
 '(safe-local-variable-values
   (quote
    ((eval progn
           (beginning-of-buffer)
           (let
               (mbegin mend)
             (while
                 (re-search-forward ";;##(" nil t)
               (forward-line 1)
               (setq mbegin
                     (point))
               (re-search-forward ";;##)" nil t)
               (forward-line 0)
               (setq mend
                     (point))
               (sort-lines nil mbegin mend)))))))
 '(search-web-default-browser (quote eww-browse-url))
 '(search-web-in-emacs-browser (quote eww-browse-url))
 '(tab-width 4)
 '(undo-tree-mode-lighter " U🌳")
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
 '(git-gutter:modified ((t (:weight bold :height 0.8 :foreground "magenta"))))
 '(popup-tip-face ((t (:background "olive drab" :foreground "black" :weight normal :height 0.9)))))
