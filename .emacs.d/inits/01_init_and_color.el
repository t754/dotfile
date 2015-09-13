;;オートセーブ、バックアップ用 作成先を変更
;;(require 'auto-save-buffers)
;;(run-with-idle-timer 0.5 t 'auto-save-buffers)
(setq auto-save-timeout               20  ; 自動保存する間隔。秒。
      auto-save-interval              150 ; 300打鍵ごとに自動保存
      make-backup-files               t       ; バックアップファイルを作成する。
      backup-directory-alist          (cons (cons "\\.*$" (expand-file-name "~/.backup")) backup-directory-alist)
      version-control                 t; 複数のバックアップを残します。世代。
      kept-new-versions               5   ; 新しいものをいくつ残すか
      kept-old-versions               5   ; 古いものをいくつ残すか
      delete-old-versions             t ; 確認せずに古いものを消す。
      vc-make-backup-files            nil ;; バージョン管理下のファイルもバックアップを作る。leの保存`場所を指定。
      auto-save-file-name-transforms  `((".*" ,(expand-file-name "~/.backup") t)) ;;create backup file in ~/.buckup
      create-lockfiles                nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq linum-delay t)
(defadvice linum-schedule (around my-linum-schedule () activate)
  (run-with-idle-timer 0.2 nil #'linum-update-current))


;; 行番号をデフォルトで表示
;; (when (require 'linum nil t)
;;  (global-linum-mode t)
;;  (line-number-mode t)
;;  (column-number-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ハイパーリンク (cygwinの場合)

(defun browse-url-chrome (url &optional new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (start-process "cygstart" nil "cygstart"
                 url))
;(setq browse-url-browser-function 'browse-url-chrome)

                                        ;firefox の場合
;; (setq browse-url-browser-function 'browse-url-firefox)
 (setq browse-url-generic-program (executable-find "firefox")
          browse-url-browser-function 'browse-url-generic)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;tab -> 空白に
(setq-default tab-width 4 indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)
;; 末尾空白
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
;; "yes or no"を"y or n"に
(fset 'yes-or-no-p 'y-or-n-p)
(custom-set-variables
  '(tab-width 4))

;;;; 色設定
;; (custom-set-faces)
;;; ツールバーを消す
(tool-bar-mode 0)
;;大文字小文字を区別しない
(setq completion-ignore-case t
;;起動画面いれない
      inhibit-startup-message t)


;; ;;;;;;
;; 行末のスペース + ファイル末尾の連続する改行の除去を行う
(defvar my/current-cleanup-state "")
(defun my/cleanup-for-spaces ()
  (interactive)
  (delete-trailing-whitespace)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))

(add-hook 'before-save-hook 'my/cleanup-for-spaces)

(setq-default mode-line-format
              (cons '(:eval my/current-cleanup-state)
                    mode-line-format))

(defun toggle-cleanup-spaces ()
  (interactive)
  (cond ((memq 'my/cleanup-for-spaces before-save-hook)
         (setq my/current-cleanup-state
               (propertize "[DT-]" 'face '((:weight bold))))
         (remove-hook 'before-save-hook 'my/cleanup-for-spaces))
        (t
         (setq my/current-cleanup-state "")
         (add-hook 'before-save-hook 'my/cleanup-for-spaces)))
  (force-mode-line-update))


(setq-default gc-cons-threshold (* gc-cons-threshold 8))
;;
(savehist-mode 1)
(require 'saveplace nil t)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/saved-places")
;;
(scroll-bar-mode -1)
;;
(global-set-key (kbd "M-/") 'hippie-expand)
(setq
 ;; クリップボードでコピー＆ペーストできるようにする
 x-select-enable-clipboard t
 ;; PRIMARY selectionを使う(Windowsでは対象外)
 x-select-enable-primary t
 ;; クリップボードでコピー・カットした文字列を
 ;; キルリングにも保存させる
 save-interprogram-paste-before-kill t
 ;; M-x apropos等でより多くのシンボルを見つけるようにする
 ;; ただし、ちょっと遅くなる
 ;;
 ;; M-x apropos-user-optionはすべての変数を
 ;; M-x apropos-commandはすべての関数を
 ;; M-x apropos-commandはすべてのシンボル(関数、変数、フェイス以外も)
 ;; M-x apropos-valueは属性リストや関数内も
 ;; M-x apropos-documentationはetc/DOC以外のすべての説明文字列も
 apropos-do-all t
 ;; マウスでyankしたとき、クリックした場所ではなくて現在位置を対象に
 mouse-yank-at-point t
 ;; 保存時にファイル末尾に改行を入れる
 require-final-newline t
 ;; エラー時などはベル音ではなくて画面を1回点滅させる
 visible-bell t
 ;; ediff時に新しいフレームを作らない(シンプルになる)
 ediff-window-setup-function 'ediff-setup-windows-plain
 ;; バックアップファイルはカレントディレクトリではなく
 ;; ~/.emacs.d/backups 以下に保存する
 backup-directory-alist `(("." . ,(concat user-emacs-directory
                                          "backups"))))
 (menu-bar-mode -1)
