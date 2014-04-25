(require 'multiple-cursors)
(require 'smartrep)

(declare-function smartrep-define-key "smartrep")
;; (global-set-key (kbd "C-M-c") 'mc/edit-lines)
(global-set-key (kbd "C-M-r") 'mc/mark-all-in-region)

(global-unset-key "\C-,")
(smartrep-define-key global-map "\C-,"
  '(("C-," . 'mc/mark-next-like-this)
("n" . 'mc/mark-next-like-this)
("p" . 'mc/mark-previous-like-this)
("m" . 'mc/mark-more-like-this-extended)
("u" . 'mc/unmark-next-like-this)
("U" . 'mc/unmark-previous-like-this)
("s" . 'mc/skip-to-next-like-this)
("S" . 'mc/skip-to-previous-like-this)
("*" . 'mc/mark-all-like-this)
("d" . 'mc/mark-all-like-this-dwim)
("i" . 'mc/insert-numbers)
("o" . 'mc/sort-regions)
("O" . 'mc/reverse-regions)))



 


;; (0require 'multiple-cursors)
;; (require 'smartrep)
;; (declare-function smartrep-define-key "smartrep")

;; (global-set-key (kbd "C-M-c") 'mc/edit-lines)
;; (global-set-key (kbd "C-*")   'mc/mark-all-like-this)
;; (global-unset-key "\C-i")
;; (smartrep-define-key  global-map  "\C-i"
;;   '(("C-p"      . 'mc/mark-previous-like-this)
;;      ("C-n"      . 'mc/mark-next-like-this)
;;     ("C-<up>"   . 'mc/mark-previous-like-this)
;;     ("C-<down>" . 'mc/mark-next-like-this)
;;     ("C-P"      . 'mc/mark-previous-word-like-this)
;;     ("C-N"      . 'mc/mark-next-word-like-this)
;;     ("M-p"      . 'mc/mark-previous-symbol-like-this)
;;     ("M-n"      . 'mc/mark-next-symbol-like-this)
;;     ("*"        . 'mc/mark-all-like-this)))


;; (require 'multiple-cursors)
;; (global-set-key (kbd "C-c RET") 'mc/edit-lines)
;; (global-set-key (kbd "C->") 'mc/mark-next-like-this)
;; (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;; (global-set-key (kbd "C-*") 'mc/mark-all-like-this)



