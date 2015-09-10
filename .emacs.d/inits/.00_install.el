;----install-elisp-------------------------------------
;; まず、install-elisp のコマンドを使える様にします。
(when (require 'install-elisp nil t)
;; 次に、Elisp ファイルをインストールする場所を指定します。

(defvar install-elisp-repository-directory "~/.emacs.d/elisp/"))
;;--------------auto-install------------------------------
;; dammy desu
(when(require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
;; ↓ダミーですよ
(setq auto-install-update-emacswiki-package-name t)
  (auto-install-update-emacswiki-package-name t)
  ;(setq  url-proxy-services '(("http" . "localhost:8339")))
  (auto-install-compatibility-setup))

;;package.elの設定
;; (require 'cl)
;; (require 'package)
;; ;;(package-initialize)
 (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                          ("melpa" . "http://melpa.milkbox.net/packages/")
                          ("ELPA" . "http://tromey.com/elpa/" )
                          ("org" . "http://orgmode.org/elpa/")
                          ))

(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
;;(package-initialize)
;; ;;インストールするディレクトリを指定
;; (add-to-list 'package-archives
;;               '("marmalade" . "http://marmalade-repo.org/packages/") t)
;; (add-to-list 'package-archives
;;               '("gnu" . "http://elpa.gnu.org/packages/") t)
;; (add-to-list 'package-archives
;;              '("ELPA" . "http://tromey.com/elpa/" ) t)
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives
;;              '("org" . "http://orgmode.org/elpa/") t)
;; (package-initialize)
;;(require 'melpa)



