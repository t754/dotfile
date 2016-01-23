;; (require 'cl)
;; (require 'yasnippet)

;; 問い合わせを簡略化 yes/no を y/n
(fset 'yes-or-no-p 'y-or-n-p)
(yas-global-mode 1)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "S-TAB") 'yas/expand)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)


(defalias 'yas--template-file 'yas--template-get-file)

(setq yas-prompt-functions '(yas-ido-prompt yas-x-prompt yas-dropdown-prompt yas-completing-prompt yas-no-prompt))

;;(define-key yas-minor-mode-map (kbd "TAB") nil)
;;(define-key yas-minor-mode-map (kbd "C-;") 'yas-expand)
(defun yas-ido-expand ()
  "Lets you select (and expand) a yasnippet key"
  (interactive)
    (let ((original-point (point)))
      (while (and
              (not (= (point) (point-min) ))
              (not
               (string-match "[[:space:]\n]" (char-to-string (char-before)))))
        (backward-word 1))
    (let* ((init-word (point))
           (word (buffer-substring init-word original-point))
           (list (yas-active-keys)))
      (goto-char original-point)
      (let ((key (remove-if-not
                  (lambda (s) (string-match (concat "^" word) s)) list)))
        (if (= (length key) 1)
            (setq key (pop key))
          (setq key (ido-completing-read "key: " list nil nil word)))
        (delete-char (- init-word original-point))
        (insert key)
        (yas-expand)))))

(bind-keys :map yas-minor-mode-map
           ("C-c y" .   yas-ido-expand)
           ("C-c i i" . yas-ido-expand);; 既存スニペットを挿入する
           ;; ("C-c i i" . yas-insert-snippet);; 既存スニペットを挿入する
           ("C-c i n" . yas-new-snippet);; 新規スニペットを作成するバッファを用意する
           ("C-c i v" . yas-visit-snippet-file));; 既存スニペットを閲覧・編集する
