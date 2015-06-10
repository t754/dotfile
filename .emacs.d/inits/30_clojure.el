(require 'clojure-mode)
(require 'cider)

(require 'clojure-cheatsheet)
(require 'slamhound)



;; 'C-x b' した時に *nrepl-connection* と *nrepl-server* のbufferを一覧に表示しない
(setq nrepl-hide-special-buffers t)

;; RELPのbuffer名を 'project名:nREPLのport番号' と表示する
;; project名は project.clj で defproject した名前
(setq nrepl-buffer-name-show-port t)
(add-hook 'clojure-mode-hook 'cider-mode)
(add-hook 'cider-mode-hook #'eldoc-mode)
(setq cider-show-error-buffer 'except-in-repl)
(setq ac-quick-help-delay 0.5)
(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
;; 
;; ;; mini bufferに関数の引数を表示させる
;; (add-hook 'cider-mode-hook #'cider-turn-on-eldoc-mode)



;;;; ----------------------------
;;;; AAAAAAAAACCCCCCCCCCCC
(require 'auto-complete-config)
(ac-config-default)

(require 'ac-cider)
(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)
(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))

(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)
;;;; ----------------------------

(defun clojure-auto-complete ()
  (interactive)
  (let ((ac-sources
         `(ac-source-nrepl-ns
           ac-source-nrepl-vars
           ac-source-nrepl-ns-classes
           ac-source-nrepl-all-classes
           ac-source-nrepl-java-methods
           ac-source-nrepl-static-methods
           ,@ac-sources)))
    (auto-complete)))


;; M-x clojure-cheatsheetで以下のサイトにある情報(同じもの？)を参照できる。 helm 可
;; M-x slamhoundすると , 必要なpackageを自動でrequrieしてくれるツール。
(add-hook 'clojure-mode-hook
          (lambda()
            (define-clojure-indent
              (defroutes 'defun)
              (GET 2)
              (POST 2)
              (PUT 2)
              (DELETE 2)
              (HEAD 2)
              (ANY 2)
              (context 2))))
