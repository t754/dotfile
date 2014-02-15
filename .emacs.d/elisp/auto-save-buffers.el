;;
;; auto-save-buffers.el
;;
;; ���̃R�[�h�͎R���������������Ă��������� (ELF:01128)
;;
;; �g����:
;;
;;   (require 'auto-save-buffers)
;;   (run-with-idle-timer 0.5 t 'auto-save-buffers) ; �A�C�h��0.5�b�ŕۑ�
;;
;; auto-save-buffers �� on/off ��؂�ւ��邽�߂̃L�[��` (C-x a s)
;;
;;   (define-key ctl-x-map "as" 'auto-save-buffers-toggle)
;;

;; auto-save-buffers �őΏۂƂ���t�@�C�����̐��K�\��
(defvar auto-save-buffers-regexp ""
  "*Regexp that matches `buffer-file-name' to be auto-saved.")

;; auto-save-buffers �ŏ��O����t�@�C�����̐��K�\��
(defvar auto-save-buffers-exclude-regexp "^$"
  "*Regexp that matches `buffer-file-name' not to be auto-saved.")

;;
;; ���邢�� auto-save-buffers �̈����Ő��K�\�����w�肷�邱�Ƃ��ł���
;;
;; (require 'auto-save-buffers)
;; (run-with-idle-timer 0.5 t 'auto-save-buffers "\\.c$" "^$") ; .c �����Ώ�
;; (run-with-idle-timer 0.5 t 'auto-save-buffers ""   "\\.h$") ; .h �������O
;;

;; nil �Ȃ�Z�[�u���Ȃ� (�^�C�}�[�͉�����܂�)
(defvar auto-save-buffers-active-p t
  "If non-nil, `auto-save-buffers' saves buffers.")

;; �ȗ��\�̈����ŁAinclude/exclude �p�̐��K�\�����w��ł���
(defun auto-save-buffers (&rest regexps)
  "Save buffers if `buffer-file-name' matches `auto-save-buffers-regexp'."
  (let ((include-regexp (or (car  regexps) auto-save-buffers-regexp))
        (exclude-regexp (or (cadr regexps) auto-save-buffers-exclude-regexp))
        (buffers (buffer-list)))
    (save-excursion
      (while buffers
	(set-buffer (car buffers))
	(if (and buffer-file-name
                 auto-save-buffers-active-p 
		 (buffer-modified-p)
		 (not buffer-read-only)
		 (string-match include-regexp buffer-file-name)
                 (not (string-match exclude-regexp buffer-file-name))
		 (file-writable-p buffer-file-name))
	    (save-buffer))
	(setq buffers (cdr buffers))))))

;; auto-save-buffers �� on/off ���g�O���Ő؂�ւ���
;; Based on the code by Yoshihiro (����ȓ��L 2004-03-23)
(defun auto-save-buffers-toggle ()
  "Toggle `auto-save-buffers'"
  (interactive)
  (if auto-save-buffers-active-p
      (setq auto-save-buffers-active-p nil)
    (setq auto-save-buffers-active-p t))
  (if auto-save-buffers-active-p
      (message "auto-save-buffers on")
    (message "auto-save-buffers off")))

;;
;; Emacs 21 �ȍ~�� Makefile �̕ҏW���� "Suspicious line XXX. Save anyway"
;; �Ƃ����v�����v�g���o���Ȃ��悤�ɂ��邽�߂̂��܂��Ȃ�
;;
(add-hook 'makefile-mode-hook
          (function (lambda ()
                      (fset 'makefile-warn-suspicious-lines 'ignore))))

(provide 'auto-save-buffers)
