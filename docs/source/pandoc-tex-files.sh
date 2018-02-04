#!/bin/bash

for f in sec-introduction sec-demonstration sec-how-to-use
do
    echo "Processing ${f}.tex"
    pandoc --filter pandoc-citeproc cmhlistings.tex ${f}.tex -o ${f}.rst --bibliography latex-indent.bib --bibliography contributors.bib
    perl -pi -e 's|:numref:``(.*?)``|:numref:`$1`|g' ${f}.rst 
    perl -pi -e 's|\.\. \\\_|\.\. \_|g' ${f}.rst 
    perl -p0i -e 's/^::(?:\R|\h)*\{(.*?)\}\{((?:(?!(?:\{)).)*?)\}$/\.\. code-block:: latex\n   :caption: $1\n   :name: $2\n/msg' ${f}.rst
    perl -p0i -e 's/\\texttt\{(.*?)\}/``$1``/sg' ${f}.rst
done
exit
