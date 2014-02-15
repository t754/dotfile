;;; grass.el --- The Grass Language Environment

;; Copyright (c) 2008  S. Irie

;; Author: S. Irie
;; Maintainer: S. Irie
;; Keywords: lambda calculus, esoteric programming

(defconst grass-version "0.1.8")

;; This program is free software.

;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions
;; are met:

;; 1. Redistributions of source code must retain the above copyright
;;    notice, this list of conditions and the following disclaimer.
;; 2. Redistributions in binary form must reproduce the above copyright
;;    notice, this list of conditions and the following disclaimer in the
;;    documentation and/or other materials provided with the distribution.

;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;; A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
;; OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
;; TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;; PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;; LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

;;; Commentary:

;; Grass is a functional grass-planting programming language. Syntax and
;; semantics of Grass are defined based on (A-normalized, lambda lifted,
;; and De Bruijn indexed) untyped lambda calculus and SECD machine
;; [Landin 1964] respectively so that Grass is Turing-complete.

;; Grass was first proposed by Katsuhiro Ueno at the 39th IPSJ Jouho-Kagaku
;; Wakate no Kai (symposium for young researcher of information science) in
;; 2006 to introduce how to define a programming language in formal way.

;; Grass is a kind of esoteric programming language typified by BrainF*ck,
;; but Grass has unique characteristics which any other esoteric ones don't
;; have. For example:

;; 1. Grass is based on lambda calculus, not Turing machine.
;; 2. Grass is slightly easier to read than functional programming languages
;;    designed based on combinatory logic.
;; 3. Grass has formal definition.
;; 4. Grass is easy to slip into ASCII art.

;; For details, see http://www.blue.sky.or.jp/grass/

;; History:
;; 2008-09-06  S. Irie
;;        * Add option `grass-allow-consecutive-v-separators'
;;        * Add option `grass-conversion-buffer-restorable'
;;        * Rewrite sample code `grass-sample-hello'
;;        * Bug fix
;;        * Version 0.1.8
;; 2008-09-01  S. Irie
;;        * Bug fixes (Correction of syntax rule implementation)
;;        * Version 0.1.7
;; 2008-08-03  S. Irie
;;        * Modify treatment of carriage return character In/Out
;;        * Bug fix
;;        * Version 0.1.6
;; 2008-08-02  S. Irie
;;        * Modify search algorithm in `grass-read-from-string'
;;        * Version 0.1.5
;; 2008-07-27  S. Irie
;;        * Modify treatment of keymap for emacs-lisp-mode
;;        * Version 0.1.4
;; 2008-07-25  S. Irie
;;        * Add key-binding for re-highlighting
;;        * Bug fix
;;        * Version 0.1.3
;; 2008-07-24  S. Irie
;;        * Bug fix
;;        * Version 0.1.2
;; 2008-07-24  S. Irie
;;        * Out-primitive supports sjis decoding
;;        * Bug fixes
;;        * Version 0.1.1
;; 2008-07-23  S. Irie
;;        * First release
;;        * Version 0.1.0
;; 2008-07-22  S. Irie
;;        * Version 0.0.7
;; 2008-07-06  S. Irie
;;        * Version 0.0.6
;; 2008-07-05  S. Irie
;;        * Version 0.0.5
;; 2008-07-04  S. Irie
;;        * Version 0.0.4
;; 2008-07-03  S. Irie
;;        * Version 0.0.3
;; 2008-07-01  S. Irie
;;        * Version 0.0.2
;; 2008-06-27  S. Irie
;;        * Version 0.0.1

;;; Code

