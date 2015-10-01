(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (require 'package)

  (setq package-archives '(("melpa" . "http://melpa.org/packages/")
			   ("gnu" . "http://elpa.gnu.org/packages/")
			   ("marmalade" . "http://marmalade-repo.org/packages/")
			   ("ELPA" . "http://tromey.com/elpa/" )
			   ("org" . "http://orgmode.org/elpa/")
			   ))

  (package-refresh-contents)
  (package-initialize)
  (package-install 'el-get)
  (require 'el-get))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")



		;; melpa:ac-emoji
(defvar my/el-list
  '(

    ac-cider
		ac-helm
		ac-math
		ac-slime
		ace-isearch
		actionscript-mode
		align-cljlet
;;		all-ext
		auto-complete
		auto-complete-c-headers
		bm
		c-eldoc

		clj-refactor

		clojure-mode
;;		clojure-mode-extra-font-locking
		clojure-snippets
;;
		color-theme
;;		ctags-update
		dockerfile-mode
		drag-stuff
;;		eldoc-extension
		emmet-mode
		epl

		f
		flycheck
		flycheck-cask
;;		flycheck-clojure
		flycheck-color-mode-line
		flymake-cursor
;;		flymake-haskell-multi
;;		flymake-python-pyflakes
;;		fold-dwim-org
;;		git
		git-commit-mode
		git-gutter
;;		gnuplot
		go-autocomplete
		go-eldoc
		go-mode
		google-translate
		haskell-mode
		helm
		helm-ag
;;		helm-bm
		helm-c-yasnippet
		helm-descbinds
;;		helm-emmet
		helm-gtags
;;		helm-projectile
		helm-rails
		helm-robe
		helm-swoop
		highlight-indentation
		htmlize
;;		http-post-simple
		idle-highlight-mode
;;		inf-clojure
		inf-ruby

		jedi
		js2-mode
		js2-refactor
		json-reformat
		lua-mode
		magit
		markdown-mode
		midje-mode
		minimap
		multiple-cursors
;;		org-plus-contrib
;;		org-trello
;;		ox-textile
		popwin
		powerline
		projectile-rails
		quickrun

		rbenv
;;		robe
		rubocop
;;		shut-up
;;		slamhound
		slime
		smartparens
		smartrep
		undo-tree
		use-package
		visual-regexp-steroids
;;		web-beautify
		web-mode
		yaml-mode
		yascroll
		yasnippet
		avy
		fold-dwim
		org-mode
		smex
		ido-vertical-mode
;;
		)
	  "A list of packages to install from el-get at launch.")

(el-get 'sync my/el-list)

;; ;; Input method
;; (when (executable-find "mozc_emacs_helper")
;;   (el-get-bundle elpa:mozc))

   ;;
		;; (cider :type github :pkgname "clojure-emacs/cider")		;;clojure-cheatsheet
		;;
;; (el-get-bundle xxx)
;; (el-get-bundle melpa:helm-bm)
(defvar my/bundle-list '(
			 emacs-jp/init-loader
			 purcell/exec-path-from-shell
             purcell/flymake-haskell-multi
             (search-web :type github :pkgname "tomoya/search-web.el")
             yasuyk/web-beautify
             purcell/flymake-easy
			 syohex/emacs-codic
             (yuutayamada/mykie-el :load-path "lisp")
             ;; yasuyk/helm-bm
			 )
  "A list to install for el-get-bundle ")




 (dolist (x my/bundle-list)
   (cond
    ((listp x) (eval `(el-get-bundle ,@x)))
    (t         (eval `(el-get-bundle ,x)))))
