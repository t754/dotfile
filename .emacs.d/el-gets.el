(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;; (require 'package)
;; (setq package-archives '(("melpa" .  "http://melpa.org/packages/")
;; 			   ("gnu" . "http://elpa.gnu.org/packages/")
;; 			   ("marmalade" . "http://marmalade-repo.org/packages/")
;; 			   ("ELPA" . "http://tromey.com/elpa/" )
;; 			   ("org" . "http://orgmode.org/elpa/")
;; 			   ))
;; (package-refresh-contents)
;; (package-initialize)
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")


(defvar my/el-list '()
  "A list of packages to install from el-get at launch.")
(setq my/el-list
      '(
        ;;##(
        actionscript-mode
        align-cljlet
        avy
        bm
        c-eldoc
        clang-format
        clj-refactor
        clojure-mode
        clojure-snippets
        color-theme
        company-quickhelp
        dockerfile-mode
        drag-stuff
        emmet-mode
        epl
        expand-region
        f
        flycheck
        flycheck-cask
        flycheck-color-mode-line
        flycheck-irony
        flymake-cursor
        flymake-lua
        fold-dwim
        git-commit-mode
        git-gutter
        go-eldoc
        go-mode
        google-translate
        haskell-mode
        helm
        helm-ag
        helm-descbinds
        helm-gtags
        helm-rails
        helm-robe
        helm-swoop
        highlight-indentation
        htmlize
        idle-highlight-mode
        ido-vertical-mode
        inf-ruby
        irony-mode
        jedi
        js2-mode
        js2-refactor
        json-reformat
        key-chord
        lua-mode
        magit
        markdown-mode
        midje-mode
        minimap
        multiple-cursors
        org-mode
        popup
        popwin
        powerline
        projectile-rails
        quickrun
        rbenv
        rubocop
        slime
        smartparens
        smartrep
        smex
        switch-window
        toml-mode
        undo-tree
        use-package
        visual-regexp-steroids
        web-mode
        yaml-mode
        yascroll
        yasnippet
        ;;##)
        ))




;; (cider :type github :pkgname "clojure-emacs/cider")		;;clojure-cheatsheet
;; (el-get-bundle xxx)

;;      mozc
;;		clojure-mode-extra-font-locking
;;		ctags-update
;;		eldoc-extension
;;		flycheck-clojure
;;		flymake-haskell-multi
;;		flymake-python-pyflakes
;;		fold-dwim-org
;;		git
;;		gnuplot
;;		helm-bm
;;		helm-emmet
;;		helm-projectile
;;		http-post-simple
;;		inf-clojure
;;		org-plus-contrib
;;		org-trello
;;		ox-textile
;;		robe
;;		shut-up
;;		slamhound
;;		web-beautify
;; melpa:ac-emoji
;;
(defvar my/bundle-list '() "A list to install for el-get-bundle ")
(setq my/bundle-list     '(
                           ;;##(
                           (emacs-codic :type github :pkgname "syohex/emacs-codic" )
                           (search-web :type github :pkgname "tomoya/search-web.el")
                           (yuutayamada/mykie-el :load-path "lisp")
                           ;;(alexott/cedet :branch "devel" :build ("'make all'"))
                           ;;(m0smith/malabar-mode :load-path)
                           Malabarba/beacon
                           bmag/imenu-list
                           company-mode/company-mode
                           emacs-jp/init-loader
                           jcpetkovich/shrink-whitespace.el
                           purcell/exec-path-from-shell
                           purcell/flymake-easy
                           purcell/flymake-haskell-multi
                           purcell/flymake-python-pyflakes
                           senny/emacs-eclim
                           yasuyk/web-beautify
                           ;;##)
                           ))


(el-get-emacswiki-refresh)
(dolist (x my/bundle-list)
  (cond
   ((listp x) (eval `(el-get-bundle ,@x)))
   (t         (eval `(el-get-bundle ,x)))))
(el-get 'sync my/el-list)

;; Local Variables:
;; eval: (progn (beginning-of-buffer)(let (mbegin mend)(while (re-search-forward ";;##(" nil t)(forward-line 1)(setq mbegin (point))(re-search-forward ";;##)" nil t)(forward-line 0)(setq mend (point))(sort-lines nil mbegin mend))))
;; End:
