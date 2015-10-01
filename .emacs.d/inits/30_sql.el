
;;
(defvar sql-connection-alist nil)
(defvar sql-product nil)
(defvar my-sql-password nil)
(setq sql-connection-alist
      '((scope (sql-product 'mysql)
                  (sql-port 3306)
                  (sql-server "127.0.0.1")
                  (sql-user "root")
                  (sql-database "databaseName"))
        (server2 (sql-product 'postgres)
                  (sql-port 5432)
                  (sql-server "localhost")
                  (sql-user "user")
                  (sql-database "db2"))))




;; (defun mymy/sql-connect (connection)
;;   (interactive
;;    (helm-comp-read "Select server: " (mapcar (lambda (item)
;;                                                (list
;;                                                 (symbol-name (nth 0 item))
;;                                                 (nth 0 item)))
;;                                              sql-connection-alist)))
;;   ;; load the password
;;   (require 'my-password "~/.emacs.d/inits/my-password.el.gpg")
;;   ;; update the password to the sql-connection-alist
;;   (let* ((connection-info (assoc connection sql-connection-alist))
;;          (connection-product  (eval (cadr (assoc 'sql-product connection-info))))
;;          (sql-password (car (last (assoc connection my-sql-password)))))
;;      (print connection-product)
;;     (delete sql-password connection-info)
;;     (nconc connection-info `((sql-password ,sql-password)))
;;     (setq sql-connection-alist (assq-delete-all connection sql-connection-alist))
;;     (add-to-list 'sql-connection-alist connection-info)
;;     ;; connect to database
;;     (setq sql-product connection-product)
;;     (sql-connect connection)))
