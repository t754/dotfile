;;Multi-term----------------------------------------------
;;(when(require 'multi-term nil t)
;; (setq multi-term-program shell-file-name)
;;
;;(global-set-key (kbd "C-c t") '(lambda ()
;;                                (interactive)
;;                                (multi-term)))
;;(add-to-list 'term-unbind-key-list "C-\\")
;;(eval-when-compile (require 'cl))
;; (setq multi-term-default-dir "~/.emacs.d")
;;
;;(setq system-uses-terminfo t)
;;
;;(setq multi-term-program shell-file-name
;;      ansi-term-color-vector [unspecified
;;                              "black" "red3" "green3" "yellow3"
;;                              "DeepSkyBlue" "magenta1" "cyan3" "white"])
;;;; my-keybinds for keybinds -e
;;(defun term-send-forward-char ()
;;  (interactive)
;;  (term-send-raw-string "\C-f"))
;;
;;(defun term-send-backward-char ()
;;  (interactive)
;;  (term-send-raw-string "\C-b"))
;;
;;(defun term-send-previous-line ()
;;  (interactive)
;;  (term-send-raw-string "\C-p"))
;;
;;(defun term-send-next-line ()
;;  (interactive)
;;  (term-send-raw-string "\C-n"))
;;(autoload 'ansi-color-for-comint-mode-on "ansi-color"
;;  "Set `ansi-color-for-comint-mode' to t." t)
;;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;;
;;
;;(add-hook 'term-mode-hook
;;          '(lambda ()
;;             (let* ((key-and-func
;;                     `(("\C-p"           term-send-previous-line)
;;                       ("\C-n"           term-send-next-line)
;;                       ("\C-b"           term-send-backward-char)
;;                       ("\C-f"           term-send-forward-char)
;;                       (,(kbd "C-h")     term-send-backspace)
;;                       (,(kbd "C-y")     term-paste)
;;                       (,(kbd "ESC ESC") term-send-raw)
;;                       (,(kbd "C-S-p")   multi-term-prev)
;;                       (,(kbd "C-S-n")   multi-term-next)
;;                       ;; 利用する場合は
;;                       ;; helm-shell-historyの記事を参照してください
;;                       ;; ("\C-r"           helm-shell-history)
;;                       )))
;;               (loop for (keybind function) in key-and-func do
;;                     (define-key term-raw-map keybind function))))))
;;




;; (global-set-key (kbd "C-c t") '(lambda ()

;;                               (interactive)
;;                               (multi-term)))



;;;
(require 'shell-pop)
;; multi-term �ɑΉ�
;(add-to-list 'shell-pop-internal-mode-list '("multi-term" "*terminal<1>*" '(lambda () (multi-term))))
;(shell-pop-set-internal-mode "multi-term")
;; 25% �̍����ɕ�������
(shell-pop-set-window-height 25)
(shell-pop-set-internal-mode-shell shell-file-name)
;; �V���[�g�J�b�g���D�݂ŕύX���Ă�������
(global-set-key (kbd "C-c C-t") 'shell-pop)


(provide 'init_shell)
