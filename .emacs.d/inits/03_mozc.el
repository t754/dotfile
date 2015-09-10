


(when  (require 'mozc nil t)

  ;;(setq mozc-candidate-style 'overlay)
  (global-set-key (kbd "C-\\") 'toggle-input-method)
  ;; (bind-key (kbd "C-h") 'DEL mozc-mode-map)2

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

  ;; (if (featurep 'key-chord)
  ;;   (defadvice toggle-input-method (after my-toggle-input-method activate)
  ;;     (mozc-change-cursor-color)))

  )

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

(add-hook 'input-method-activate-hook 'mozc-change-cursor-color)
          ;; (lambda() (set-cursor-color "blue")))
(add-hook 'input-method-inactivate-hook 'mozc-change-cursor-color)
          ;; (lambda() (set-cursor-color "white")))

;; (defvar my-default-cursor-color)
;; (setq my-default-cursor-color (cdr (assoc 'cursor-color default-frame-alist)))
;; (add-hook 'input-method-activate-hook 'mozc-change-cursor-color)


