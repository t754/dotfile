;;; color-moccur-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (search-buffers grep-buffers dired-do-moccur moccur-grep-find
;;;;;;  occur-by-moccur) "color-moccur" "../../../../.emacs.d/elpa/color-moccur-20140424.643/color-moccur.el"
;;;;;;  "8b954d09cd95283320f42391e4558a90")
;;; Generated autoloads from ../../../../.emacs.d/elpa/color-moccur-20140424.643/color-moccur.el

(autoload 'occur-by-moccur "color-moccur" "\
Use this instead of occur.
Argument REGEXP regexp.
Argument ARG whether buffers which is not related to files are searched.

\(fn REGEXP ARG)" t nil)

(autoload 'moccur-grep-find "color-moccur" "\


\(fn DIR INPUTS)" t nil)

(autoload 'dired-do-moccur "color-moccur" "\
Show all lines of all buffers containing a match for REGEXP.
The lines are shown in a buffer named *Moccur*.
It serves as a menu to find any of the occurrences in this buffer.
\\[describe-mode] in that buffer will explain how.

\(fn REGEXP ARG)" t nil)

(autoload 'grep-buffers "color-moccur" "\
*Run `grep` PROGRAM to match EXPRESSION (with optional OPTIONS) on all visited files.

\(fn)" t nil)

(autoload 'search-buffers "color-moccur" "\
*Search string of all buffers.

\(fn REGEXP ARG)" t nil)

;;;***

;;;### (autoloads nil nil ("../../../../.emacs.d/elpa/color-moccur-20140424.643/color-moccur-pkg.el"
;;;;;;  "../../../../.emacs.d/elpa/color-moccur-20140424.643/color-moccur.el")
;;;;;;  (21338 41723 395494 719000))

;;;***

(provide 'color-moccur-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; color-moccur-autoloads.el ends here
