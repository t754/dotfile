  (when (require 'mozc nil t)
      ;; (load-file "/usr/share/emacs/site-lisp/emacs-mozc/mozc.elc")
    (set-language-environment "Japanese")
     ;;(setq mozc-candidate-style 'overlay)
    (setq mozc-candidate-style 'echo-area)
    (global-set-key (kbd "C-\\") 'toggle-input-method)
    (prefer-coding-system 'utf-8-unix)
    (set-default-coding-systems 'utf-8)
    (set-terminal-coding-system 'utf-8)
    (set-keyboard-coding-system 'utf-8)
    (set-buffer-file-coding-system 'utf-8)
    (setq default-buffer-file-coding-system 'utf-8)
    (set-buffer-file-coding-system 'utf-8)
    (set-clipboard-coding-system 'utf-8)
    (setq mozc-color "blue")
    (setq default-input-method "japanese-mozc")
    )



  
