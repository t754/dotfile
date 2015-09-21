;; (require 'cl)
;; (require 'yasnippet)

;; 問い合わせを簡略化 yes/no を y/n
(fset 'yes-or-no-p 'y-or-n-p)

(yas-global-mode 1)
;; ~/.emacs.d/にsnippetsというフォルダを作っておきましょう
(setq yas-snippet-dirs '("~/.emacs.d/snippets") ;; 作成するスニペットはここに入る
      )

;;(setq yas-wrap-around-region nil)
;;(setq )
 ;;; 単語展開キーバインド (ver8.0から明記しないと機能しない)
 ;;; (setqだとtermなどで干渉問題ありでした)
 ;;; もちろんTAB以外でもOK 例えば "C-;"とか
;; (defun my-yas/prompt (prompt choices &optional display-fn)
;;   (let* ((names (loop for choice in choices
;;                       collect (or (and display-fn (funcall display-fn choice))
;;                                   coice)))
;;          (selected (helm-other-buffer
;;                     `(((name . ,(format "%s" prompt))
;;                        (candidates . names)
;;                        (action . (("Insert snippet" . (lambda (arg) arg))))))
;;                     "*helm yas/prompt*")))
;;     (if selected
;;         (let ((n (position selected names :test 'equal)))
;;           (nth n choices))
;;       (signal 'quit "user quit!"))))

;;(custom-set-variables '(yas/prompt-functions '(my-yas/prompt)))
(custom-set-variables '(yas-trigger-key "TAB"))

(defalias 'yas--template-file 'yas--template-get-file)

(setq yas-prompt-functions '(yas-ido-prompt yas-x-prompt yas-dropdown-prompt yas-completing-prompt yas-no-prompt))

;;(define-key yas-minor-mode-map (kbd "TAB") nil)
;;(define-key yas-minor-mode-map (kbd "C-;") 'yas-expand)

(bind-keys :map yas-minor-mode-map
           ("C-c y" .   helm-yas-complete)
           ("C-c i i" . helm-yas-complete);; 既存スニペットを挿入する
           ;; ("C-c i i" . yas-insert-snippet);; 既存スニペットを挿入する
           ("C-c i n" . yas-new-snippet);; 新規スニペットを作成するバッファを用意する
           ("C-c i v" . yas-visit-snippet-file));; 既存スニペットを閲覧・編集する
