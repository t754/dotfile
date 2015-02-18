										;C-hで バックスペース
(global-set-key (kbd "C-h") 'delete-backward-char)
;;C-m 改行&インデント
;;(global-set-key (kbd "C-m") 'newline-and-indent)
;;goto-line
(global-set-key (kbd "C-c g") 'goto-line)

;;smart-compile
 (global-set-key (kbd "C-c p") 'quickrun)
;; (global-set-key (kbd "C-c p") 'smart-compile)
;; (define-key mode-specific-map (kbd "C-c p") 'compile)
;; (define-key mode-specific-map "e" 'next-error)

;;
(global-set-key (kbd "M-i") 'auto-complete)

(global-set-key (kbd "C-c C-r") 'window-resizer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-t") 'other-window)
;;Windowの切替
;;行の折り返し表示の切替
(global-set-key (kbd "C-c l") 'toggle-truncate-lines)
;; c-zの無効
(global-unset-key "\C-z")
(global-set-key (kbd "C-z") 'scroll-down-command)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
(global-set-key (kbd "C-a") 'beginning-of-indented-line)
;;C-x C-c で消すとき確認を問う

(defun my-save-buffers-kill-emacs ()
  (interactive)
  (if (y-or-n-p "quit emacs? ")
	  (save-buffers-kill-emacs)))
(global-set-key "\C-x\C-c" 'my-save-buffers-kill-emacs)
;;ターミナル上で C+S+? をつかう C-x @ C ?
(defun event-apply-control-shift-modifier (ignore-prompt)

  "\\Add the Control+Shift modifier to the following event.
For example, type \\[event-apply-control-shift-modifier] SPC to enter Control-Shift-SPC."
  (vector (event-apply-modifier
		   (event-apply-modifier (read-event) 'shift 25 "S-")
		   'control 26 "C-")))

(define-key function-key-map (kbd "C-x @ C") 'event-apply-control-shift-modifier)


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



;;バッファの再読み込み
(global-set-key (kbd "C-c <f5>") 'revert-buffer-no-confirm)


