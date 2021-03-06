;;http://d.hatena.ne.jp/tamura70/20100205/org
;; org mode;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-modeの初期化
;; (require 'org)
;; (require 'org-install)
;; (require 'org-capture)
;; (require 'ox-html)
;; (require 'ox-latex)
;; (require 'ox-bibtex)
;; (require 'ox-ascii)
;; (require 'ox-beamer)
(require 'ox-md)
(when (require 'org-crypt nil t)
  ;; org-encrypt-entries の影響を受けるタグを指定
  ;; 自動保存の確認を無効に
  (setq org-crypt-key "<insert your key>"
        org-tags-exclude-from-inheritance (quote ("crypt"))
        org-crypt-disable-auto-save 'nil)
  )

;; (require 'org-habit)
;; (require 'org-mobile)
;; (add-to-list 'org-modules "org-habit")
(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))
;; (setq org-log-reschedule  'time)
(setq org-directory "~/org")
(setq org-startup-truncated                   nil
      org-latex-listings 'minted
      org-hide-leading-stars                  t     ;; 見出しの余分な*を消す
      org-return-follows-link                 t     ;;
      org-enforce-todo-dependencies           t     ;;
      org-use-speed-commands                  t     ;;
      org-log-done                            'time ;; DONEの時刻を記録

      ;; org-todo-keywords                       '((sequence "TODO(t)" "DELEGATED(g)" "SOMEDAY(s)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)" "REFERENCE(r)"));; TODO状態
      org-agenda-files                        '("inbox.org" "work.org") ;; アジェンダ表示の対象ファイル
      hl-line-face                            'underline
      calendar-holidays                       nil ;; 標準の祝日を利用しない
      org-alphabetical-lists                  t
      org-tag-alist                           '(("@OFFICE" . ?o) ("@HOME" . ?h) ("NOTE" . ?s))
      org-lowest-priority 68 ;; ← D (A...D)

      org-src-fontify-natively t
      org-fontify-whole-heading-line t

      org-export-latex-coding-system          'utf-8-unix
      org-export-with-sub-superscripts        nil

      org-html-html5-fancy                    t

      org-latex-text-markup-alist             '((bold . "\\textbf{%s}")
                                                (code . verb)
                                                (italic . "\\textit{%s}")
                                                (strike-through . "\\sout{%s}")
                                                (underline . "\\underline{%s}")
                                                (verbatim . protectedtexttt))

      org-capture-templates                   '(("i" "inbox"
                                                 entry (file "~/org/inbox.org")
                                                 "* %?\n %T\n %a\n %i\n"
                                                 :empty-lines 1 )
                                                ("h" "hobby"
                                                 entry (file "~/org/hobby.org")
                                                 "* %?\n %T\n %a\n %i\n"
                                                 :empty-lines 1)
                                                ("w" "work"
                                                 entry (file "~/org/work.org")
                                                 "* %?\n %T\n %i\n"
                                                 :empty-lines 1)
                                                ("d" "daily-template"
                                                 entry
                                                 (file+olp+datetree "daily.org")
                                                 "%[~/org/daily-template]"
                                                 ;; :unnarrowed 1
                                                 :time-prompt t
                                                 )))




;; 拡張子がorgのファイルを開いた時，自動的にorg-modeにする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-refile-targets
      '(("trash.org" :level . 1)
        ("next.org" :level . 1)))
(bind-keys :map global-map
           ("C-c a" . org-agenda)
           ("C-c c" . org-capture)
           ("C-c b" . org-iswitchb))


(add-hook 'org-mode-hook 'turn-on-font-lock);; org-modeでの強調表示を可能にする
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)));; アジェンダ表示で下線を用いる
(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)

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
         ;; (sh . t)
         ;;(ledger . t)
         (org . t)
         (plantuml . t)
         (latex . t))))
;; org-default-notes-fileのディレクトリ

;; (setq org-default-notes-file "notes.org")
;; (setq org-mobile-directory "~/Dropbox/mobileorg/")



;; (setq org-export-latex-classes nil)

;; beamerの設定
;; [NO-DEFAULT-PACKAGES]
;; \\usepackage[dvipdfmx]{graphicx,color}
;; \\usepackage{amsmath}
;; \\usepackage{float}
;; \\usepackage{hyperref}
;; \\usepackage{longtable}
;; \\usepackage{wrapfig}
;; \\usepackage{ulem}
;; \\hypersetup{setpagesize=false,colorlinks=true}
;; \\usepackage{wrapfig}
;; \\usepackage{typearea}
;; \\typearea{15}


(require 'ox-bibtex)
(require 'ox-odt)

(with-eval-after-load "ox-latex"
  (add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))
  (when (eq system-type 'gnu/linux)
	(setq org-latex-preview-ltxpng-directory  "/tmp/ltxpng/"))
  (setq latex 'platex
        org-latex-image-default-width           ".45\\linewidth"
        org-ditaa-jar-path                      "~/.emacs.d/ditaa.jar"
        org-export-latex-date-format            "%Y-%m-%d"
		org-latex-pdf-process                   '("latexmk %f")
        org-latex-create-formula-image-program  'imagemagick
        org-file-apps                           '(("pdf" . "evince %s"));; Viewerの設定(evince)
        org-beamer-frame-default-options        "fragile"
        org-latex-default-class                 "jarticle"
        org-latex-classes     `(("jarticle"
                                 ,(case latex
                                    ('luatex "\\documentclass{ltjsarticle}\n")
                                    ('xetex  "\\documentclass[a4paper]{bxjsarticle}\n")
                                    ('euptex "\\documentclass[a4j,uplatex]{jarticle}\n")
                                    (t       "\\documentclass[dvipdfmx]{jarticle}"))
                                 ("\\section{%s}" . "\\section*{%s}")
                                 ("\\subsection{%s}" . "\\subsection*{%s}")
                                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
                                 )
                                ("jreport"
                                 ,(case latex
                                    ('luatex "\\documentclass{ltjsarticle}\n")
                                    ('xetex  "\\documentclass[a4paper]{bxjsreport}\n")
                                    ('euptex "\\documentclass[11pt,report,uplatex]{jsbook}\n")
                                    (t       "\\documentclass[11pt,dvipdfmx]{jreport}"))
                                 ("\\chapter{%s}" . "\\chapter*{%s}")
                                 ("\\section{%s}" . "\\section*{%s}")
                                 ("\\subsection{%s}" . "\\subsection*{%s}")
                                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
                                 )
								("jsreport"
                                 ,(case latex
                                    ('luatex "\\documentclass{ltjsarticle}\n")
                                    ('xetex  "\\documentclass[a4paper]{bxjsreport}\n")
                                    ('euptex "\\documentclass[11pt,report,uplatex]{jsreport}\n")
                                    (t       "\\documentclass[11pt,dvipdfmx]{jsreport}"))
                                 ("\\chapter{%s}" . "\\chapter*{%s}")
                                 ("\\section{%s}" . "\\section*{%s}")
                                 ("\\subsection{%s}" . "\\subsection*{%s}")
                                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
                                 )
                                ("jbook"
                                 ,(case latex
                                    ('luatex "\\documentclass{ltjsarticle}\n")
                                    ('xetex  "\\documentclass[9pt,a4paper]{bxjsreport}\n")
                                    ('euptex "\\documentclass[9pt,a5j,uplatex]{jsbook}\n")
                                    (t       "\\documentclass[11pt,dvipdfmx]{jbook}"))
                                 ("\\part{%s}" . "\\part*{%s}")
                                 ("\\chapter{%s}" . "\\chapter*{%s}")
                                 ("\\section{%s}" . "\\section*{%s}")
                                 ("\\subsection{%s}" . "\\subsection*{%s}")
                                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
                                ("beamer"
                                 ,(concat
                                   (case latex
                                     ('xetex
                                      "\\documentclass[compress,xdvipdfmx]{beamer}\n")
                                     (t "\\documentclass[compress,dvipdfmx]{beamer}\n"))
                                   "\\usetheme{AnnArbor}\n"
                                   "\\setbeamertemplate{navigation symbols}{}\n"
                                   "[NO-PACKAGES]\n"
                                   "\\usepackage{graphicx}\n")
                                 org-beamer-sectioning))))
(defun my-org-screenshot ()
  "take screenshot"
  (interactive)
  (let ((filename
         (concat
          (make-temp-name
           (concat (expand-file-name "~/org/img/")
                   (buffer-name)
                   "_"
                   (format-time-string "%Y%m%d_%H%M%S_")))
         ".png")))
    (call-process "import" nil nil nil filename)
    (insert (concat "[[" filename "]]"))
    (org-display-inline-images)))
