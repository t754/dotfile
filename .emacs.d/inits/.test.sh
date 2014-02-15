#!/bin/sh
cd ~/.emacs.d/inits/
echo "byte-compile   (c)"
echo "rm *.elc        (r)"
echo "*el-> ~/test.el (m)"
echo -n ":"
read a
if [ $a = m ] ; then
	for f in *el ;do echo ";;################################################";echo ";;################################################";echo ";;$f";echo ";;################################################";echo ";;################################################";cat $f;done > ~/test.el
	echo "*.el-> ~/test.el‚Éˆê“Z‚ß"
elif [ $a = r ] ; then
	rm *.elc
elif [ $a = c ] ; then
	emacs -batch -f batch-byte-compile *.el

fi

