;; ;;smart-compile
;; (require 'smart-compile)
;; (setq compilation-window-height 10)
;; (add-to-list 'smart-compile-alist
;;           '("\\.py\\'"         . "python %f"))
;; (add-to-list 'smart-compile-alist
;;           '("\\.c\\'"          . "gcc -O0 -g %f -lm -o %n"))
;; (add-to-list 'smart-compile-alist
;;           '("\\.[Cc]+[Pp]*\\'" . "g++ -O0 -g %f -lm -o %n"))


;; =++++++++++++++++++++==++++++++++++=+++++++++++=+++++++++
;; quickrun.el
;; (require 'quickrun)
(push '("*quickrun*") popwin:special-display-config)

