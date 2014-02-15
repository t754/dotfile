; 言語を日本語にする
;(set-language-environment 'Japanese)
;(set-terminal-coding-system 'sjis)
;(set-buffer-file-coding-system 'sjis)
;(set-keyboard-coding-system 'sjis)

; 極力UTF-8とする
;(set-default-coding-systems 'utf-8)

;(set-file-name-coding-system 'cp932)
;(setq locale-coding-system 'cp932)
 ;(set-keyboard-coding-system 'japanese-cp932) ;; おまじないかも
;;(set-file-name-coding-system 'utf-8)
;;(setq locale-coding-system 'utf-8)
;;(set-keyboard-coding-system 'utf-8)
;;(set-language-environment "Japanese")

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8-unix)
(set-buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(setq default-buffer-file-coding-system 'utf-8-unix)
(set-clipboard-coding-system 'utf-8-unix)




;;;;フォントの設定
;|||||||||||||||||||||||||||||
;あ|||||||||||||||||||||||||||
;ああ|||||||||||||||||||||||||
;あああ|||||||||||||||||||||||
;ああああ|||||||||||||||||||||
;あああああ|||||||||||||||||||
;ああああああ|||||||||||||||||
;あ|||||||||||||||||||||||||||
;;   フォントファミリ (pp (font-family-list))
;; (set-face-attribute 'default nil
;; 		    :family "VL ゴシック"
;; 		    :height 108) 
;; (set-fontset-font nil 'japanese-jisx0208
;; 		  (font-spec :family "Migu 1M"))
;; (setq face-font-rescale-alist '(("Migu 1M" . 1.08)))
