
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional

(defun python-mode-hooks ()
  (when (require 'highlight-indentation nil t)
    (highlight-indentation-mode)
    (highlight-indentation-current-column-mode)
    (set-face-background 'highlight-indentation-face "gray4")
    (set-face-background 'highlight-indentation-current-column-face "gray20"))

  (when (require 'whitespace nil t)
    (setq whitespace-style '(face; faceで可視化
                             trailing; 行末
                             tabs   ; タブ
                             spaces         ; スペース
                             empty          ; 先頭/末尾の空行
                             space-mark     ; 表示のマッピング
                             tab-mark
                             ))
    ;; (setq whitespace-display-mappings
    ;;       '((space-mark   ?\    [?\xB7]     [?.])    ; space
    ;;        (space-mark   ?\xA0 [?\xA4]     [=?_])=
    ;;         (newline-mark ?\n   [?\xB6 ?\n] [?$ ?\n])    ; end-of-line
    ;;         ))
    (setq whitespace-display-mappings
          '((space-mark ?\u3000 [?\u25a1])
            ;; WARNING: the mapping below has a problem.
            ;; When a TAB occupies exactly one column, it will display the
            ;; character ?\xBB at that column followed by a TAB which goes to
            ;; the next TAB column.
            ;; If this is a problem for you, please, comment the line below.
            (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
    ;; スペースは全角のみを可視化
    (setq whitespace-space-regexp "\\(\u3000+\\)")
    ;; 保存前に自動でクリーンアップ
    ;;(setq whitespace-action '(auto-cleanup))
    ;;(global-whitespace-mode 1)f
    (setq-default tab-width 4 indent-tabs-mode t)
    (defvar my/bg-color "#232323")
    (set-face-attribute 'whitespace-trailing nil
                        :background my/bg-color
                        :foreground "DeepPink"
                        :underline t)
    (set-face-attribute 'whitespace-tab nil
                        :background my/bg-color
                        :foreground "LightSkyBlue"
                        :underline t)
    (set-face-attribute 'whitespace-space nil
                        :background my/bg-color
                        :foreground "GreenYellow"
                        :weight 'bold)
    (set-face-attribute 'whitespace-empty nil
                        :background "#000000")
    (set-face-attribute 'whitespace-hspace nil
                        :background my/bg-color
                        :foreground "#000000"
                        :underline t)

    ;;(set-face-underline  'whitespace-space t)
    (setq whitespace-space 'underline)
    ;; (setq whitespace-display-mappings
    ;;           '((space-mark   ?\    [?\xB7]     [?.])    ; space
    ;;             (space-mark   ?\xA0 [?\xA4]     [?_])    ; hard space
    ;;             (newline-mark ?\n   [?\xB6 ?\n] [?$ ?\n])    ; end-of-line
    ;;             ))
    (whitespace-mode)
    (require 'flymake-python-pyflakes)
    (flymake-python-pyflakes-load)
    ;; (require 'smartrep)
    ;; (smartrep-define-key
    ;;     global-map "M-g" '(("M-n" . 'flymake-goto-next-error)
    ;;                        ("M-p" . 'flymake-goto-prev-error)))
    ;; (define-key python-mode-map (kbd "C-c f") 'flymake-goto-next-error)
    (define-key python-mode-map (kbd "M-<left>")  'python-indent-shift-left)
    (define-key python-mode-map (kbd "M-<right>")  'python-indent-shift-right)
    ))

(add-hook 'python-mode-hook 'python-mode-hooks)

;;(add-hook 'python-mode-hook
;;          (lambda ()
;;            (progn
;; ;              (setq whitespace-line-column 79)
;;              (setq whitespace-style '(face lines-tail))
;;              (whitespace-mode))))
;;(add-hook  'python-mode-hook 'whitespace-mode)
;;(global-whitespace-mode 1)
;;(set-face-foreground 'whitespace-space "LightSlateGray")
;;(set-face-background 'whitespace-space "DarkSlateGray")
;;(set-face-foreground 'whitespace-tab "LightSlateGray")
;;(set-face-background 'whitespace-tab "DarkSlateGray")

