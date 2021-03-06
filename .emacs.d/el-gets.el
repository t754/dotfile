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
        ;; align-cljlet
        ;; clj-refactor
        ;; clj-refactor
        ;; company-tern
        ;; company-ternxs
        ;; tern
        ;; yascroll
        ;;rust-racer
        align-cljlet
        atom-dark-theme
        auto-complete
        avy
        bm
        bundler
        c-eldoc
        cargo
        clang-format
        clojure-mode
        clojure-snippets
        cmake-ide
        cmake-mode
        color-theme
        color-theme-almost-monokai
        company-irony
        company-jedi
        company-quickhelp
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
        git-commit-mode
        git-gutter+
        go-eldoc
        go-mode
        google-translate
        graphviz-dot-mode
        haskell-mode
        helm
        helm-ag
        helm-descbinds
        helm-gtags
        helm-ls-git
        helm-robe
        helm-swoop
        help-fns+
        highlight-indentation
        ht
        htmlize
        idle-highlight-mode
        ido-vertical-mode
        indium
        inf-ruby
        irony-eldoc
        irony-mode
        js2-mode
        js2-refactor
        json-reformat
        key-chord
        levenshtein
        lua-mode
        markdown-mode
        midje-mode
        migemo
        multiple-cursors
        omnisharp-mode
        org-mode
        pcre2el
        popup
        popwin
        pos-tip
        powerline
        projectile
        py-autopep8
        python-pep8
        quickrun
        rainbow-delimiters
        rbenv
        recentf-ext
        request
        rjsx-mode
        rubocop
        rust-mode
        scheme-complete
        slime-company
        smartparens
        smartrep
        smex
        swank-js
        switch-window
        terraform-mode
        tide
        toml-mode
        typescript-mode
        undo-tree
        use-package
        visual-regexp-steroids
        web-mode
        xref-js2
        yaml-mode
        yasnippet
        ;;##)
        ))

(defvar my/bundle-list '() "A list to install for el-get-bundle ")
(setq my/bundle-list     '(
                           ;;##(
						   emacs-lsp/lsp-mode
						   emacs-lsp/lsp-ui
						   tigersoldier/company-lsp
                           (emacs-codic :type github :pkgname "syohex/emacs-codic" )
                           (magit/magit :load-path "lisp")
                           (magit/transient :load-path "lisp")
                           (rtags :branch "v2.38")
                           (search-web :type github :pkgname "tomoya/search-web.el")
                           (yuutayamada/mykie-el :load-path "lisp")
                           ;; racer-rust/emacs-racer
                           Malabarba/beacon
                           RadekMolenda/yaml-tomato
                           ShingoFukuyama/emacs-emoji-cheat-sheet
                           abingham/codesearch.el
                           abo-abo/swiper
                           bmag/imenu-list
                           company-mode/company-mode
                           dgutov/robe
                           emacs-helm/helm-w3m
                           emacs-jp/helm-migemo
                           emacs-jp/init-loader
                           emacs-lsp/dap-mode
                           favadi/flycheck-gometalinter
                           jcpetkovich/shrink-whitespace.el
                           john2x/jenkinsfile-mode
                           larstvei/ox-gfm
                           ljos/jq-mode
                           magit/with-editor
                           ptrv/company-lua
                           ptrv/helm-smex
                           purcell/exec-path-from-shell
                           senny/emacs-eclim
                           ssm/vcl-mode
                           syl20bnr/emacs-emoji-cheat-sheet-plus
                           titaniumbones/ox-slack
                           yasuyk/helm-git-grep
                           yasuyk/web-beautify
                           yuya373/emacs-slack
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
