(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
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
        align-cljlet
        anzu
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
        company-tern
        dockerfile-mode
        drag-stuff
        emmet-mode
        epc
        epl
        expand-region
        f
        flycheck
        flycheck-cask
        flycheck-color-mode-line
        flycheck-irony
        flycheck-rust
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
        multiple-cursors
        omnisharp-mode
        org-mode
        popup
        popwin
        pos-tip
        powerline
        projectile-rails
        py-autopep8
        python-pep8
        quickrun
        rainbow-delimiters
        rbenv
        recentf-ext
        rubocop
        rust-mode
        rust-racer
        scheme-complete
        slime-company
        smartparens
        smartrep
        smex
        switch-window
        toml-mode
        undo-tree
        use-package
        web-mode
        yaml-mode
        yascroll
        yasnippet
        ;;##)
        ))

(defvar my/bundle-list '() "A list to install for el-get-bundle ")
(setq my/bundle-list     '(
                           ;;##(
                           (emacs-codic :type github :pkgname "syohex/emacs-codic" )
                           (search-web :type github :pkgname "tomoya/search-web.el")
                           (yuutayamada/mykie-el :load-path "lisp")
                           Malabarba/beacon
                           ShingoFukuyama/emacs-emoji-cheat-sheet
                           abo-abo/swiper
                           bmag/imenu-list
                           company-mode/company-mode
                           dgutov/robe
                           emacs-helm/helm-w3m
                           emacs-jp/helm-migemo
                           emacs-jp/init-loader
                           favadi/flycheck-gometalinter
                           jcpetkovich/shrink-whitespace.el
                           ptrv/company-lua
                           ptrv/helm-smex
                           purcell/exec-path-from-shell
                           purcell/flymake-easy
                           purcell/flymake-haskell-multi
                           purcell/flymake-python-pyflakes
                           racer-rust/emacs-racer
                           senny/emacs-eclim
                           syl20bnr/emacs-emoji-cheat-sheet-plus
                           yasuyk/helm-git-grep
                           yasuyk/web-beautify
                           zonuexe/emoji-fontset.el
                           ;;##)
                           ))

(dolist (x my/bundle-list)
  (cond
   ((listp x) (eval `(el-get-bundle ,@x)))
   (t         (eval `(el-get-bundle ,x)))))
(el-get 'sync my/el-list)

;; Local Variables:
;; eval: (progn (beginning-of-buffer)(let (mbegin mend)(while (re-search-forward ";;##(" nil t)(forward-line 1)(setq mbegin (point))(re-search-forward ";;##)" nil t)(forward-line 0)(setq mend (point))(sort-lines nil mbegin mend))))
;; End:
