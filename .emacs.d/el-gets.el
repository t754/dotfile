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
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

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
    auto-complete
    auto-complete-c-headers
    avy
    bm
    c-eldoc
    clj-refactor
    clojure-mode
    clojure-snippets
    color-theme
    dockerfile-mode
    drag-stuff
    emmet-mode
    epl
    f
    flycheck
    flycheck-cask
    flycheck-color-mode-line
    flymake-cursor
    flymake-lua
    fold-dwim
    git-commit-mode
    git-gutter
    go-autocomplete
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
    undo-tree
    use-package
    visual-regexp-steroids
    web-mode
    yaml-mode
    yascroll
    yasnippet
    )
  "A list of packages to install from el-get at launch.")



;; ;; Input method
;; (when (executable-find "mozc_emacs_helper")
;;   (el-get-bundle elpa:mozc))

;;
;; (cider :type github :pkgname "clojure-emacs/cider")		;;clojure-cheatsheet
;;
;; (el-get-bundle xxx)

;;		all-ext
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


(defvar my/bundle-list '(
                         emacs-jp/init-loader
                         purcell/exec-path-from-shell
                         purcell/flymake-haskell-multi
                         (search-web :type github :pkgname "tomoya/search-web.el")
                         yasuyk/web-beautify
                         purcell/flymake-easy
                         (emacs-codic :type github :pkgname "syohex/emacs-codic" )
                         (yuutayamada/mykie-el :load-path "lisp")
                         purcell/flymake-python-pyflakes
                         )
  "A list to install for el-get-bundle ")



;; (add-to-list 'my/el-list ' )
(dolist (x my/bundle-list)
  (cond
   ((listp x) (eval `(el-get-bundle ,@x)))
   (t         (eval `(el-get-bundle ,x)))))
(el-get 'sync my/el-list)
