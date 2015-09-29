(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("ELPA" . "http://tromey.com/elpa/" )
                         ("org" . "http://orgmode.org/elpa/")
                         ))
(package-initialize)
(require 'el-get)
(el-get 'sync)
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
;; setup
(el-get-bundle emacs-jp/init-loader)
(el-get-bundle purcell/exec-path-from-shell)
;; Input method
(when (executable-find "mozc_emacs_helper")
  (el-get-bundle elpa:mozc))

(setq my/bundle-list
	  '(ac-cider
		ac-emoji
		ac-helm
		ac-math
		ac-slime
		ace-isearch
		actionscript-mode
		align-cljlet
		all-ext
		auto-complete
		auto-complete-c-headers
		bm
		c-eldoc
		(cider :type github :pkgname "clojure-emacs/cider")
		clj-refactor
		clojure-cheatsheet
		clojure-mode
		clojure-mode-extra-font-locking
		clojure-snippets
		codic
		color-theme
		ctags-update
		dockerfile-mode
		drag-stuff
		eldoc-extension
		emmet-mode
		epl
		exec-path-from-shell
		f
		flycheck
		flycheck-cask
		flycheck-clojure
		flycheck-color-mode-line
		flymake-cursor
		flymake-haskell-multi
		flymake-python-pyflakes
		fold-dwim-org
		git
		git-commit-mode
		git-gutter
		gnuplot
		go-autocomplete
		go-eldoc
		go-mode
		google-translate
		haskell-mode
		helm
		helm-ag
		helm-bm
		helm-c-yasnippet
		helm-descbinds
		helm-emmet
		helm-gtags
		helm-projectile
		helm-rails
		helm-robe
		helm-swoop
		highlight-indentation
		htmlize
		http-post-simple
		idle-highlight-mode
		inf-clojure
		inf-ruby
		init-loader
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
		org-plus-contrib
		org-trello
		ox-textile
		popwin
		powerline
		projectile-rails
		quickrun
		rainbow-delimiters
		rbenv
		robe
		rubocop
		shut-up
		slamhound
		slime
		smartparens
		smartrep
		undo-tree
		use-package
		visual-regexp-steroids
		web-beautify
		web-mode
		yaml-mode
		yascroll
		yasnippet
		avy
		fold-dwim
		org-mode
		(search-web :type github :pkgname "tomoya/search-web.el")
		smex
		ido-vertical-mode
        mykie))
;; (el-get-bundle xxx)


(dolist (x my/bundle-list)
  (cond
   ((listp x) (eval `(el-get-bundle ,@x)))
   (t         (eval `(el-get-bundle ,x)))))
