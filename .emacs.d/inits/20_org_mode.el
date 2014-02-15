;;http://d.hatena.ne.jp/tamura70/20100205/org
;; org mode;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-modeの初期化
(require 'org)
(require 'org-install)
(require 'org-habit)
(add-to-list 'org-modules "org-habit")
;;(require 'org-compat)
;;(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-startup-truncated nil)
(setq org-return-follows-link t)
;; 拡張子がorgのファイルを開いた時，自動的にorg-modeにする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; 見出しの余分な*を消す
(setq org-hide-leading-stars t)
;; org-modeでの強調表示を可能にする
(add-hook 'org-mode-hook 'turn-on-font-lock)
;; org-default-notes-fileのディレクトリ
(setq org-directory "~/Dropbox/org/")
;; (setq org-agenda-files `("~/Dropbox/org/main.org"))
;; (setq org-agenda-files (list "notes.org")) 
(setq org-default-notes-file "notes.org")
(setq org-mobile-inbox-for-pull "~/Dropbox/org/inbox.org")
(setq org-mobile-directory "~/Dropbox/mobileorg")
;; org-default-notes-fileのファイル名

;; TODO状態
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "SOMEDAY(s)")))
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
(require 'org-capture)
(setq org-capture-templates
      '(("t" "Task" entry (file+headline nil "Inbox")
         "** TODO %?\n %T\n %a\n %i\n")
        ("b" "Bug" entry (file+headline nil "Inbox")
         "** TODO %?   :bug:\n  %T\n %a\n %i\n")
        ("m" "Meeting" entry (file+headline nil "Meeting")
         "** %?\n %U\n %a\n %i\n")
        ("i" "Idea" entry (file+headline nil "Idea")
         "** %?\n %U\n %i\n %a\n %i\n")
        ;; ("w" "Twitter" entry (file+datetree "twitter.org")
        ;;  "** %U %?\n")
        )
      )
(global-set-key (kbd "C-c c") 'org-capture)

;;C-c C-e d
;; (require 'org-latex)
;; 

;;C-c C-e d
(setq org-alphabetical-lists t)
(setq org-tag-alist
  '(("@OFFICE" . ?o) ("@HOME" . ?h) ("NOTE" . ?s)
    ))
;; Explicitly load required exporters
(require 'ox-icalendar)
(require 'ox-html)
(require 'ox-latex)
(require 'ox-ascii)
(require 'ox-beamer)

(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)

(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))

(setq org-ditaa-jar-path "~/.emacs.d/jditaa.jar")
(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote (
         (emacs-lisp . t)
         (dot . t)
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

(setq org-export-latex-date-format "%Y-%m-%d")
;;(setq org-export-latex-default-class "jarticle")
;;(setq org-latex-to-pdf-process '("mylatex.sh %b""mylatex.sh %b"))

 (setq org-latex-pdf-process '("extractbb *\\.png 2> /dev/null "
                               "latexmk -e '$latex=q/platex -interaction nonstopmode %S/' -e '$bibtex=q/pbibtex %B/' -e '$makeindex=q/mendex -o %D %S/' -e '$dvipdf=q/dvipdfmx -o %D %S/' -norc -gg -pdfdvi %f"))


;; (setq org-latex-to-pdf-process '("platex --kanji=utf8 -interaction nonstopmode %b"
;; 								 "platex --kanji=utf8 -interaction nonstopmode %b"
;; 								 "dvipdfmx %b"))
;;拡張子epsの取扱いについて
										;(setq org-export-latex-inline-image-extensions nil)
										;(add-to-list 'org-export-latex-inline-image-extensions "eps")

;; Viewerの設定(acroread)
(customize-set-variable 'org-file-apps
                        '(("pdf" . "acroread %s")))

(setq org-export-latex-coding-system 'utf-8-unix)
(setq org-export-with-sub-superscripts nil)
(setq org-export-latex-classes nil)




(setq org-latex-default-class "jarticle")

(add-to-list 'org-latex-classes
			 '("jarticle"
			   "\\documentclass{jarticle}
 [NO-DEFAULT-PACKAGES]
\\usepackage[dvipdfmx]{graphicx,color}
\\usepackage{float}
\\usepackage{hyperref}
\\usepackage{longtable}
\\usepackage{wrapfig}
\\hypersetup{setpagesize=false,colorlinks=true}
\\usepackage{wrapfig}
\\setlength{\\topmargin}{20mm}
\\addtolength{\\topmargin}{-1in}
\\setlength{\\oddsidemargin}{20mm}
\\addtolength{\\oddsidemargin}{-1in}
\\setlength{\\evensidemargin}{15mm}
\\addtolength{\\evensidemargin}{-1in}
\\setlength{\\textwidth}{170mm}
\\setlength{\\textheight}{254mm}
\\setlength{\\headsep}{0mm}
\\setlength{\\headheight}{0mm}
\\setlength{\\topskip}{0mm}


\\renewenvironment{itemize}
{
   \\begin{list}{\\parbox{1zw}{$\\bullet$}}
   {
      \\setlength{\\topsep}{0zh}
      \\setlength{\\itemindent}{0zw}
      \\setlength{\\leftmargin}{2zw}
      \\setlength{\\rightmargin}{0zw}
      \\setlength{\\labelsep}{1zw}
      \\setlength{\\labelwidth}{3zw}
      \\setlength{\\itemsep}{-2mm}
      \\setlength{\\parsep}{0em}
      \\setlength{\\listparindent}{0zw}
      \\setlength{\\parskip}{0cm}
}
}{
   \\end{list}
}
\\renewenvironment{enumerate}
{
   
   \\begin{list}{\\arabic{enumi}.}
    {
      \\usecounter{enumi}
      \\setlength{\\topsep}{0zh}
      \\setlength{\\itemindent}{0zw}
      \\setlength{\\leftmargin}{2zw}
      \\setlength{\\rightmargin}{0zw}
      \\setlength{\\labelsep}{1zw}
      \\setlength{\\labelwidth}{3zw}
      \\setlength{\\itemsep}{-2mm}
      \\setlength{\\parsep}{0em}
      \\setlength{\\listparindent}{0zw}
      \\setlength{\\parskip}{0cm}
}
}{
   \\end{list}
}


"
			   ("\\section{%s}" . "\\section*{%s}")
			   ("\\subsection{%s}" . "\\subsection*{%s}")
			   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
			   ("\\paragraph{%s}" . "\\paragraph*{%s}")
			   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
			   ))





;; beamerの設定
;; (add-to-list 'org-export-latex-classes
;;              '("beamer"
;;                "\\documentclass[compress,dvipdfm]{beamer}
;;                [NO-DEFAULT-PACKAGES]"
;;                org-beamer-sectioning
;;                ))
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
;;(setq org-export-latex-default-packages-alist
;;  '(("AUTO" "inputenc"  t)
;;    ("T1"   "fontenc"   t)
;;    (""     "fixltx2e"  nil)
;;    (""     "graphicx"  t)
;;    (""     "longtable" nil)
;;    (""     "float"     nil)
;;    (""     "wrapfig"   nil)
;;    (""     "soul"      t)
;;    (""     "textcomp"  t)
;;    (""     "marvosym"  t)
;;    (""     "wasysym"   t)
;;    (""     "latexsym"  t)
;;    (""     "amssymb"   t)
;;    ("dvipdfmx"     "hyperref"  nil)
;;    "\\tolerance=1000"
;;    )
;;)

;; (add-hook 'org-export-html-final-hook
;;           '(lambda () (perform-replace "@&amp;" "&" nil nil nil)))

;;org-remenberr -> capture にいれかえ
;;(org-remember-insinuate)
;;(define-key global-map "\C-cr" 'org-remember)
;;(setq org-remember-templates
;; 	  '(("Todo" ?t "** TODO %?\n   %i\n   %a\n   %t" nil "Inbox")
;; 		("Bug" ?b "** TODO %?   :bug:\n   %i\n   %a\n   %t" nil "Inbox")
;; 		("Idea" ?i "** %?\n   %i\n   %a\n   %t" nil "New Ideas")))


(when (require 'org-crypt nil t)
  (setq org-crypt-key "<insert your key>")
  ;; org-encrypt-entries の影響を受けるタグを指定
  (setq org-tags-exclude-from-inheritance (quote ("crypt")))
  ;; 自動保存の確認を無効に
  (setq org-crypt-disable-auto-save 'nil)
  (setq auto-save-default 'nil)
  )
