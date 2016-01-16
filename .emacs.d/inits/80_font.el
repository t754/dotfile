
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
  (dolist (xxx '(katakana-jisx0201
                 japanese-jisx0208
                 japanese-jisx0212
                 japanese-jisx0213-1
                 japanese-jisx0213-2))
    (set-fontset-font t
                      xxx
                      (font-spec
                       :family family-name
                       :height font-sizee)
                       nil 'prepend)))
  ;; (add-to-list 'face-font-rescale-alist
  ;;              '(concat ".*" family-name ".*") . (/ alphabet-size 100.0))



(defun my/font-size ()
  (cond
   ((equal system-name "utrtamako") 14)
   ((some (lambda (strs) (equal system-name strs))
          '("localhost.localdomain"
            "localhost.homenetwork"
            "localhostss")) 12)))

(defun --set-emoji-font (frame)
  "Adjust the font settings of FRAME so Emacs can display emoji properly."
  (if (eq system-type 'darwin)
      ;; For NS/Cocoa
      (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") frame 'prepend)
    ;; For Linux
    (set-fontset-font t 'symbol (font-spec :family "Noto Emoji") frame 'prepend)))
;; (set-fontset-font t 'symbol   (font-spec :family ) frame 'prepend)
;; For when Emacs is started in GUI mode:
(--set-emoji-font nil)
;; Hook for when a frame is created with emacsclient
;; see https://www.gnu.org/software/emacs/manual/html_node/elisp/Creating-Frames.html
(add-hook 'after-make-frame-functions '--set-emoji-font)


(let* ((m-font "Ricty")
         (m-size (my/font-size))
         (m-fontsize (string-join (list m-font "-" (int-to-string m-size)))))
    (set-frame-font   m-fontsize)
    (set-default-font m-fontsize)
    (set-face-attribute 'default nil
                        :family m-font
                        :height (* m-size 10))
    (setq default-frame-alist `((font . ,m-font)))
    (my/font-set m-font (* m-size 10))

    (custom-set-faces
     ;; custom-set-faces was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
     '(bold ((t (:weight bold :height 0.8))))
     '(git-gutter:added    ((t (:weight bold :height 0.8 :foreground "green"))))
     '(git-gutter:deleted  ((t (:weight bold :height 0.8 :foreground "red"))))
     '(git-gutter:modified ((t (:weight bold :height 0.8 :foreground "magenta"))))))



;; (my/font-set "RictyDiminished" 120)
;; (set-fontset-font nil 'japanese-jisx0208
;;                (font-spec :family "Migu 1M"))
;; (setq face-font-rescale-alist '(("Migu 1M" . 1.08)))