(require 'japan-util)

;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
;; Settings
;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

(defgroup grass nil
  "Grass the grass-planting purogramming language"
  :prefix "grass-"
  :group 'languages)

(defface grass-highlight-argument '((t (:foreground "lime green" :bold t)))
  "Grass-mode syntax highlighting face for the characters `w'"
  :group 'grass)

(defface grass-highlight-function '((t (:foreground "dodger blue" :bold t)))
  "Grass-mode syntax highlighting face for the characters `W'"
  :group 'grass)

(defface grass-highlight-separator '((t (:foreground "deep pink" :bold t)))
  "Grass-mode syntax highlighting face for the characters `v'"
  :group 'grass)

(defcustom grass-eof-char 4
  "The character code that the `In' primitive treats as a sign of
end-of-file. If you don't need this, set the value to nil."
  :type 'integer
  :group 'grass)

(defcustom grass-out-decode-sjis t
  "Specify whether the `Out' primitive decodes the output characters
which have codes in Japanese shift-jis encoding."
  :type 'boolean
  :group 'grass)

(defcustom grass-out-update-cycle 10
  "Specify how to update the display of the evaluation result of
Grass program when the evaluator is run interactively.
 If the value is a positive number, it means the number of calls to the
Out-primitive. If a non-positive number, the updates are done only when
the Out-primitive is called with a linefeed character or the In-primitive
is called. If the value is not an integer, the display is not updated
until the evaluation is finished or terminated."
  :type '(choice (integer)
		 (const :tag "every linefeed" 0)
		 (const :tag "none" nil))
  :group 'grass)

(defcustom grass-allow-consecutive-v-separators nil
  "Specify whether the parser allows consecutive v separators, i. e.
a program segment which contains neither the function definition (abs)
or the function applications (app+)."
  :type 'boolean
  :group 'grass)

(defcustom grass-listify-comment-style nil
  "Specify the form of the annotation added to each end of line of
the function application when `grass-listify' command converts the Grass
program. The value nil means that any strings are not added to them."
  :type '(choice (const "\t\t;; ")
		 (string :value "\t\t;; ")
		 (const :tag "none" nil))
  :group 'grass)

(defcustom grass-evaluation-buffer-name "*Grass Evaluation*"
  "The name of buffer in which the evaluation result is displayed
when the command `grass-eval' or `grass-eval-list' is executed."
  :type 'string
  :group 'grass)

(defcustom grass-conversion-buffer-name "*Grass Conversion*"
  "The name of buffer in which the conversion result is displayed
when the command `grass-plant' or `grass-listify' is executed."
  :type 'string
  :group 'grass)

(defcustom grass-conversion-buffer-restorable nil
  "If the value is non-nil, the the past conversion results are
retained in `buffer-undo-list' when the conversion commands such as
`grass-plant' and `grass-listify' are performed one after another."
  :type 'boolean
  :group 'grass)

;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
;; Major mode and minor mode
;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

(unless (key-binding "\C-cgm")
  (global-set-key "\C-cgm" 'grass-minor-mode))

(defvar grass-mode-map nil)
(unless grass-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-cge" 'grass-eval)
    (define-key map "\C-cgl" 'grass-listify)
    (define-key map "\C-cgE" 'grass-eval-list)
    (define-key map "\C-cgp" 'grass-plant)
    (define-key map "\C-cgf" 'font-lock-fontify-buffer)
    (setq grass-mode-map map)))

(defconst grass-highlight-argument 'grass-highlight-argument)
(defconst grass-highlight-function 'grass-highlight-function)
(defconst grass-highlight-separator 'grass-highlight-separator)
(defconst grass-font-lock-keywords '(("[wｗ]+" 0 grass-highlight-argument t)
				     ("[WＷ]+" 0 grass-highlight-function t)
				     ("[vｖ]" 0 grass-highlight-separator t)))

(defun grass-font-lock-add-keywords (&optional mode)
  (interactive)
  (font-lock-add-keywords mode grass-font-lock-keywords)
  (font-lock-fontify-buffer))

(defun grass-font-lock-remove-keywords (&optional mode)
  (interactive)
  (font-lock-remove-keywords mode grass-font-lock-keywords)
  (font-lock-fontify-buffer))

;; Major Mode
(define-derived-mode grass-mode fundamental-mode "Grass"
  "Major mode for the grass-planting programming language."
  (set (make-local-variable 'truncate-partial-width-windows) nil)
  (set (make-local-variable 'font-lock-defaults) '(nil t))
  (grass-font-lock-add-keywords 'grass-mode))

;; Minor Mode
(defcustom grass-minor-mode nil
  "Toggle grass-minor-mode.
Setting this variable directly does not take effect;
use either \\[customize] or the function `grass-minor-mode'."
  :set 'custom-set-minor-mode
  :initialize 'custom-initialize-default
  :version "21.4"
  :type 'boolean
  :group 'grass
  :require 'grass)
(make-variable-buffer-local 'grass-minor-mode)

(defun grass-minor-mode-on ()
  (interactive)
  (unless (eq major-mode 'grass-mode)
    (grass-font-lock-add-keywords))
  (setq grass-minor-mode t)
  (force-mode-line-update))

(defun grass-minor-mode-off ()
  (interactive)
  (unless (eq major-mode 'grass-mode)
    (grass-font-lock-remove-keywords))
  (setq grass-minor-mode nil)
  (force-mode-line-update))

(defun grass-minor-mode (&optional arg)
  "Toggle grass-minor-mode."
  (interactive "P")
  (setq grass-minor-mode
	(if (null arg)
	    (not grass-minor-mode)
	  (> (prefix-numeric-value arg) 0)))
  (if grass-minor-mode
      (grass-minor-mode-on)
    (grass-minor-mode-off)))

(unless (assq 'grass-minor-mode minor-mode-alist)
  (setq minor-mode-alist
	(cons '(grass-minor-mode " Grass")
	      minor-mode-alist)))
(unless (assq 'grass-minor-mode minor-mode-map-alist)
  (setq minor-mode-map-alist
	(cons (cons 'grass-minor-mode grass-mode-map)
	      minor-mode-map-alist)))

;; Add Keybindings to emacs-lisp-mode
(defvar grass-keymap-active nil)
(make-variable-buffer-local 'grass-keymap-active)

(unless (assq 'grass-keymap-active minor-mode-map-alist)
  (setq minor-mode-map-alist
	(cons (cons 'grass-keymap-active grass-mode-map)
	      minor-mode-map-alist)))

(defun grass-activate-keymap ()
  (interactive)
  (setq grass-keymap-active t))

(add-hook 'emacs-lisp-mode-hook 'grass-activate-keymap)
(add-hook 'lisp-interaction-mode-hook 'grass-activate-keymap)

;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
;; Primitives
;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

(defsubst grass-primitive-p (p)
  (eq (car-safe p) 'prim))
(defsubst grass-primitive-type (p)
  (cadr p))
(defsubst grass-primitive-value (p)
  (nth 2 p))
(defsubst grass-primitive-func (p)
  (nth 3 p))

;; True of Church Boolean (λx.λy.x)
(defconst grass-church-true '(((abs 1 ((app 3 2)))) . ((nil . nil))) )
;; False of Church Boolean (λx.λy.y)
(defconst grass-church-false '(((abs 1 nil)) . nil) )

(defun grass-char-function (c ch)
  (unless (eq (grass-primitive-type c) 'char)
    (error "grass-char-function: error: not a character"))
  (if (eq (grass-primitive-value c) ch)
      grass-church-true
    grass-church-false))

(defun grass-make-char (ch)
  `(prim char ,ch (lambda (c) (grass-char-function c ,ch))))

(defun grass-succ-function (c)
  (unless (eq (grass-primitive-type c) 'char)
    (error "grass-succ-function: error: not a character"))
  (grass-make-char
   (mod (1+ (grass-primitive-value c)) 256)))

(defun grass-in-function (c)
;  (unless (eq (grass-primitive-type c) 'char)
;    (error "grass-in-function: error: not a character"))
  (let ((ch (read-char-exclusive)))
    (if (eq ch 13) (setq ch 10)) ;; Carriage Return -> Line Feed
    (if (eq ch grass-eof-char)
	c
      (grass-make-char ch))))

(defvar grass-out-counter 0)     ;; Used for Periodic Update of the Screen
(defvar grass-out-prev-char nil) ;; First Byte of a Multi-byte Character

(defun grass-out-function (c)
  (unless (eq (grass-primitive-type c) 'char)
    (error "grass-out-function: error: not a character"))
  (let ((ch (grass-primitive-value c)))
    ;; Decode Shift-JIS Encoding Character
    (if grass-out-prev-char
	(setq ch (condition-case nil
		     (decode-sjis-char (+ (* grass-out-prev-char 256) ch))
		   (error (string-to-char "※")))
	      grass-out-prev-char nil)
      (if (and (> ch 127) grass-out-decode-sjis)
	  (if (or (and (>= ch ?\x81) (<= ch ?\x9f))
		  (and (>= ch ?\xe0) (<= ch ?\xfc)))
	      (setq grass-out-prev-char ch)
	    (setq ch (condition-case nil
			 (decode-sjis-char ch)
		       (error (setq grass-out-prev-char ch)))))))
    ;; Output the Character
    (unless grass-out-prev-char
      (condition-case nil
	  (write-char ch)
	(error (princ "※")))
      ;; Update the Screen Intermittently
      (unless noninteractive
	(let ((outbuf (get-buffer grass-evaluation-buffer-name)))
	  (when outbuf
	    (with-current-buffer outbuf
	      (set-window-point (get-buffer-window outbuf) (point)))
	    (when (integerp grass-out-update-cycle)
	      (setq grass-out-counter (1+ grass-out-counter))
	      (when (or (and (> grass-out-update-cycle 0)
			     (= grass-out-counter grass-out-update-cycle))
			(eq ch 10))
		(sit-for 0)
		(setq grass-out-counter 0))))))))
  c) ;; Return Value

(defconst grass-out  '(prim proc nil grass-out-function))
(defconst grass-succ '(prim proc nil grass-succ-function))
(defconst grass-in   '(prim proc nil grass-in-function))
(defconst grass-w     (grass-make-char ?w))

;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
;; Evaluator
;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

;; Initial State
;; E0 = Out :: Succ :: w :: In :: ε
(defconst grass-initial-env (list grass-out grass-succ grass-w grass-in))
;; D0 = (App(1, 1)::ε, ε) :: (ε, ε) :: ε
(defconst grass-initial-dump '((((app 1 1)) . nil) (nil . nil)) )

(defun grass-eval-machine (code env dump)
  (cond
   ((eq (caar code) 'app)
    ;; (App(m, n) :: C, E, D) → (Cm, (Cn, En) :: Em, (C, E) :: D)
    ;;   where E = (C1, E1) :: (C2, E2) :: … :: (Ci, Ei) :: E' (i = m, n)
    (let ((m (cadr (car code)))
	  (n (nth 2 (car code)))
	  (c (cdr code)))
      (if (grass-primitive-p (nth (1- m) env))
	  ;; Em is a primitive
	  (list c
		(cons (funcall
		       (grass-primitive-func (nth (1- m) env)) (nth (1- n) env))
		      env)
		dump)
	;; Em is a list
	(list (car (nth (1- m) env))
	      (cons (nth (1- n) env) (cdr (nth (1- m) env)))
	      (cons (cons c env) dump)))))
   ((eq (caar code) 'abs)
    (let ((n (cadr (car code)))
	  (cc (nth 2 (car code)))
	  (c (cdr code)))
      (if (eq n 1)
	  ;; (Abs(n, C') :: C, E, D) → (C, (C', E) :: E, D) if n = 1
	  (list c
		(cons (cons cc env) env)
		dump)
	;; (Abs(n, C') :: C, E, D) → (C, (Abs(n - 1, C')::ε, E) :: E, D) if n > 1
	(list c
	      (cons (cons (list (list 'abs (1- n) cc)) env) env)
	      dump))))
   ((null code)
    ;; (ε, f :: E, (C', E') :: D) → (C', f :: E', D)
    (and dump
	 (list (caar dump)
	       (cons (car env) (cdar dump))
	       (cdr dump))))
   (t
    (error "grass-eval: runtime error"))))

(defun grass-eval-code-internal (code)
  (let ((standard-output standard-output))
    ;; Open the Evaluation Window
    (unless noninteractive
      (let ((outbuf (get-buffer grass-evaluation-buffer-name)))
	(if outbuf
	    (with-current-buffer outbuf
	      (setq buffer-read-only nil)
	      (erase-buffer))
	  (setq outbuf (get-buffer-create grass-evaluation-buffer-name)))
	(with-current-buffer outbuf
	  (buffer-disable-undo)
	  (make-local-variable 'truncate-partial-width-windows)
	  (setq truncate-partial-width-windows nil))
	(setq standard-output outbuf)
	(display-buffer outbuf))
      (message "Evaluate Grass code..."))
    ;; Set the Initial State
    (let ((env grass-initial-env)
	  (dump grass-initial-dump)
	  state)
      (setq grass-out-counter 0
	    grass-out-prev-char nil)
      ;; Main Loop
      ;; (C0, E0, D0) →* (ε, f :: ε, ε)
      (while (or code dump)
	(setq state (grass-eval-machine code env dump)
	      code (car state)
	      env (cadr state)
	      dump (nth 2 state))
;	(print code) ;; Debug Code
;	(print env)  ;; Debug Code
	))
    (unless noninteractive
      (message "Done!"))
    nil)) ;; Return value

;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
;; Evaluate the Standard Source Code
;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

;; Parser

(defun grass-parse-normalize (string)
  (concat
   (delq nil (memq ?w (mapcar (lambda (p)
				(car (memq p '(?w ?W ?v))))
			      (append (japanese-hankaku string t) nil))))))

(defun grass-parse-apps (string &optional start)
  (let ((str-len (length string))
	(case-fold-search nil)
	(seq (list nil))
	(pos (or start 0)))
    (while (< pos str-len)
      (unless (eq (string-match "\\(W+\\)\\(w+\\)\\(.*\\)" string pos) pos)
	(error "grass-parse-apps: syntax error: App lacks of an argument"))
      (nconc seq (list (list 'app (- (match-end 1) (match-beginning 1))
			     (- (match-end 2) (match-beginning 2)))))
      (setq pos (match-beginning 3)))
    (cdr seq)))

(defun grass-parse (string)
  (let ((list (split-string (grass-parse-normalize string) "v"))
	(case-fold-search nil)
	(seq (list nil)))
    (while list
      (let ((string (car list)))
	(nconc seq (if (string-match "^\\(w+\\)\\(.*\\)" string)
		       (list (list 'abs (match-end 1)
				   (grass-parse-apps string (match-beginning 2))))
		     (if (and (string= string "") (cdr list))
			 (unless grass-allow-consecutive-v-separators
			   (error "grass-parse: syntax error: consecutive v separators")))
		     (grass-parse-apps string))))
      (setq list (cdr list)))
    (cdr seq)))

;; Recursive Version
;(defun grass-parse-apps (string)
;  (unless (string= string "")
;    (let ((case-fold-search nil))
;      (if (string-match "^\\(W+\\)\\(w+\\)\\(.*\\)" string)
;	  (cons (list 'app (length (match-string 1 string))
;		      (length (match-string 2 string)))
;		(grass-parse-apps (match-string 3 string)))
;	(error "grass-parse-apps: syntax error: App lacks of an argument")))))
;
;(defun grass-parse-prog (list)
;  (if list
;      (let ((string (car list))
;	    (case-fold-search nil))
;	(append (if (string-match "^\\(w+\\)\\(.*\\)" string)
;		    (list (list 'abs (length (match-string 1 string))
;				(grass-parse-apps (match-string 2 string))))
;		  (grass-parse-apps string))
;		(grass-parse-prog (cdr list))))))
;
;(defun grass-parse (string)
;  (grass-parse-prog (split-string (grass-parse-normalize string) "v")))

;; Commands and Functions wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

(defun grass-eval-string (string)
  (interactive "sEnter a Grass code: ")
  (grass-eval-code-internal (grass-parse string)))

(defun grass-eval-buffer (buffer)
  (interactive "b")
  (let ((string (with-current-buffer buffer (buffer-string))))
    (grass-eval-string string)))

(defun grass-eval-region (beg end)
  (interactive "r")
  (grass-eval-string (buffer-substring-no-properties beg end)))

(defun grass-eval (&optional buffer)
  (interactive)
  (if mark-active
      (call-interactively 'grass-eval-region)
    (grass-eval-buffer (or buffer (current-buffer)))))

(defun grass-eval-string-to-string (string)
  "Return an evaluation result for STRING."
  (let ((noninteractive t))
    (with-output-to-string (grass-eval-string string))))

(defun grass-eval-buffer-to-string (buffer)
  (let ((noninteractive t))
    (with-output-to-string (grass-eval-buffer buffer))))

(defun grass-eval-region-to-string (beg end)
  (let ((noninteractive t))
    (with-output-to-string (grass-eval-region beg end))))

;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
;; Evaluate the Lispy Source Code
;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

;; Preprocessor

(defconst grass-calc-index-initial-stack '(out succ w in))

(defun grass-calculate-index (code)
  (let ((stack grass-calc-index-initial-stack)
	(raw-code (list nil))
	(noname 0))
    (while code
      (let* ((elt (car code))
	     (tag (car-safe elt)))
	(cond ((eq tag 'abs)
	       (let ((name (cadr elt))
		     (args (cadr elt))
		     (body (car (cddr elt)))
		     (stack-local stack)
		     (new-abs (list 'abs))
		     (new-body (list nil)))
		 (if (symbolp name)
		     (setq args body
			   body (nth 3 elt))
		   (setq noname (1+ noname)
			 name (format "noname %s" noname)))
		 (cond ((integerp args)
			(unless (> args 0)
			  (error "grass-calculate-index: error in `%s': at least one argument is needed" name))
			(nconc new-abs (list args))
			(setq args (cons 0 (make-list (1- args) 1)))) ;; Dummy for Noname Arguments
		       ((consp args)
			(dolist (arg args)
			  (unless (symbolp arg)
			    (error "grass-calculate-index: error in `%s': argument list contains a wrong element" name)))
			(nconc new-abs (list (length args))))
		       (t
			(error "grass-calculate-index: error in `%s': arguments not specified" name)))
		 (setq stack-local (nconc (reverse args) stack-local))
		 (unless (listp body)
		   (error "grass-calculate-index: error in `%s': function body must be a sequence of Apps as a list" name))
		 (while body
		   (let* ((elt (car body))
			  (fun (car-safe (cdr-safe elt)))
			  (arg (car-safe (cdr-safe (cdr-safe elt))))
			  (lab (cdr-safe (cdr-safe (cdr-safe elt)))))
		     (unless (eq (car-safe elt) 'app)
		       (error "grass-calculate-index: error in `%s': function application must be a list starting with `app'" name))
		     (unless fun
		       (error "grass-calculate-index: error in `%s': App lacks of a function index" name))
		     (unless (or (symbolp fun) (integerp fun))
		       (error "grass-calculate-index: error in `%s': function index must be specified by an integer or a symbol" name))
		     (unless arg
		       (error "grass-calculate-index: error in `%s': App lacks of a augument index" name))
		     (unless (or (symbolp arg) (integerp arg))
		       (error "grass-calculate-index: error in `%s': argument index must be specified by an integer or a symbol" name))
		     (unless (symbolp lab)
		       (error "grass-calculate-index: error in `%s': label of function application must be a symbol" name))
		     (when (symbolp fun)
		       (let ((find (memq (if (eq fun name) (car args) fun) stack-local)))
			 (unless find
			   (error "grass-calculate-index: error in `%s': symbol `%s' not defined" name fun))
			 (setq fun (1+ (- (length stack-local) (length find))))))
		     (when (symbolp arg)
		       (let ((find (memq (if (eq arg name) (car args) arg) stack-local)))
			 (unless find
			   (error "grass-calculate-index: error in `%s': symbol `%s' not defined" name arg))
			 (setq arg (1+ (- (length stack-local) (length find))))))
		     (nconc new-body (list (list 'app fun arg)))
		     (setq stack-local (cons (or lab 1) stack-local) ;; Push Label of App (1 is Dummy for Noname App)
			   body (cdr body))))
		 (nconc new-abs (list (cdr new-body)))
		 (nconc raw-code (list new-abs))
		 (setq stack (cons name stack))))
	      ((eq tag 'app)
		   (let* ((fun (car-safe (cdr-safe elt)))
			  (arg (car-safe (cdr-safe (cdr-safe elt))))
			  (lab (cdr-safe (cdr-safe (cdr-safe elt)))))
		     (unless fun
		       (error "grass-calculate-index: error: App lacks of a function index"))
		     (unless (or (symbolp fun) (integerp fun))
		       (error "grass-calculate-index: error: function index must be specified by an integer or a symbol"))
		     (unless arg
		       (error "grass-calculate-index: error: App lacks of a augument index"))
		     (unless (or (symbolp arg) (integerp arg))
		       (error "grass-calculate-index: error: argument index must be specified by an integer or a symbol"))
		     (unless (symbolp lab)
		       (error "grass-calculate-index: error: label of function application must be a symbol"))
		     (when (symbolp fun)
		       (let ((find (memq fun stack)))
			 (unless find
			   (error "grass-calculate-index: error: symbol `%s' not defined" fun))
			 (setq fun (1+ (- (length stack) (length find))))))
		     (when (symbolp arg)
		       (let ((find (memq arg stack)))
			 (unless find
			   (error "grass-calculate-index: error: symbol `%s' not defined" arg))
			 (setq arg (1+ (- (length stack) (length find))))))
		     (nconc raw-code (list (list 'app fun arg)))
		     (setq stack (cons (or lab 1) stack)))) ;; Push Label of App (1 is Dummy for Noname App)
	      (t
	       (error "grass-calculate-index: error: each program element must be a list starting with a symbol `abs' or `app'")))
	(setq code (cdr code))))
    (cdr raw-code)))

(defun grass-read-from-string (string &optional start end)
  (let ((case-fold-search nil))
    (string-match "^[\t ]*\\([^\n\t ;][^\n]*\\|\\)\\(([\n\t ]*abs[\n\t ]\\)"
		  string start))
  (let* ((pos (match-beginning 2))
	 (code (list nil))
	 read)
    (if (or (null pos) (and end (>= pos end)))
	(error "grass-read-from-string: error: Grass code not found")
      (while (memq (condition-case nil
		       (caar (setq read (read-from-string string pos end)))
		     (wrong-type-augment nil)
		     (invalid-read-syntax nil)
		     (end-of-file nil))
		   '(abs app))
	(nconc code (list (car read)))
	(setq pos (cdr read)))
      (cdr code))))

;; Commands and Functions wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

(defun grass-eval-code (code)
  (interactive "xEnter a lispy Grass code: ")
  (grass-eval-code-internal (grass-calculate-index code)))

(defun grass-eval-code-to-string (code)
  (let ((noninteractive t))
    (with-output-to-string (grass-eval-code code))))

(defun grass-eval-list-string (string &optional beg end)
  (interactive "sEnter a lispy Grass code: ")
  (grass-eval-code (grass-read-from-string string beg end)))

(defun grass-eval-list-in-buffer (buffer)
  (interactive "b")
  (let ((string (with-current-buffer buffer (buffer-string))))
    (grass-eval-list-string string)))

(defun grass-eval-list-in-region (beg end)
  (interactive "r")
  (grass-eval-list-string (buffer-substring-no-properties beg end)))

(defun grass-eval-list (&optional buffer)
  (interactive)
  (if mark-active
      (call-interactively 'grass-eval-list-in-region)
    (grass-eval-list-in-buffer (or buffer (current-buffer)))))

(defun grass-eval-list-string-to-string (string &optional beg end)
  (let ((noninteractive t))
    (with-output-to-string (grass-eval-list-string string beg end))))

(defun grass-eval-list-in-buffer-to-string (buffer)
  (let ((noninteractive t))
    (with-output-to-string (grass-eval-list-in-buffer buffer))))

(defun grass-eval-list-in-region-to-string (beg end)
  (let ((noninteractive t))
    (with-output-to-string (grass-eval-list-in-region beg end))))

;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
;; Source Code Converter between Standard Form and Lispy Form
;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

(defun grass-conversion-open-window ()
  (let ((outbuf (get-buffer grass-conversion-buffer-name)))
    (if outbuf
	(with-current-buffer outbuf
	  (setq buffer-read-only nil)
	  (erase-buffer)
	  (unless grass-conversion-buffer-restorable
	    (buffer-disable-undo)))
      (setq outbuf (get-buffer-create grass-conversion-buffer-name)))
    (pop-to-buffer outbuf)
    (buffer-enable-undo)
    (setq standard-output outbuf)))

;; Generate the Standard Grass Code wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

(defun grass-plant-code (code)
  (interactive "xEnter a lispy Grass code: ")
  (let ((standard-output standard-output)
	(code (grass-calculate-index code))
	(prev-tag nil))
    (unless noninteractive
      (grass-conversion-open-window))
    (while code
      (let* ((elt (car code))
	     (tag (car elt)))
	(cond ((eq tag 'abs)
	       (if prev-tag (write-char ?v))
	       (let ((body (car (cddr elt))))
		 (princ (make-string (cadr elt) ?w))
		 (while body
		   (let ((elt (car body)))
		     (princ (make-string (cadr elt) ?W))
		     (princ (make-string (car (cddr elt)) ?w)))
		   (setq body (cdr body)))))
	      ((eq tag 'app)
	       (if (eq prev-tag 'abs) (write-char ?v))
	       (princ (make-string (cadr elt) ?W))
	       (princ (make-string (car (cddr elt)) ?w))))
	(setq code (cdr code)
	      prev-tag tag))))
  (unless noninteractive
    (grass-mode)))

(defun grass-plant-code-to-string (code)
  ;; Inverse function of `grass-parse'.
  (let ((noninteractive t))
    (with-output-to-string (grass-plant-code code))))

(defun grass-plant-string (string &optional beg end)
  (interactive "sEnter a lispy Grass code: ")
  (grass-plant-code (grass-read-from-string string beg end)))

(defun grass-plant-buffer (buffer)
  (interactive "b")
  (let ((string (with-current-buffer buffer (buffer-string))))
    (grass-plant-string string)))

(defun grass-plant-region (beg end)
  (interactive "r")
  (grass-plant-string (buffer-substring-no-properties beg end)))

(defun grass-plant (&optional buffer)
  (interactive)
  (if mark-active
      (call-interactively 'grass-plant-region)
    (grass-plant-buffer (or buffer (current-buffer)))))

(defun grass-plant-string-to-string (string &optional beg end)
  (let ((noninteractive t))
    (with-output-to-string (grass-plant-string string beg end))))

(defun grass-plant-buffer-to-string (buffer)
  (let ((noninteractive t))
    (with-output-to-string (grass-plant-buffer buffer))))

(defun grass-plant-region-to-string (beg end)
  (let ((noninteractive t))
    (with-output-to-string (grass-plant-region beg end))))

;; Generate the Lispy Grass Code wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

(defun grass-listify-string (string)
  (interactive "sEnter a Grass code: ")
  (let ((code (grass-parse string))
	(standard-output standard-output))
    (unless noninteractive
      (grass-conversion-open-window))
    (princ "'(\n  ")
    (while code
      (let* ((elt (car code))
	     (tag (car elt)))
	(cond
	 ((eq tag 'abs)
	  (let ((body (car (cddr elt))))
	    (princ (format "(abs %d\n       (" (cadr elt)))
	    (while body
	      (let ((elt (car body)))
		(princ (format "(app %d %d)%s\n        "
			       (cadr elt) (car (cddr elt))
			       (or grass-listify-comment-style ""))))
	      (setq body (cdr body)))
	    (princ "))\n  ")))
	 ((eq tag 'app)
	  (princ (format "(app %d %d)%s\n  "
			 (cadr elt) (car (cddr elt))
			 (or grass-listify-comment-style ""))))))
      (setq code (cdr code)))
    (princ ")\n"))
  (unless noninteractive
    (goto-char (point-min))
    (emacs-lisp-mode)))

(defun grass-listify-buffer (buffer)
  (interactive "b")
  (let ((string (with-current-buffer buffer (buffer-string))))
    (grass-listify-string string)))

(defun grass-listify-region (beg end)
  (interactive "r")
  (grass-listify-string (buffer-substring-no-properties beg end)))

(defun grass-listify (&optional buffer)
  (interactive)
  (if mark-active
      (call-interactively 'grass-listify-region)
    (grass-listify-buffer (or buffer (current-buffer)))))

(defun grass-listify-string-to-string (string)
  (let ((noninteractive t))
    (with-output-to-string (grass-listify-string string))))

(defun grass-listify-buffer-to-string (buffer)
  (let ((noninteractive t))
    (with-output-to-string (grass-listify-buffer buffer))))

(defun grass-listify-region-to-string (beg end)
  (let ((noninteractive t))
    (with-output-to-string (grass-listify-region beg end))))

;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
;; Sample Codes
;;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
(unless noninteractive

(defvar grass-sample-w
  (japanese-zenkaku
   (grass-plant-code-to-string
    '(
      (abs main (n)
	   ((app out w)		;; out w
	    ))
      ))))

(defvar grass-sample-w16
  (grass-plant-code-to-string
   '(
     (abs <2> (f x)
	  ((app f x)		;; f x
	   (app f 1)		;; f (f x) => 2
	   ))
     (abs main (n)
	  ((app <2> <2>)	;; 2 2 => 2^2 = 4
	   (app 1 <2>)		;; 4 2 => 2^4 = 16
	   (app 1 out)		;; 16 out
	   (app 1 w)		;; 16 out w
	   ))
     )))

(defvar grass-sample-ascii
  (grass-plant-code-to-string
   '(
     (abs out&inc (n)
	  ((app out n)		;; out n
	   (app succ 1)		;; succ (out n) => succ n ; Next Character
	   ))
     (abs <2> (f x)
	  ((app f x)		;; f x
	   (app f 1)		;; f (f x) => 2
	   ))
     (abs inc (n f x)
	  ((app n f)		;; n f
	   (app 1 x)		;; n f x
	   (app f 1)		;; f (n f x) => inc n
	   ))
     (abs main (n)
	  ((app inc <2>)	;; inc 2  => 3
	   (app inc 1)		;; inc 3  => 4
	   (app <2> 2)		;; 2 3    => 3^2 = 9
	   (app 1 inc)		;; 9 inc
	   (app 1 3)		;; 9 inc 4 => 13
	   (app <2> 1)		;; 2 13    => 13^2 = 169 ; SPC
	   (app 4 3)		;; 9 (9 inc) => 81 inc
	   (app 1 3)		;; 81 inc 13 => 94
	   (app inc 1)		;; inc 94    => 95 ; Number of Characters
	   (app 4 succ)		;; 169 succ
	   (app 1 w)		;; 169 succ w => SPC
	   (app 3 out&inc)	;; 95 out&inc
	   (app 1 2)		;; 95 out&inc SPC
	   ))
     )))

(defvar grass-sample-inputw
  (grass-plant-code-to-string
   '(
     (abs main (n)
	  ((app succ w)		;; succ w => x
	   (app in 1)		;; (in x)
	   (app 1 w)		;; (in x) w           => ((in ) == w)?
	   (app 1 w)		;; ((in x) == w)? w
	   (app 1 4)		;; ((in x) == w)? w x => ((in x) == w) ? w : x
	   (app out 1)		;; out (((in x) == w)? w : x)
	   ))
     )))

(defvar grass-sample-echo
  (grass-plant-code-to-string
   '(
     (abs <2> (f x)
	  ((app f x)		;; f x
	   (app f 1)		;; f (f x) => 2
	   ))
     (abs main (n)
	  ((app <2> <2>)	;; 2 2 => 2^2 = 4
	   (app 1 succ)		;; 4 succ
	   (app 1 w)		;; 4 succ w
	   (app 2 1)		;; 4 succ (4 succ w) => 8 succ w => DEL
	   (app in 1)		;; in DEL
	   (app 1 2)		;; (in DEL) DEL      => EOF?
	   (app 1 1)		;; EOF? EOF?         => EOF? true
	   (app 1 out)		;; EOF? true out
	   (app 1 4)		;; (EOF? true : out) (in DEL)
	   (app 3 main)		;; EOF? true main
	   (app 1 n)		;; (EOF? true : main) n
	   ))
     )))

(defvar grass-sample-hello
  ;; Rewritten for version 0.1.8
  ;;   551 chars => 472 chars
  (grass-plant-code-to-string
   '(
     (abs print (n)
	  ((app n succ . n_succ)
	   (app n_succ w . ch)
	   (app out ch)
	   ))
     (abs id (n)
	  ())
     (abs mkidprint (f n)
	  ((app print n)
	   (app id f)
	   ))
     (abs W (x y)
	  ((app x x . xx)
	   (app xx y)     ;; W = λxy.xxy
	   ))
     (abs X (f x)
	  ((app W x . Wx) ;; (λxy.xxy)x -> λy.xxy
	   (app f Wx)     ;; X = λfx.f(λy.xxy)
	   ))
     (abs Y (f) ;; Y combinator
	  ((app X f . Xf) ;; (λfx.f(λy.xxy))f -> λx.f(λy.xxy)
	   (app Xf Xf)    ;; Y = λf.(λx.f(λy.xxy))(λx.f(λy.xxy))
	   ))
     (abs idprint (n)
	  ((app Y mkidprint . Y_mkidprint)
	   (app Y_mkidprint n)
	   ))
     (abs <2> (f x)
	  ((app f x . fx)
	   (app f fx) ;; f (f x)
	   ))
     (app <2> <2> . <4>) ;; 2^2 = 4
     (abs inc (n f x)
	  ((app n f . nf)
	   (app nf x . nfx)
	   (app f nfx) ;; f (n f x)
	   ))
     (app inc <2> . <3>)
     (app <2> <3> . <9>) ;; 3^2 = 9
     (app <4> inc . <4>inc)
     (app <4>inc <9> . <13>)
     (app inc <13> . <14>)
     (app inc <14> . <15>)
     (abs <2> (f x)
	  ((app f x . fx)
	   (app f fx) ;; f (f x)
	   ))
     (app <2> <15> . <225>) ;; 15^2 = 225
     (app <2> <14> . <196>) ;; 14^2 = 196
     (app <2> <13> . <169>) ;; 13^2 = 169 ; SPC
     (app <3> <4>inc . <12>inc)
     (app <12>inc <169> . <181>) ;; ,
     (app <12>inc <196> . <208>)
     (app <12>inc <225> . <237>) ;; d
     (abs inc (n f x)
	  ((app n f . nf)
	   (app nf x . nfx)
	   (app f nfx) ;; f (n f x)
	   ))
     (app inc <169> . <170>) ;; !
     (app inc <208> . <209>) ;; H
     (app inc <237> . <238>) ;; e
     (app inc <238> . <239>)
     (app <3> inc . <3>inc)
     (app <3>inc <239> . <242>)
     (app <3>inc <242> . <245>) ;; l
     (app <3>inc <245> . <248>) ;; o
     (app <3>inc <248> . <251>) ;; r
     (abs print_Hello (dummy)
	  ((app idprint <209>) ;; H
	   (app 1 <238>) ;; e
	   (app 1 <245>) ;; l
	   (app 1 <245>) ;; l
	   (app 1 <248>) ;; o
	   (app 1 <181>) ;; ,
	   (app 1 <169>) ;; SPC
	   ))
     (abs <0> (f x) ;; w
	  ())
     (app print_Hello 1) ;; (1 is dummy argument)
     (app 1 <0>)   ;; w
     (app 1 <248>) ;; o
     (app 1 <251>) ;; r
     (app 1 <245>) ;; l
     (app 1 <237>) ;; d
     (app 1 <170>) ;; !
     (abs main (n)
	  ()) ;; (Null function to avoid error)
     )))

(defvar grass-sample-factorial
  ;;     ID := λ x. x
  ;;   TRUE := λ x y. x = λ x y. ID x
  ;;  FALSE := λ x y. y
  ;; ISZERO := λ n. n (TRUE FALSE) TRUE
  ;;   PRED := λ n f x. n (λ g h. h (g f)) (TRUE x) ID
  ;;   [ PRED n => λ f x. ID (f (f (f (f (...(f (TRUE x f))...))))) ]
  ;;                           <----- n-1 ----->
  ;;   MULT := λ m n f. m (n f)
  ;;      1 := λ f x. f x
  ;;      6 := λ f x. f (f (f (f (f (f x)))))
  ;;
  ;; Y-Combinator (can be used in call-by-value evaluation):
  ;;      Y := λ f. (λ x. f (λ y. x x y)) (λ x. f (λ y. x x y))
  ;; Recursive Factorial Function:
  ;;      g := λ f n. MULT n (((ISZERO (PRED n)) (TRUE 1) f) (PRED n))
  ;;   FACT := Y g
  ;;
  ;; For example, FACT 6 = Y g 6  yields  6! = 720.
  ;;
  (grass-plant-code-to-string
   '(
     (abs W (x y)
	  ((app x x)		;; x x
	   (app 1 y)		;; x x y
	   ))
     (abs X (f x)
	  ((app W x)		;; W x
	   (app f 1)		;; f (W x)
	   ))
     (abs Y (f)
	  ((app X f)		;; X f
	   (app 1 1)		;; X f (X f)
	   ))
     (abs id (n)
	  ())
     (abs true (x y)
	  ((app id x)		;; id x => x
	   ))
     (abs false (x y)
	  ())
     (abs iszero (n)
	  ((app true false)	;; true false
	   (app n 1)		;; n (true false)
	   (app 1 true)		;; n (true false) true
	   ))
     (abs dec_app1 (f g h)
	  ((app g f)		;; g f
	   (app h 1)		;; h (g f)
	   ))
     (abs dec (n f x)
	  ((app dec_app1 f)	;; dec_app1 f
	   (app true x)		;; true x
	   (app n 2)		;; n (dec_app1 f)
	   (app 1 2)		;; n (dec_app1 f) (true x)
	   (app 1 id)		;; n (dec_app1 f) (true x) id
	   ))
     (abs mult (m n f)
	  ((app n f)		;; n f
	   (app m 1)		;; m (n f) => m * n
	   ))
     (abs <1> (f x)
	  ((app f x)		;; f x => 1
	   ))
     (abs mkfact (f n)
	  ((app dec n)		;; dec n
	   (app iszero 1)	;; iszero (dec n)
	   (app 1 <1>)		;; (iszero (dec n)) 1  =>  true 1, if n <= 1
	   (app 2 1)		;; (iszero (dec n)) (true 1)
	   (app 1 f)		;; (iszero (dec n)) (true 1) f
	   (app 1 5)		;; ((iszero (dec n)) (true 1) f) (dec n)
	   (app mult n)		;; mult n
	   (app 1 2)		;; mult n (((iszero (dec n)) (true 1) f) (dec n))
	   ))
     (abs <6> (f x)
	  ((app f x)		;; f x
	   (app f 1)		;; f (f x)
	   (app f 1)		;; f (f (f x))
	   (app f 1)		;; f (f (f (f x)))
	   (app f 1)		;; f (f (f (f (f x))))
	   (app f 1)		;; f (f (f (f (f (f x))))) => 6
	   ))
     (abs main (n)
	  ((app Y mkfact)	;; Y mkfact
	   (app 1 <6>)		;; (Y mkfact) 6
	   (app 1 out)		;; ((Y mkfact) 6) out
	   (app 1 w)		;; ((Y mkfact) 6) out w
	   ))
     )))

(defvar grass-sample-fibonacci
  ;;     ID := λ x. x
  ;;   TRUE := λ x y. x = λ x y. ID x
  ;;  FALSE := λ x y. y
  ;; ISZERO := λ n. n (TRUE FALSE) TRUE
  ;;   PRED := λ n f x. n (λ g h. h (g f)) (TRUE x) ID
  ;;   SUCC := λ n f x. f (n f x)
  ;;      0 := λ f x. x
  ;;      1 := λ f x. f x
  ;;      2 := λ f x. f (f x)
  ;;
  ;; Y-Combinator (can be used in call-by-value evaluation):
  ;;      Y := λ f. (λ x. f (λ y. x x y)) (λ x. f (λ y. x x y))
  ;; Recursive Fibonacci Function:
  ;;      g := λ f n. (((ISZERO (2 PRED n)) (TRUE 1) f) (PRED n))
  ;;                  SUCC (((ISZERO (2 PRED n)) (TRUE 0) f) (2 PRED n))
  ;;   FIBO := Y g
  ;;
  (grass-plant-code-to-string
   '(
     (abs W (x y)
	  ((app x x)		;; x x
	   (app 1 y)		;; x x y
	   ))
     (abs X (f x)
	  ((app W x)		;; W x
	   (app f 1)		;; f (W x)
	   ))
     (abs Y (f)
	  ((app X f)		;; X f
	   (app 1 1)		;; X f (X f)
	   ))
     (abs id (n)
	  ())
     (abs true (x y)
	  ((app id x)		;; id x => x
	   ))
     (abs false (x y)
	  ())
     (abs iszero (n)
	  ((app true false)	;; true false
	   (app n 1)		;; n (true false)
	   (app 1 true)		;; n (true false) true
	   ))
     (abs dec_app1 (f g h)
	  ((app g f)		;; g f
	   (app h 1)		;; h (g f)
	   ))
     (abs dec (n f x)
	  ((app dec_app1 f)	;; dec_app1 f
	   (app true x)		;; true x
	   (app n 2)		;; n (dec_app1 f)
	   (app 1 2)		;; n (dec_app1 f) (true x)
	   (app 1 id)		;; n (dec_app1 f) (true x) id
	   ))
     (abs inc (n f x)
	  ((app n f)		;; n f
	   (app 1 x)		;; n f x
	   (app f 1)		;; f (n f x) => inc n
	   ))
     (abs <1> (f x)
	  ((app f x)		;; f x => 1
	   ))
     (abs mkfibo (f n)
	  ((app dec n)		;; dec n
	   (app dec 1)		;; dec (dec n) => 2 dec n
	   (app iszero 1)	;; iszero (2 dec n)
	   (app 1 <1>)		;; (iszero (2 dec n)) 1  =>  true 1, if n <= 2
	   (app 2 false)	;; (iszero (2 dec n)) 0  =>  true 0, if n <= 2
	   (app 3 2)		;; (iszero (2 dec n)) (true 1)
	   (app 4 2)		;; (iszero (2 dec n)) (true 0)
	   (app 2 f)		;; (iszero (2 dec n)) (true 1) f
	   (app 2 f)		;; (iszero (2 dec n)) (true 0) f
	   (app 2 9)		;; ((iszero (2 dec n)) (true 1) f) (dec n)
	   (app 2 9)		;; ((iszero (2 dec n)) (true 0) f) (2 dec n)
	   (app 2 inc)		;; (((iszero (2 dec n)) (true 1) f) (dec n)) inc
	   (app 1 2)		;; (((iszero (2 dec n)) (true 1) f) (dec n)) inc (((iszero (2 dec n)) (true 0) f) (2 dec n))
	   ))
     (abs main (n)
	  ((app inc <1>)	;; inc 1 => 2
	   (app 1 1)		;; 2 2   => 2^2 = 4
	   (app 1 inc)		;; 4 inc
	   (app 1 2)		;; 4 inc 4 => 8
	   (app 2 1)		;; 4 inc 8 => 12
	   (app Y mkfibo)	;; Y mkfibo
	   (app 1 2)		;; (Y mkfact) 12
	   (app 1 out)		;; ((Y mkfibo) 12) out
	   (app 1 w)		;; ((Y mkfibo) 12) out w
	   ))
     )))

(defvar grass-sample-fibonacci-iterative
  (grass-plant-code-to-string
   '(
     (abs W (x y)
	  ((app x x)		;; x x
	   (app 1 y)		;; x x y
	   ))
     (abs X (f x)
	  ((app W x)		;; W x
	   (app f 1)		;; f (W x)
	   ))
     (abs Y (f)
	  ((app X f)		;; X f
	   (app 1 1)		;; X f (X f)
	   ))
     (abs id (n)
	  ())
     (abs true (x y)
	  ((app id x)		;; id x => x
	   ))
     (abs false (x y)
	  ())
     (abs iszero (n)
	  ((app true false)	;; true false
	   (app n 1)		;; n (true false)
	   (app 1 true)		;; n (true false) true
	   ))
     (abs dec_app1 (f g h)
	  ((app g f)		;; g f
	   (app h 1)		;; h (g f)
	   ))
     (abs dec (n f x)
	  ((app dec_app1 f)	;; dec_app1 f
	   (app true x)		;; true x
	   (app n 2)		;; n (dec_app1 f)
	   (app 1 2)		;; n (dec_app1 f) (true x)
	   (app 1 id)		;; n (dec_app1 f) (true x) id
	   ))
     (abs inc (n f x)
	  ((app n f)		;; n f
	   (app 1 x)		;; n f x
	   (app f 1)		;; f (n f x) => inc n
	   ))
     (abs <1> (f x)
	  ((app f x)		;; f x => 1
	   ))
     (abs outw (n)
	  ((app inc <1>)	;; inc 1   => 2
	   (app 1 1)		;; 2 2     => 2^2 = 4
	   (app inc 2)		;; inc 2   => 3
	   (app 1 inc)		;; 3 inc
	   (app 1 3)		;; 3 inc 4 => 7
	   (app 5 1)		;; 2 7     => 7^2 = 49
	   (app 1 succ)		;; 49 succ
	   (app 5 1)		;; 3 (49 succ) => 147 succ
	   (app 1 w)		;; 147 succ w  => RET
	   (app n out)		;; n out
	   (app 1 w)		;; n out w
	   (app out 3)		;; out RET
	   ))
     (abs mkloop (f l m n)
	  ((app outw m)		;; outw m
	   (app l inc)		;; l inc
	   (app 1 m)		;; l inc m => l+m
	   (app dec n)		;; dec n
	   (app iszero 1)	;; iszero (dec n)  => (n <= 1)?
	   (app 1 1)		;; (iszero (dec n)) true
	   (app 1 f)		;; (iszero (dec n)) true f => (n <= 1)? true : f
	   (app 1 m)		;; ((n <= 1)? true : f) m
	   (app 1 6)		;; ((n <= 1)? true : f) m l+m
	   (app 1 6)		;; ((n <= 1)? true : f) m l+m (dec n)
	   ))
     (abs main (n)
	  ((app inc <1>)	;; inc 1 => 2
	   (app 1 1)		;; 2 2   => 2^2 = 4
	   (app 1 inc)		;; 4 inc
	   (app 1 2)		;; 4 inc 4 => 8
	   (app 2 1)		;; 4 inc 8 => 12
	   (app Y mkloop)	;; Y mkloop
	   (app 1 false)	;; (Y mkloop) 0
	   (app 1 <1>)		;; (Y mkloop) 0 1
	   (app 1 4)		;; (Y mkloop) 0 1 12
	   ))
     )))

(defvar grass-sample-infinity
  (concat
   "無限に草植えときますね"
   (japanese-zenkaku
    (grass-plant-code-to-string
     '(
       (abs main (n)
	    ((app out w)	;; out w
	     (app main n)	;; main n
	     ))
       )))))

)

(provide 'grass)

;;; grass.el ends here
