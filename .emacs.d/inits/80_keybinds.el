(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
   Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))
(defun split-window-vertically-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-vertically)
    (progn
      (split-window-vertically
       (- (window-height) (/ (window-height) num_wins)))
      (split-window-vertically-n (- num_wins 1)))))
(defun split-window-horizontally-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-horizontally)
    (progn
      (split-window-horizontally
       (- (window-width) (/ (window-width) num_wins)))
      (split-window-horizontally-n (- num_wins 1)))))

(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (if (>= (window-body-width) 230)
        (split-window-horizontally-n 3)
      (split-window-horizontally)))
  (switch-window))

;; \C-aでインデントを飛ばした行頭に移動
(defun beginning-of-indented-line (current-point)
  "インデント文字を飛ばした行頭に戻る。ただし、ポイントから行頭までの間にインデント文字しかない場合は、行頭に戻る。"
  (interactive "d")
  (if (string-match
       "^[ ¥t]+$"
       (save-excursion
         (buffer-substring-no-properties
          (progn (beginning-of-line) (point))
          current-point)))
      (beginning-of-line)
    (back-to-indentation)))

;;;** 上に加えてC-uが付いていたら画面を閉じる
(defun other-window-or-split-or-close (arg)
  "画面が1つなら分割、2つ以上なら移動。
C-uをつけるとウィンドウを閉じる。"
  (interactive "p")
  (case arg
    (16  (delete-other-windows))
    (4 (delete-window))
    (t  (other-window-or-split))))

;;;;C-x C-c で消すとき確認を問う
(defun my-save-buffers-kill-emacs ()
  (interactive)
  (if (y-or-n-p "quit emacs? ")
      (save-buffers-kill-emacs)))

;;ターミナル上で C+S+? をつかう C-x @ C ?
(defun event-apply-control-shift-modifier (ignore-prompt)
  "\\Add the Control+Shift modifier to the following event.
For example, type \\[event-apply-control-shift-modifier] SPC to enter Control-Shift-SPC."
  (vector (event-apply-modifier
           (event-apply-modifier (read-event) 'shift 25 "S-")
           'control 26 "C-")))

;; 再読み込み
(defun revert-buffer-no-confirm (&optional force-reverting)
  "Interactive call to revert-buffer. Ignoring the auto-save
 file and not requesting for confirmation. When the current buffer
 is modified, the command refuses to revert it, unless you specify
 the optional argument: force-reverting to true."
  (interactive "P")
  ;;(message "force-reverting value is %s" force-reverting)
  (if (or force-reverting (not (buffer-modified-p)))
      (revert-buffer :ignore-auto :noconfirm)
    (error "The buffer has been modified")))


(defun my/kill-line (arg)
  (interactive "p")
  (case arg
    (4 (delete-horizontal-space))
    (16 (kill-line 0))
    (t (kill-line))))

(unbind-key "C-z")

(define-key global-map (kbd "C-k") 'my/kill-line) ;;mozc の時のカタカタ変換がきえるため

(bind-keys*
 ("C-a"       . beginning-of-indented-line)
 ("C-x C-z"   . helm-M-x)
 ("C-x M-x"   . helm-M-x)
 ("C-x b"     . helm-buffers-list)
 ("C-x C-b"   . helm-for-files)
 ("C-<f6>"    . helm-ls-git-ls)
 ("C-'"       . imenu-list-minor-mode)
 ("C-x C-r"   . helm-recentf)
 ("M-r"       . helm-resume)
 ("M-y"       . helm-show-kill-ring)
 ("M-\\"      . shrink-whitespace)
 ("C-M-t"     . mc/mark-all-in-region)
 ("C-c m"     . minimap-toggle)
 ("C-x C-c"   . my-save-buffers-kill-emacs)
 ("C-t"       . other-window-or-split-or-close)
 ("C-`"       . push-mark-no-activate)
 ("C-c p"     . quickrun)
 ("C-<f5>"    . revert-buffer-no-confirm)
 ("C-z"       . scroll-down-command)
 ("C-c l"     . toggle-truncate-lines)
 ("C-c <down>"  . windmove-down)
 ("C-c <left>"  . windmove-left)
 ("C-c <right>" . windmove-right)
 ("C-c <up>"    . windmove-up)
 ("C-c C-r"   . window-resizer)
 ;; ("C-k"       . my/kill-line)
 ("<f9>"      . menu-bar-mode)
 ("M-i"       . ac-complete-with-helm)
 )

(setq switch-window-shortcut-style 'qwerty)

(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

(bind-keys :map goto-map ("M-d" . toggle-cleanup-spaces))

(bind-key "C-x @ C" 'event-apply-control-shift-modifier function-key-map)
