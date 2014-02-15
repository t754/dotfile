;;; inform-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (inform-maybe-mode inform-mode) "inform-mode" "inform-mode.el"
;;;;;;  (21093 10834 806278 82000))
;;; Generated autoloads from inform-mode.el

(autoload 'inform-mode "inform-mode" "\
Major mode for editing Inform programs.

* Inform syntax:

  Type \\[indent-for-tab-command] to indent the current line.
  Type \\[indent-region] to indent the region.

  Type \\[fill-paragraph] to fill strings or comments.
  This compresses multiple spaces into single spaces.

* Multi-file projects:

  The variable `inform-project-file' gives the name of the root file of
  the project (i.e., the one that you run Inform on); it is best to
  set this as a local variable in each file, for example by making
     ! -*- inform-project-file:\"game.inf\" -*-
  the first line of the file.

* Tags tables:

  Type \\[inform-retagify] to build (and load) a Tags table.
  Type \\[visit-tags-table] to load an existing Tags table.
  If it exists, and if the variable `inform-autoload-tags' is non-NIL,
  the Tags table is loaded on entry to Inform Mode.
  With a Tags table loaded, type \\[find-tag] to find the declaration of
  the object, class or function under point.

* Navigating in a file:

  Type \\[inform-prev-object] to go to the previous object/class declaration.
  Type \\[inform-next-object] to go to the next one.

* Compilation:

  Type \\[inform-build-project] to build the current project.
  Type \\[next-error] to go to the next error.

* Running:

  Type \\[inform-run-project] to run the current project in an
  interpreter, either as a separate process or in an Emacs terminal buffer.

* Spell checking:

  Type \\[inform-spell-check-buffer] to spell check all strings in the buffer.
  Type \\[ispell-word] to check the single word at point.

* Key definitions:

\\{inform-mode-map}
* Functions:

  inform-maybe-mode
    Looks at the contents of a file, guesses whether it is an Inform
    program, runs `inform-mode' if so, or `inform-maybe-other' if not.
    The latter defaults to `c-mode'.  Used for header files which might
    be Inform or C programs.

* Miscellaneous user options:

  inform-startup-message
    Set to nil to inhibit message first time Inform mode is used.

  inform-maybe-other
    The mode used by `inform-maybe-mode' if it guesses that the file is
    not an Inform program.

  inform-mode-hook
    This hook is run after entry to Inform Mode.

  inform-autoload-tags
    If non-nil, then a tags table will automatically be loaded when
    entering Inform mode.

  inform-auto-newline
    If non-nil, then newlines are automatically inserted before and
    after braces, and after semicolons in Inform code, and after commas
    in object declarations.

* User options controlling indentation style:

  Values in parentheses are the default indentation style.

  inform-indent-property (8)
    Indentation of a property or attribute in an object declaration.

  inform-indent-has-with-class (1)
    Indentation of has/with/class/private lines in object declaration.

  inform-indent-level (4)
    Indentation of line of code in a block relative to the first line of
    the block.

  inform-indent-label-offset (-3)
    Indentation of a line starting with a label, relative to the
    indentation if the label were absent.

  inform-indent-cont-statement (4)
    Indentation of second and subsequent lines of a statement, relative
    to the first.

  inform-indent-fixup-space (T)
    If non-NIL, fix up space after `Object', `Class', `Nearby', `has',
    `private' and `with', so that all the object's properties line up.

  inform-indent-action-column (40)
    Column at which action names should be placed in verb declarations.
    If NIL, then action names are not moved.

  inform-comments-line-up-p (NIL)
    If non-NIL, comments spread out over several lines will start on the
    same column as the first comment line.

  inform-strings-line-up-p (NIL)
    Variable controlling indentation of multi-line strings.
    If nil (default), string will be indented according to context.
    If a number, will always set the indentation to that column.
    If 'char', will line up with the first character of the string.
    If 'quote', or other non-nil value, will line up with open quote on
    first line.

* User options to do with compilation:

  inform-command
    The shell command with which to run the Inform compiler.

  inform-libraries-directory
    If non-NIL, gives the directory in which the Inform libraries are
    found.

  inform-command-options
    Additional options with which to call the Inform compiler.

* User options to do with an interpreter:

  inform-interpreter-command
    The command with which to run the ZCode interpreter.  Can be a
    string (a command to be run), a symbol (name of function to call)
    or a function.

  inform-interpreter-options
    Additional options with which to call the ZCode interpreter.  Only
    used if `inform-interpreter-command' is a string.

  inform-interpreter-kill-old-process
    If non-NIL, `inform-run-project' will kill any running interpreter
    process and start a new one.  If not, will switch to the interpreter's
    buffer (if necessary - see documentation for `inform-run-project' for
    details).

  inform-interpreter-is-graphical
    If NIL, `inform-run-project' will switch to the interpreter buffer
    after running the interpreter.


* Please send any bugs or comments to rupert@rupert-lane.org

\(fn)" t nil)

(autoload 'inform-maybe-mode "inform-mode" "\
Start Inform mode if file is in Inform; `inform-maybe-other' otherwise.

\(fn)" nil nil)

(setq auto-mode-alist (append '(("\\.h\\'" . inform-maybe-mode) ("\\.inf\\'" . inform-mode)) auto-mode-alist))

(add-hook 'inform-mode-hook 'turn-on-font-lock)

;;;***

;;;### (autoloads nil nil ("inform-mode-pkg.el") (21093 10834 895278
;;;;;;  308000))

;;;***

(provide 'inform-mode-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; inform-mode-autoloads.el ends here
