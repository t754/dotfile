(require 'multiple-cursors)
(require 'smartrep)

(global-unset-key "\M-t")
;; (global-set-key (kbd "C-M-c") 'mc/edit-lines)


(declare-function smartrep-define-key "smartrep")

(smartrep-define-key global-map "M-t"
  '(("M-t"      . 'mc/mark-next-like-this)
    ("n"        . 'mc/mark-next-like-this)
    ("p"        . 'mc/mark-previous-like-this)
    ("m"        . 'mc/mark-more-like-this-extended)
    ("u"        . 'mc/unmark-next-like-this)
    ("U"        . 'mc/unmark-previous-like-this)
    ("s"        . 'mc/skip-to-next-like-this)
    ("S"        . 'mc/skip-to-previous-like-this)
    ("*"        . 'mc/mark-all-like-this)
    ("d"        . 'mc/mark-all-like-this-dwim)
    ("I"        . 'my/mc/insert-numbers)
    ("i"        . 'mc/insert-numbers)
    ("o"        . 'mc/sort-regions)
    ("O"        . 'mc/reverse-regions)))

;; 
(defvar my/mc/counter 0)
(defvar my/mc/format-list nil)

;; "\"tes %d %d\" i (% i 2)"
;; ↓
;; (format "tes %d %d" my/mc/counter (% my/mc/counter 2))
;; できた
;; (defun my/mc/format-revease-loop (sss lis)
;;   (let ((MMM (read-from-string sss)))
;;     (cond ((< (cdr MMM) (length sss))
;;            (my/mc/format-revease-loop  (substring sss (cdr MMM)) (cons (car MMM) lis)))
;;           (t (cons (car MMM) lis)))))

(defun my/mc/insert-numbers (arg)
  "Insert increasing numbers for each cursor, starting at 0 or ARG."
  (interactive "P")
  (setq my/mc/counter (or arg 0))
  (setq my/mc/format-list
        (car (read-from-string (read-from-minibuffer "例:i=[0,1,,]::(% i 2):" "i"))))
  (mc/for-each-cursor-ordered
   (mc/execute-command-for-fake-cursor 'my/mc--insert-number-and-increase cursor)))

(defun my/mc--insert-number-and-increase ()
  (interactive)
  (insert (format "%d" ((lambda (i) (eval my/mc/format-list)) my/mc/counter)))
  (incf my/mc/counter))


;; (require 'multiple-cursors)
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



