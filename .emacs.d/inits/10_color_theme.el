;;;;色設定 http://th.nao.ac.jp/MEMBER/zenitani/elisp-j.html#color
;;(set-background-color "#98bc98") ;; background color
;;(set-foreground-color "black")
;;   ;; モードラインの文字の色を設定します。
;;  (set-face-foreground 'modeline "white")
;;  (set-face-background 'modeline "MediumPurple2")
;;  ;; 選択中のリージョンの色を設定します。
;;  (set-face-background 'region "DarkOliveGreen")
;;  ;; モードライン（アクティブでないバッファ）の文字色を設定します。
;;  (set-face-foreground 'mode-line-inactive "LightGray")
;;  ;; モードライン（アクティブでないバッファ）の背景色を設定します。
;;  (set-face-background 'mode-line-inactive "DarkSlateBlue")
;;  (set-cursor-color       "SaddleBrown")
;; (cond ((require 'helm-themes nil t)
;;  'ok
;;  )

(eval-when-compile
  (require 'color-theme))

;; (defun color-theme-molokai ()
;;   "Color theme based on the Molokai color scheme for vim."
;;   (interactive)
;;   (color-theme-install
;;    '(color-theme-molokai ;; カラーテーマ名
;;      ;; 背景・文字・カーソル
;;      ((background-color . "#1B1D1E")
;;       (background-mode . dark)
;;       (foreground-color . "#F8F8F2")
;;       (cursor-color . "#F8F8F0"))

;;      (default ((t (:background "#1B1D1E" :foreground "#F8F8F2"))))

;;      ;; 選択範囲
;;      (region ((t (:background "#403D3D"))))

;;      ;; モードライン
;;      (mode-line ((t (:foreground "#F8F8F2" :background "#000000"
;;                                  :box (:line-width 1 :color "#000000" :style released-button)))))
;;      (mode-line-buffer-id ((t (:foreground nil :background nil))))
;;      (mode-line-inactive ((t (:foreground "#BCBCBC" :background "#333333"
;;                                           :box (:line-width 1 :color "#333333")))))

;;      ;; ハイライト
;;      (highlight ((t (:foreground "#000000" :background "#C4BE89"))))
;;      (hl-line ((t (:background "#293739"))))

;;      ;; 関数名
;;      (font-lock-function-name-face ((t (:foreground "#FFFFFF"))))

;;      ;; 変数名・変数の内容
;;      (font-lock-variable-name-face ((t (:foreground "#FFFFFF"))))
;;      (font-lock-string-face ((t (:foreground "#E6DB74"))))

;;      ;; 特定キーワード
;;      (font-lock-keyword-face ((t (:foreground "#F92672"))))

;;      ;; Boolean
;;      (font-lock-constant-face((t (:foreground "#AE81BC"))))

;;      ;; 括弧
;;      (show-paren-match-face ((t (:foreground "#1B1D1E" :background "#FD971F"))))
;;      (paren-face ((t (:foreground "#A6E22A" :background nil))))

;;      ;; コメント
;;      (font-lock-comment-face ((t (:foreground "#74715D"))))

;;      ;; CSS
;;      (css-selector ((t (:foreground "#66D9EF"))))
;;      (css-property ((t (:foreground "#FD971F"))))

;;      ;; nXML-mode
;;      ;; タグ名
;;      (nxml-element-local-name ((t (:foreground "#F92672"))))
;;      ;; 属性
;;      (nxml-attribute-local-name ((t (:foreground "#66D9EF"))))
;;      ;; 括弧
;;      (nxml-tag-delimiter ((t (:foreground "#A6E22A"))))
;;      ;; DOCTYPE宣言
;;      (nxml-markup-declaration-delimiter ((t (:foreground "#74715D"))))

;;      ;; dired
;;      (dired-directory ((t (:foreground "#A6E22A"))))
;;      (dired-symlink ((t (:foreground "#66D9EF"))))

;;      ;; MMM-mode
;;      (mmm-default-submode-face ((t (:foreground nil :background "#000000"))))
;;      )))

;; (provide 'color-theme-molokai) ;; カラーテーマ名

     ;; (color-theme-robin-hood)
     ;; (color-theme-subtle-hacker)
     ;; (color-theme-matrix)
     ;; (color-theme-montz)
     ;; (color-theme-molokai)
;; (autoload 'color-theme nil t)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
      (color-theme-calm-forest)

      ;;かっこの強調
      (show-paren-mode 1)
      (setq show-paren-delay 0
            show-paren-style 'expression)
      (set-face-background 'show-paren-match-face "grey30")
      (set-face-underline-p 'show-paren-match-face "red")))











