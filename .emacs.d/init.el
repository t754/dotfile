;; (setq load-path (append '("~/.emacs.d/" ; 自作のlispやinit.el
;;                           ;;                       "~/.emacs.d/howm/"
;;                           "~/.emacs.d/org-mode2/lisp";元はorg-VERJON/elisp
;;                        "~/.emacs.d/elpa/init-loader-20130218.1210/"
;;                           ;;                       "~/.emacs.d/elpa/"
;;                        "~/.emacs.d/elisp/"
;;                        "~/.emacs.d/elisp/grass/"
;;                        "~/.emacs.d/inits/"
;;                           "~/"
;;                        ) load-path))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;ビープ音を消す
(setq visible-bell t);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq gc-cons-threshold (* 256 1024 1024))

                                        ; 常時デバッグ状態ではない
(setq debug-on-error nil)
;;reload
(global-set-key
 [f12] 'eval-buffer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; より下に記述した物が PATH の先頭に追加されます
;; (dolist (dir (list
;;               "/sbin"
;;               "/usr/sbin"
;;               "/usr/local/bin"
;;               "/bin"
;;               "/usr/bin"
;;               "/opt/local/bin"
;;               "/sw/bin"
;;               (expand-file-name "~/bin")
;;               (expand-file-name "~/.emacs.d/bin")
;;               ))
;;   ;; PATH と exec-path に同じ物を追加します
;;   (when (and (file-exists-p dir) (not (member dir exec-path)))
;;     (setenv "PATH" (concat dir ":" (getenv "PATH")))
;;     (setq exec-path (append (list dir) exec-path))))
;; ;; shell の存在を確認
;; (defun skt:shell ()
;;   (or
;;    (executable-find "bash")
;;    (executable-find "zsh")
;;                                         ;      (executable-find "f_zsh") ;; Emacs + Cygwin を利用する人は Zsh の代りにこれにしてください
;;                                         ;     (executable-find "f_bash") ;; Emacs + Cygwin を利用する人は Bash の代りにこれにしてください
;;    (executable-find "cmdproxy")
;;    (error "can't find 'shell' command in PATH!!")))

;; ;; Shell 名の設定
;; (setq shell-file-name (skt:shell))
;; (setenv "SHELL" shell-file-name)
;; (setq explicit-shell-file-name shell-file-name)
;; ;; load-path を追加する関数を定義
;; (defun add-to-load-path (&rest paths)
;;   (let (path)
;;     (dolist (path paths paths)
;;       (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
;;      (add-to-list 'load-path default-directory)
;;      (if (fboundp 'normal-top-level-add-subdir-to-load-path)
;;          (normal-top-level-add-subdirs-to-load-path))))))
;; ;;
;; (let ((default-directory (expand-file-name "~/.emacs.d/elisp")))
;;   (add-to-list 'load-path default-directory)
;;   (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
;;       (normal-top-level-add-subdirs-to-load-path)))
;;;;;; set load path
;; (let ((default-directory "~/.emacs.d/elisp/"))
;;   (setq load-path (cons default-directory load-path))
;;   (normal-top-level-add-subdirs-to-load-path))
;;server
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

(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)


;;inits -- start-els
(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")








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
 '(package-selected-packages (quote (package-build shut-up epl git commander f dash s)))
 '(tab-width 4)
 '(yas-trigger-key "TAB"))

(put 'upcase-region 'disabled nil)
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:inherit nil :stipple nil :background "gray12" :foreground "green" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "PfEd" :family "Ricty")))))
