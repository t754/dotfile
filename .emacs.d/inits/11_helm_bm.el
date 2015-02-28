;; http://rubikitch.com/f/141122044603.helm-bm.el より
;;; bm.el初期設定
;;; buffer 一行bookmark


(require 'bm)

(defun bm-buffer-restore-safe ()
  (ignore-errors (bm-buffer-restore)))
(add-hook 'find-file-hooks 'bm-buffer-restore-safe)
(add-hook 'kill-buffer-hook 'bm-buffer-save)
(defun bm-save-to-repository ()
  (interactive)
  (unless noninteractive
    (bm-buffer-save-all)
    (bm-repository-save)))
(add-hook 'kill-emacs-hook 'bm-save-to-repository)
(run-with-idle-timer 600 t 'bm-save-to-repository)
(add-hook 'after-revert-hook 'bm-buffer-restore)
(add-hook 'vc-before-checkin-hook 'bm-buffer-save)
(add-hook 'before-save-hook 'bm-buffer-save)



;; 



(setq-default bm-buffer-persistence t)
(setq bm-repository-file "~/.emacs.d/bm-repository")

(setq bm-restore-repository-on-load t)

(add-hook 'find-file-hook 'bm-buffer-restore)
(add-hook 'kill-buffer-hook 'bm-buffer-save)
(add-hook 'after-save-hook 'bm-buffer-save)
(add-hook 'after-init-hook 'bm-repository-load)
(add-hook 'after-revert-hook 'bm-buffer-restore)
(add-hook 'vc-before-checkin-hook 'bm-buffer-save)
(add-hook 'kill-emacs-hook '(lambda nil
                              (bm-buffer-save-all)
                              (bm-repository-save)))
(global-set-key (kbd "M-[") 'bm-previous)
(global-set-key (kbd "M-]") 'bm-next)

(push '(migemo) helm-source-bm)
(setq helm-source-bm (delete '(multiline) helm-source-bm))

;;; helm-bm.el設定
(require 'helm-bm)
(push '(migemo) helm-source-bm)
;; annotationはあまり使わないので仕切り線で表示件数減るの嫌
(setq helm-source-bm (delete '(multiline) helm-source-bm))

(defun bm-toggle-or-helm ()
  "2回連続で起動したらhelm-bmを実行させる"
  (interactive)
  (bm-toggle)
  (when (eq last-command 'bm-toggle-or-helm)
    (helm-bm)))
(global-set-key (kbd "M-SPC") 'bm-toggle-or-helm)

;;; これがないとemacs -Qでエラーになる。おそらくバグ。
(require 'compile)

(global-set-key (kbd "C-x r l") 'helm-bookmarks)
