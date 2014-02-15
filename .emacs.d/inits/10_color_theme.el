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

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-calm-forest)))

