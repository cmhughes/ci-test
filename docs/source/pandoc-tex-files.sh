#!/bin/bash

# argument check
ERROR="Too few arguments : no file name specified"
[[ $# -eq 0 ]] && echo $ERROR && exit  # no args? ... print error and exit

# name of MAINFILE
mainFile=$1

mainFile=${mainFile/%.tex/}

echo "Processing ${mainFile}.tex"
pandoc --filter pandoc-citeproc cmhlistings.tex ${mainFile}.tex -o ${mainFile}.rst --bibliography latex-indent.bib --bibliography contributors.bib
perl -pi -e 's|:numref:``(.*?)``|:numref:`$1`|g' ${mainFile}.rst 
# re-align tables, if necessary
perl -p0i -e 's/^(\|.*\|)/my $table_row = $1; my @cells = split(m!\|!,$table_row); foreach (@cells){ my $matches =0; $matches = () = ($_ =~ m@\:numref\:@g);$_ .= ("  " x $matches); };join("|",@cells)."\|";/mgxe' ${mainFile}.rst
perl -pi -e 's|\.\. \\\_|\.\. \_|g' ${mainFile}.rst 
# some code blocks need special treatment
perl -p0i -e 's/^::(?:\R|\h)*\{(.*?)\}\{((?:(?!(?:\{)).)*?)\}$/\.\. code-block:: latex\n   :caption: $1\n   :name: $2\n/msg' ${mainFile}.rst
# and this can lead to \\texttt still being present in .rst
perl -p0i -e 's/\\texttt\{(.*?)\}/``$1``/sg' ${mainFile}.rst
# remove line breaks from :alt: text
perl -p0i -e 's/(:alt:.*?)\R{2}(\h*)/\n\n$2/gs' ${mainFile}.rst
# remove line breaks from :caption: text
perl -p0i -e 's/(:caption:.*?)(^\h+:name:)/my $caption=$1; my $name=$2; $caption=~ s|\h*\R| |sg; $caption."\n".$name;/emgs' ${mainFile}.rst
# some literalincludes can have spurious line breaks
perl -p0i -e 's/^\h*(\.\. literalinclude::)\h*\R/$1 /gsm' ${mainFile}.rst

# reset the .tex file
git checkout ${mainFile}.tex
