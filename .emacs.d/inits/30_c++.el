(eval-after-load "irony"
  '(progn
     (custom-set-variables '(irony-additional-clang-options '("-std=c++11")))
     (add-to-list 'company-backends 'company-irony)
     (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
     (add-hook 'c-mode-common-hook 'irony-mode)))

(defun my-irony-mode-hook ()
  (company-irony-setup-begin-commands)
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async)
  (auto-complete-mode -1)
  (irony-eldoc)
  (irony-cdb-autosetup-compile-options))


(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(eval-after-load "flycheck"
  '(progn
     (when (locate-library "flycheck-irony")
       (flycheck-irony-setup)
       ;;(flycheck-add-next-checker 'irony '(warning . c/c++-googlelint))
       )))



(use-package cmake-ide
  :bind
  (("<f9>" . cmake-ide-compile))
  :config
  (progn
    ;; (setq
    ;;  ;; rdm & rcコマンドへのパス。コマンドはRTagsのインストール・ディレクトリ下。
    ;;  cmake-ide-rdm-executable "path_to_rdm"
    ;;  cmake-ide-rc-executable  "path_to_rc"
    ;;  )
    ))


;; rtag
;; (custom-set-variables '(rtags-use-helm t))
;; git clone --recursive ‌https://github.com/Andersbakken/rtags.git
;; cd rtags
;; cmake .
;; make
;; sudo make install
(use-package rtags
  :config
  (progn
    (rtags-enable-standard-keybindings c-mode-base-map)
    ;; 関数cmake-ide-setupを呼ぶのはrtagsをrequireしてから。
    (cmake-ide-setup)))



(use-package irony
  :config
  (progn
    ;; ironyのビルド&インストール時にCMAKE_INSTALL_PREFIXで指定したディレクトリへのパス。
    ;; (setq irony-server-install-prefix "where_to_install_irony")
    (add-hook 'irony-mode-hook 'my-irony-mode-hook)
    (add-to-list 'company-backends 'company-irony)
    ))

;; (add-hook 'c-mode-common-hook 'flycheck-mode)
;; (add-hook 'c++-mode-hook      'irony-mode)
