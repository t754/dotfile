										;C-hで バックスペース
;;C-m 改行&インデント
;;(global-set-key (kbd "C-m") 'newline-and-indent)
;;goto-line
;; (global-set-key (kbd "C-c g") 'goto-line)

;;smart-compile
;; (global-set-key (kbd "C-c p") 'smart-compile)
;; (define-key mode-specific-map (kbd "C-c p") 'compile)
;; (define-key mode-specific-map "e" 'next-error)

(defun kill-whitespace ()
          "Kill the whitespace between two non-whitespace characters"
          (interactive "*")
          (save-excursion
            (save-restriction
              (save-match-data
                (progn
                  (re-search-backward "[^ \t\r\n]" nil t)
                  (re-search-forward "[ \t\r\n]+" nil t)
                  (replace-match "" nil nil))))))
(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
   Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))

(defun other-window-or-split ()
  (interactive)
  (when (one-window-p) (split-window-horizontally))
  (other-window 1))

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
    (4  (delete-other-windows))
    (16 (delete-window))
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



(unbind-key "C-z")

(bind-keys*
 ("C-c p"		.	quickrun)
 ("C-c m"		.	minimap-toggle)
 ("C-c C-r"		.	window-resizer)
 ("M-\\"		.	kill-whitespace)
 ("C-`"			.	push-mark-no-activate)
 ;; ("C-h"     . delete-backward-char)
 ("C-t"			.	other-window-or-split-or-close)
 ("C-z"			.	scroll-down-command)
 ("C-c l"		.	toggle-truncate-lines)
 ("C-a"			.	beginning-of-indented-line)
 ("C-x C-c"		.	my-save-buffers-kill-emacs)
 ("C-c <f5>"	.	revert-buffer-no-confirm)
 ("C-M-t"		.	mc/mark-all-in-region)
 )

(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))


(bind-key "C-x @ C" 'event-apply-control-shift-modifier function-key-map)


