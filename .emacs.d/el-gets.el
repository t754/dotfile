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
(setq el-get-user-package-directory "~/.emacs.d/el-files/")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))
(require 'el-get-elpa)
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")


(defvar my/el-list '()
  "A list of packages to install from el-get at launch.")
(setq my/el-list
      '(
        ;;##(
        actionscript-mode
        align-cljlet
        auto-complete
        avy
        bm
        c-eldoc
        clang-format
        clj-refactor
        clojure-mode
        clojure-snippets
        cmake-ide
        cmake-mode
        color-theme
        company-irony
        company-jedi
        company-quickhelp
        dockerfile-mode
        drag-stuff
        elisp-format
        emmet-mode
        epc
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
        graphviz-dot-mode
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
        irony-eldoc
        irony-mode
        jedi
        js2-mode
        js2-refactor
        json-reformat
        key-chord
        levenshtein
        lua-mode
        magit
        markdown-mode
        midje-mode
        migemo
        minimap
        multiple-cursors
        org-mode
        popup
        popwin
        pos-tip
        powerline
        projectile-rails
        py-autopep8
        python-pep8
        quickrun
        rbenv
        recentf-ext
        rubocop
        scheme-complete
        slime
        slime-company
        smartparens
        smartrep
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
;; (flymake-chicken :url "http://code.call-cc.org/cgi-bin/gitweb.cgi?p=chicken-core.git;a=blob_plain;f=misc/flymake-chicken.el")
;; (chicken :url "http://code.call-cc.org/cgi-bin/gitweb.cgi?p=chicken-core.git;a=blob_plain;f=misc/chicken.el")
;; cj2tszk/swank-gauche
;; dleslie/chicken-scheme.el
(defvar my/bundle-list '() "A list to install for el-get-bundle ")
(setq my/bundle-list     '(
                           ;;##(
                           (emacs-codic :type github :pkgname "syohex/emacs-codic" )
                           (search-web :type github :pkgname "tomoya/search-web.el")
                           (yuutayamada/mykie-el :load-path "lisp")
                           ;;(alexott/cedet :branch "devel" :build ("'make all'"))
                           ;;(m0smith/malabar-mode :load-path)
                           Malabarba/beacon
                           ShingoFukuyama/emacs-emoji-cheat-sheet
                           bmag/imenu-list
                           company-mode/company-mode
                           emacs-helm/helm-w3m
                           emacs-jp/helm-migemo
                           emacs-jp/init-loader
                           jcpetkovich/shrink-whitespace.el
                           purcell/exec-path-from-shell
                           purcell/flymake-easy
                           purcell/flymake-haskell-multi
                           purcell/flymake-python-pyflakes
                           senny/emacs-eclim
                           yasuyk/helm-git-grep
                           yasuyk/web-beautify
                           zonuexe/emoji-fontset.el
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
