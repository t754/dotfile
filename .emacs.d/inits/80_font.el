
;;;;フォントの設定
;;|||||||||||||||||||||||||||||
;;あ|||||||||||||||||||||||||||
;;ああ|||||||||||||||||||||||||
;;あああ|||||||||||||||||||||||
;;ああああ|||||||||||||||||||||
;;あああああ|||||||||||||||||||
;;ああああああ|||||||||||||||||
;;あ|||||||||||||||||||||||||||-_.
;;ああああああ'''''''''''''''''
;;ああああああ:::::::::::::::::
;;ああああああ^^^^^^^^^^^^^^^^^
;;ああああああ;;;;;;;;;;;;;;;;;
;;ああああああ`````````````````
;;ああああああ,,,,,,,,,,,,,,,,,
;;ああああああ.................
;;ああああああ"""""""""""""""""


;;  フォントファミリ (pp (font-family-list))
;; (setq default-frame-alist '((font . "VL ゴシック-16")))
(cond
 ((equal system-name "utrtamako")
  (setq default-frame-alist '((font . "Ricty Discord4Powerline")))
  (set-frame-font "Ricty Discord4Powerline-18")
  ;; (set-face-attribute 'default nil
  ;;   	    :family "Ricty"
  ;;   	    :height 120)
  (set-face-attribute 'default nil
                    :family "Ricty Discord4Powerline"
                    :height 150)
  ;; (set-fontset-font (frame-parameter nil 'font)
  ;;                 'japanese-jisx0208
  ;;                 (cons "Ricty Discord" "iso10646-1"))
  ;; (set-fontset-font (frame-parameter nil 'font)
  ;;                 'japanese-jisx0212
  ;;                 (cons "Ricty Discord" "iso10646-1"))
  ;; (set-fontset-font (frame-parameter nil 'font)
  ;;                 'katakana-jisx0201
  ;;                 (cons "Ricty Discord" "iso10646-1"))
  )
  ((equal system-name "localhostss")
   (set-frame-font "Ricty-12")
   (set-face-attribute 'default nil
     	    :family "Ricty"
     	    :height 120)
  (setq default-frame-alist '((font . "Ricty-12")))
  )
  ((equal system-name "localhost.localdomain")
   (set-frame-font "Ricty Discord4Powerline-12")
   (set-face-attribute 'default nil
     	    :family "Ricty Discord4Powerline"
     	    :height 120)
  (setq default-frame-alist '((font . "Ricty Discord4Powerline-12")))
  )
  
 )

 



;; (set-fontset-font nil 'japanese-jisx0208
;; 				  (font-spec :family "Migu 1M"))
;; (setq face-font-rescale-alist '(("Migu 1M" . 1.08)))







