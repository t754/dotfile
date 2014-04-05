(require 'cl)
;; 問い合わせを簡略化 yes/no を y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; yasnippetを置いているフォルダにパスを通す
;;(add-to-list 'load-path
;;             (expand-file-name "~/.emacs.d/elisp/yasnippet"))
(require 'yasnippet)
(yas-global-mode 1)
;; ~/.emacs.d/にsnippetsというフォルダを作っておきましょう
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets" ;; 作成するスニペットはここに入る
		))



;;(setq yas-wrap-around-region nil)
;;(setq )
 ;;; 単語展開キーバインド (ver8.0から明記しないと機能しない)
 ;;; (setqだとtermなどで干渉問題ありでした)
 ;;; もちろんTAB以外でもOK 例えば "C-;"とか
(defun my-yas/prompt (prompt choices &optional display-fn)
  (let* ((names (loop for choice in choices
                      collect (or (and display-fn (funcall display-fn choice))
                                  coice)))
         (selected (helm-other-buffer
                    `(((name . ,(format "%s" prompt))
                       (candidates . names)
                       (action . (("Insert snippet" . (lambda (arg) arg))))))
                    "*helm yas/prompt*")))
    (if selected
        (let ((n (position selected names :test 'equal)))
          (nth n choices))
      (signal 'quit "user quit!"))))
(custom-set-variables '(yas/prompt-functions '(my-yas/prompt)))


(custom-set-variables '(yas-trigger-key "TAB"))


;;(define-key yas-minor-mode-map (kbd "TAB") nil)
;;(define-key yas-minor-mode-map (kbd "C-;") 'yas-expand)
;; 既存スニペットを挿入する
(define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
;; 新規スニペットを作成するバッファを用意する
;; fine-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
;; 既存スニペットを閲覧・編集する
;; fine-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)
   ;; (add-hook 'org-mode-hook
   ;;                  (lambda ()
   ;;                    (make-variable-buffer-local 'yas/trigger-key)
   ;;                    (setq yas/trigger-key [tab])
   ;;                    (add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
   ;;                    (define-key yas/keymap [tab] 'yas/next-field)))




