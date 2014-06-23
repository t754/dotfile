
;;;;フォントの設定
;|||||||||||||||||||||||||||||
;あ|||||||||||||||||||||||||||
;ああ|||||||||||||||||||||||||
;あああ|||||||||||||||||||||||
;ああああ|||||||||||||||||||||
;あああああ|||||||||||||||||||
;ああああああ|||||||||||||||||
;あ|||||||||||||||||||||||||||
;;  フォントファミリ (pp (font-family-list))
;; (setq default-frame-alist '((font . "VL ゴシック-16")))
(cond
 ((equal system-name "utrtamako")
  (setq default-frame-alist '((font . "Ricty-18")))
  (set-frame-font "Ricty-18")
  (set-face-attribute 'default nil
    	    :family "Ricty"
    	    :height 180))
 
 ((equal system-name "localhost.localdomain")
   (set-frame-font "Ricty-12")
   (set-face-attribute 'default nil
     	    :family "Ricty"
     	    :height 120)
  (setq default-frame-alist '((font . "Ricty-12")))
  )
 )





;; (set-fontset-font nil 'japanese-jisx0208
;; 				  (font-spec :family "Migu 1M"))
;; (setq face-font-rescale-alist '(("Migu 1M" . 1.08)))







