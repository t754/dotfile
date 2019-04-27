(add-to-list 'load-path "/usr/share/emacs/site-lisp/mozc")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-mozc")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/anthy")

(setq input-cursor-color "PowderBlue")
(cond ((require 'mozc nil t)
       (setq mozc-color input-cursor-color
             default-input-method "japanese-mozc"
             mozc-candidate-style 'echo-area)
       (global-set-key (kbd "C-\\") 'toggle-input-method)
       (bind-keys :map mozc-mode-map
                  ("C-g" . toggle-input-method)))

      ((require 'anthy nil t)
       (defvaralias 'last-command-char 'last-command-event)
       (set-language-environment "Japanese")
       (setq default-input-method "japanese-anthy")
       (global-set-key (kbd "C-\\") 'toggle-input-method)
       (anthy-load-hiragana-map anthy-alt-char-map)
       (set-language-environment "Japanese")
       ;;変換時の文字の色
       (set-face-foreground 'anthy-highlight-face "white")
       (set-face-background 'anthy-highlight-face "black")
       ;;アンダーライン消去
       (set-face-underline 'anthy-highlight-face nil)
       (set-face-underline 'anthy-underline-face nil)
       (set-face-background 'anthy-underline-face "dark blue")))

(set-buffer-file-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(prefer-coding-system 'utf-8-unix)
(setq default-buffer-file-coding-system 'utf-8)

(defmacro unbound?(x)
  `(and (boundp ',x) ,x))

(defun change-cursor-color ()
  (cond ((unbound? mozc-mode) (set-cursor-color mozc-color))
        ((unbound? anthy-minor-mode) (set-cursor-color input-cursor-color))
        (t (set-cursor-color "orange"))))

(add-hook 'input-method-activate-hook
          (lambda () (change-cursor-color)))
(add-hook 'input-method-inactivate-hook
          (lambda() (change-cursor-color)))
