
;;オートセーブ、バックアップ用 作成先を変更
;;(require 'auto-save-buffers)
;;(run-with-idle-timer 0.5 t 'auto-save-buffers) 
(setq auto-save-timeout 20)   ; 自動保存する間隔。秒。
(setq auto-save-interval 150) ; 300打鍵ごとに自動保存
(setq make-backup-files t)       ; バックアップファイルを作成する。
(setq backup-directory-alist
(cons (cons "\\.*$" (expand-file-name "~/.backup"))
backup-directory-alist))
;;;backupfi(setq version-control t)     
(setq version-control t); 複数のバックアップを残します。世代。
(setq kept-new-versions 5)   ; 新しいものをいくつ残すか
(setq kept-old-versions 5)   ; 古いものをいくつ残すか
(setq delete-old-versions t) ; 確認せずに古いものを消す。
(setq vc-make-backup-files t) ;; バージョン管理下のファイルもバックアップを作る。leの保存`場所を指定。
;;create backup file in ~/.buckup
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.backup") t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 行番号をデフォルトで表示
(when (require 'linum nil t)
	(global-linum-mode t)
	(line-number-mode t) 
	(column-number-mode t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ハイパーリンク (cygwinの場合)

(defun browse-url-chrome (url &optional new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (start-process "cygstart" nil "cygstart"
				 url))
;(setq browse-url-browser-function 'browse-url-chrome)

										;firefox の場合
(setq browse-url-browser-function 'browse-url-firefox)


;; 
;;(setq default-frame-alist
;;      (append (list 
;;;       '(foreground-color . "azure3") ;;; 文字の色を設定します。
;;; 	'(background-color . "black") ;; 背景色を設定します。
;;;	'(border-color . "black") ;;
;;;	'(mouse-color . "white") ;;マウスポインタ
;;;	'(cursor-color . "white") ;;\カーソルカラー
;; 			   '(top . 0)
;; 			   '(left .  0) ; フレームの X 位置(ピクセル数)
;; 			   '(width . 188)  ;; <- 幅
;; 			   '(height . 38)  ;; <- 高さ
;; 			   '(alpha . (85 40)) ;透明度 ？ 
;; 			   )
;;;; 			  default-frame-alist))
;;;;; 新規フレームのデフォルト設定
;;(setq default-frame-alist
;; 	  (append
;; 	   '((width				  . 188); フレーム幅(文字数)
;; 		 (height			  . 38); フレーム高(文字数)
;; 	   default-frame-alist)))
;; (frame-width)
;; (frame-height)
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;tab -> 空白に
(setq-default tab-width 4 indent-tabs-mode nil)
;; "yes or no"を"y or n"に
(fset 'yes-or-no-p 'y-or-n-p)
(custom-set-variables
  '(tab-width 4))
(custom-set-faces)
;;; ツールバーを消す
(tool-bar-mode 0)
;;大文字小文字を区別しない
(setq completion-ignore-case t)
;;起動画面いれない
(setq inhibit-startup-message t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;かっこの強調
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face "grey30")
(set-face-underline-p 'show-paren-match-face "red")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
