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

(setq org-directory "~/Dropbox/org/")
(setq org-startup-truncated                   nil
      org-hide-leading-stars                  t ;; 見出しの余分な*を消す
      org-return-follows-link                 t
      org-enforce-todo-dependencies           t
      org-use-speed-commands                  t ;;
      org-log-done                            'time ;; DONEの時刻を記録
      org-todo-keywords                       '((sequence "INBOX(i)" "TODO(t)" "WAIT(w)" "|" "DONE(d)" "SOMEDAY(s)"));; TODO状態
      org-agenda-files                        (list org-directory) ;; アジェンダ表示の対象ファイル
      hl-line-face                            'underline
      calendar-holidays                       nil ;; 標準の祝日を利用しない
      org-alphabetical-lists                  t
      org-tag-alist                           '(("@OFFICE" . ?o) ("@HOME" . ?h) ("NOTE" . ?s))


      org-export-latex-coding-system          'utf-8-unix
      org-export-with-sub-superscripts        nil

      org-html-html5-fancy                    t

      org-latex-text-markup-alist             '((bold . "\\textbf{%s}")
                                                (code . verb)
                                                (italic . "\\textit{%s}")
                                                (strike-through . "\\sout{%s}")
                                                (underline . "\\underline{%s}")
                                                (verbatim . protectedtexttt))

      org-capture-templates                   '(("t" "Task" entry (file+headline nil "Inbox")
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
                                                 "** TODO %?\n\t")))

;; 拡張子がorgのファイルを開いた時，自動的にorg-modeにする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

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
         (sh . t)
         ;;(ledger . t)
         (org . t)
         ;;(plantuml . t)
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
(with-eval-after-load "ox-latex"
  (add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))
  (setq latex 'platex
        org-latex-image-default-width           ".45\\linewidth"
        org-ditaa-jar-path                      "~/.emacs.d/ditaa.jar"
        org-export-latex-date-format            "%Y-%m-%d"
        org-latex-create-formula-image-program  'imagemagick
        org-latex-pdf-process                   '("latexmk -C %f && latexmk  %f")
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

;;;------------------------------------------------------------------
;;;; org-trello
;; (require 'org-trello)
;; (add-hook 'org-trello-mode-hook
;;   (lambda ()
;;     (define-key org-trello-mode-map (kbd "C-c x v") 'org-trello/version)
;;     (define-key org-trello-mode-map (kbd "C-c x i") 'org-trello/install-key-and-token)
;;     (define-key org-trello-mode-map (kbd "C-c x I") 'org-trello/install-board-metadata)
;;     (define-key org-trello-mode-map (kbd "C-c x c") 'org-trello/sync-card)
;;     (define-key org-trello-mode-map (kbd "C-c x s") 'org-trello/sync-buffer)
;;     (define-key org-trello-mode-map (kbd "C-c x a") 'org-trello/assign-me)
;;     (define-key org-trello-mode-map (kbd "C-c x d") 'org-trello/check-setup)
;;     (define-key org-trello-mode-map (kbd "C-c x D") 'org-trello/delete-setup)
;;     (define-key org-trello-mode-map (kbd "C-c x b") 'org-trello/create-board-and-install-metadata)
;;     (define-key org-trello-mode-map (kbd "C-c x k") 'org-trello/kill-entity)
;;     (define-key org-trello-mode-map (kbd "C-c x K") 'org-trello/kill-cards)
;;     (define-key org-trello-mode-map (kbd "C-c x a") 'org-trello/archive-card)
;;     (define-key org-trello-mode-map (kbd "C-c x A") 'org-trello/archive-cards)
;;     (define-key org-trello-mode-map (kbd "C-c x j") 'org-trello/jump-to-trello-card)
;;     (define-key org-trello-mode-map (kbd "C-c x J") 'org-trello/jump-to-trello-board)
;;     (define-key org-trello-mode-map (kbd "C-c x C") 'org-trello/add-card-comments)
;;     (define-key org-trello-mode-map (kbd "C-c x o") 'org-trello/show-card-comments)
;;     (define-key org-trello-mode-map (kbd "C-c x l") 'org-trello/show-card-labels)
;;     (define-key org-trello-mode-map (kbd "C-c x u") 'org-trello/update-board-metadata)
;;     (define-key org-trello-mode-map (kbd "C-c x h") 'org-trello/help-describing-bindings)))
;; ;; org-trello major mode for all .trello files
;; (add-to-list 'auto-mode-alist '("\\.trello$" . org-mode))
;; add a hook function to check if this is trello file, then activate the org-trello minor mode.
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (let ((filename (buffer-file-name (current-buffer))))
;;               (when (and filename (string= "trello" (file-name-extension filename)))
;;                 (org-trello-mode)))))
