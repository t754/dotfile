(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-mozc")

(when  (require 'mozc nil t)
  (set-buffer-file-coding-system 'utf-8)
  (set-buffer-file-coding-system 'utf-8)
  (set-clipboard-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-language-environment "Japanese")
  (set-terminal-coding-system 'utf-8)
  (prefer-coding-system 'utf-8-unix)

  (setq default-buffer-file-coding-system 'utf-8
        mozc-color "PowderBlue"
        default-input-method "japanese-mozc"
        mozc-candidate-style 'echo-area)

  (global-set-key (kbd "C-\\") 'toggle-input-method)
  (bind-keys :map mozc-mode-map
             ("C-g" . toggle-input-method)))



;; helm で候補のアクションを表示する際に IME を OFF にする
(defadvice helm-select-action (before ad-helm-select-action-for-mozc activate)
  (if (>= (string-to-number emacs-version) 24.3)
      (deactivate-input-method)
    (inactivate-input-method)))



(defun mozc-change-cursor-color ()
    (if mozc-mode
        (set-cursor-color mozc-color)
      (set-cursor-color "orange")
      ))

(defun input-method-activate-hooks ()
  ;; 何もしなかったら 3sec で disable
  (run-with-idle-timer 3 nil #'deactivate-input-method)
  (mozc-change-cursor-color))

(add-hook 'input-method-activate-hook 'input-method-activate-hooks)

(add-hook 'input-method-inactivate-hook 'mozc-change-cursor-color)
