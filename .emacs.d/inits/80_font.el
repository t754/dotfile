
;;;;フォントの設定

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Source Han Code JP
;;123 123 123 123 123123123123
;;あい うえ おか きく
;;''' ||| @@@ jfe
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; | aaaいう  | bngs     |
;; | fjdsa   | jdfあfda |


;;::::::::::::::
;;^^^^^^^^^^^^^^
;;;;;;;;;;;;;;;;
;;``````````````
;;,,,,,,,,,,,,,,
;;..............
;;""""""""""""""
;;--------------
;;++++++++++++++
;;||||||||||||||
;;==============
;;<<<<<<<<<<<<<<
;;>>>>>>>>>>>>>>
;;DZ70lrz  0
;;|||||||||||||||||||||||||||||
;;あ|||||||||||||||||||||||||||
;;ああ----|||||||||||||||||||||
;;あああ____|||||||||||||||||||
;;ああああ....|||||||||||||||||
;;あああああ|||||||||||||||||||
;;ああああああ|||||||||||||||||
;;あ|||||||||||||||||||||||||||
;;ああああああ'''''''''''''''''

;; fontforge -script ricty_discord_patch.pe -0 -7 -colon -semicolon -z -bar -Z -circum -grave -period -hyphen -quote -quotedbl Ricty-Regular.ttf Ricty-Bold.ttf

;;  フォントファミリ (pp (font-family-list))
;; (setq default-frame-alist '((font . "VL ゴシック-16")))

  


;; family-name → "RictyDiminished"
(defun my/font-set (family-name font-sizee)
  ;; 120 90 1.2
  (dolist (xxx '(katakana-jisx0201 japanese-jisx0208 japanese-jisx0212))
    (set-fontset-font (frame-parameter nil 'font)
                      xxx
                      (font-spec
                       :family family-name 
                       :height font-sizee)
                      ))
    ;; (add-to-list 'face-font-rescale-alist
  ;;              '(concat ".*" family-name ".*") . (/ alphabet-size 100.0))
  
    )


(cond
 ( (equal system-name "utrtamako" )
   ;; (setq default-frame-alist '((font . "Source Han Code JP")))
   ;; (set-frame-font "Source Han Code JP-16")
   (setq default-frame-alist '((font . "Ricty Discord4Powerline:pixelsize=16")))
   (set-frame-font "Ricty Discord4Powerline:pixelsize=16")
   )
 ((equal system-name "zenlap.zendomain" )
  (setq default-frame-alist '((font . "Migu 1m")))
  (set-frame-font "Migu 1m-18")
  ;; (set-face-attribute 'default nil
  ;;   	    :family "Ricty"
  ;;   	    :height 120)
  
  (set-face-attribute 'default nil
                      :family "Migu 1m"
                      :height 150)
  ;;  (set-fontset-font (frame-parameter nil 'font)
  ;;                  'japanese-jisx0208
  ;;                  (cons "Migu 1m" "iso10646-1"))
  ;;  (set-fontset-font (frame-parameter nil 'font)
  ;;                  'japanese-jisx0212
  ;;                  (cons "Migu 1m" "iso10646-1"))
  ;;  (set-fontset-font (frame-parameter nil 'font)
  ;;                  'katakana-jisx0201
  ;;                  (cons "Migu 1m" "iso10646-1"))
  )

 ((some (lambda (strs) (equal system-name strs))
        '("localhost.localdomain"
          "localhost.homenetwork"
          "localhostss"))
  (set-frame-font "Ricty-12")
  (set-face-attribute 'default nil
                      :family "Ricty"
                      :height 120)
  (add-to-list 'default-frame-alist '((font . "Ricty-12"))))
  ;; (my/font-set "RictyDiminished" 120)
  
  )

;; (set-fontset-font nil 'japanese-jisx0208
;; 				  (font-spec :family "Migu 1M"))
;; (setq face-font-rescale-alist '(("Migu 1M" . 1.08)))








