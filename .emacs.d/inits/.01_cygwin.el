;; Cygwin は C:\cygwin(デフォルト)にインストールされており、
;; C:\cygwin\bin が既に Windows パスに含まれていないことを
;; 仮定しています(一般にはそうではない筈ですが)。
;;
(setq exec-path (cons "C:/cygwin/bin" exec-path))
(setenv "PATH" (concat "C:\\cygwin\\bin;" (getenv "PATH")))
;;
;; NT-emacs は、ここで変更する Windows コマンドシェルを
;; 使用します。
;;
(setq process-coding-system-alist '(("bash" . undecided-unix)))
(setq shell-file-name "bash")
(setenv "SHELL" shell-file-name)
(setq explicit-shell-file-name shell-file-name)
;;
;; これは、Java アプリケーションの出力に出現する
;; 見苦しい ^M 文字を削除します。
;;
(add-hook 'comint-output-filter-functions
          'comint-strip-ctrl-m)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
