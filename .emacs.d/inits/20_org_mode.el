;;http://d.hatena.ne.jp/tamura70/20100205/org
;; org mode;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-modeの初期化
(require 'org)
(require 'org-install)
(require 'org-capture)

(when (require 'org-crypt nil t)
  (setq org-crypt-key "<insert your key>")
  ;; org-encrypt-entries の影響を受けるタグを指定
  (setq org-tags-exclude-from-inheritance (quote ("crypt")))
  ;; 自動保存の確認を無効に
  (setq org-crypt-disable-auto-save 'nil)
  )

;; (require 'org-habit)
;; (require 'org-mobile)
;; (add-to-list 'org-modules "org-habit")


(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c b") 'org-iswitchb)

(setq org-startup-truncated nil)
(setq org-return-follows-link t)
;; 拡張子がorgのファイルを開いた時，自動的にorg-modeにする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; 見出しの余分な*を消す
(setq org-hide-leading-stars t)
;; org-modeでの強調表示を可能にする
(add-hook 'org-mode-hook 'turn-on-font-lock)

;; org-default-notes-fileのディレクトリ
;; (setq org-directory "~/Dropbox/org/")
;; (setq org-default-notes-file "notes.org")
;; (setq org-mobile-directory "~/Dropbox/mobileorg/")

;; TODO状態
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "SOMEDAY(s)")))
(setq org-enforce-todo-dependencies t)
;; DONEの時刻を記録
(setq org-log-done 'time)
(add-hook 'orgtbl-mode-hook (function (lambda ()
										(define-key orgtbl-mode-map [?\e (return)] 'org-meta-return)
										(define-key orgtbl-mode-map [?\e (left)]   'org-metaleft)
										(define-key orgtbl-mode-map [?\e (right)]  'org-metaright)
										(define-key orgtbl-mode-map [?\e (up)]     'org-metaup)
										(define-key orgtbl-mode-map [?\e (down)]   'org-metadown)
										)))





;; アジェンダ表示の対象ファイル
(setq org-agenda-files (list org-directory) )
;; アジェンダ表示で下線を用いる
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))
(setq hl-line-face 'underline)
;; 標準の祝日を利用しない
(setq calendar-holidays nil)
 
;;org-capture

(setq org-capture-templates
      '(("t" "Task" entry (file+headline nil "Inbox")
         "** TODO %?\n %T\n %a\n %i\n")
        ("b" "Bug" entry (file+headline nil "Inbox")
         "** TODO %?   :bug:\n  %T\n %a\n %i\n")
        ("m" "Meeting" entry (file+headline nil "Meeting")
         "** %?\n %U\n %a\n %i\n")
        ("i" "Idea" entry (file+headline nil "Idea")
         "** %?\n %U\n %i\n %a\n %i\n")
        ;; ("d" "drill" entry
        ;;  (file+headline (concat (getenv "HOME") "/Dropbox/flashCard.org") "hat")
        ;;        "* Word :drill:\n%^ \n** Answer \n%^")
        ("c" "同期カレンダーにエントリー" entry
          (file+headline nil "Schedule")
          "** TODO %?\n\t")
        )
      )

;;C-c C-e d
(setq org-alphabetical-lists t)
(setq org-tag-alist
  '(("@OFFICE" . ?o) ("@HOME" . ?h) ("NOTE" . ?s)
    ))



(setq org-latex-image-default-width ".45\\linewidth")
(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)

(setq org-latex-text-markup-alist '((bold . "\\textbf{%s}")
					 (code . verb)
					 (italic . "\\textit{%s}")
					 (strike-through . "\\sout{%s}")
					 (underline . "\\underline{%s}")
					 (verbatim . protectedtexttt)))

(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))

(setq org-ditaa-jar-path "~/.emacs.d/jditaa.jar")
(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
         (dot .  t)
         (ditaa . t)
         (R . t)
         (python . t)
         (ruby . t)
         (gnuplot . t)
         (clojure . t)
         (sh . t)
         ;;(ledger . t)
         (org . t)
         ;;(plantuml . t)
         (latex . t))))

(add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))

(setq org-export-latex-date-format "%Y-%m-%d")
(require 'ox-html)
(require 'ox-latex)
(require 'ox-bibtex)
(require 'ox-ascii)
(require 'ox-beamer)
(require 'ox-md)



(setq org-latex-create-formula-image-program 'imagemagick)
(setq org-latex-pdf-process '
      ("latexmk -e '$latex=q/platex -interaction nonstopmode %S/' -e '$bibtex=q/pbibtex %B/' -e '$makeindex=q/mendex -o %D %S/' -e '$dvipdf=q/dvipdfmx -o %D %S/' -norc -gg -pdfdvi %f"))

;; Viewerの設定(evince)
(customize-set-variable 'org-file-apps
                        '(("pdf" . "evince %s")))

(setq org-export-latex-coding-system 'utf-8-unix)
(setq org-export-with-sub-superscripts nil)
;; (setq org-export-latex-classes nil)
(setq org-latex-default-class "jarticle")
(add-to-list 'org-latex-classes
			 '("jarticle"
			   "\\documentclass{jarticle}
 [NO-DEFAULT-PACKAGES]
\\usepackage[dvipdfmx]{graphicx,color}
\\usepackage{amsmath}
\\usepackage{float}
\\usepackage{hyperref}
\\usepackage{longtable}
\\usepackage{wrapfig}
\\usepackage{ulem}
\\hypersetup{setpagesize=false,colorlinks=true}
\\usepackage{wrapfig}
\\usepackage{typearea}
\\typearea{15}

"
			   ("\\section{%s}" . "\\section*{%s}")
			   ("\\subsection{%s}" . "\\subsection*{%s}")
			   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
			   ("\\paragraph{%s}" . "\\paragraph*{%s}")
			   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
			   ))





;; beamerの設定
(add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass[presentation]{beamer}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
[EXTRA]"
                    ("\\section{%s}" . "\\section*{%s}")
                    ("\\subsection{%s}" . "\\subsection*{%s}")
                    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
(setq org-beamer-frame-default-options "fragile")


(setq org-html-html5-fancy t)

(require 'org-trello)
