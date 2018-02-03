#!/bin/bash

# introduction
#pandoc --filter pandoc-citeproc cmhlistings.tex sec-introduction.tex -o sec-introduction.rst --bibliography latex-indent.bib --bibliography contributors.bib
#pandoc --filter pandoc-citeproc cmhlistings.tex sec-demonstration.tex -o sec-demonstration.rst --bibliography latex-indent.bib --bibliography contributors.bib
#
#perl -pi -e 's|:numref:``(.*?)``|:numref:`$1`|' sec-demonstration.rst 

for f in sec-introduction sec-demonstration sec-how-to-use
do
    echo "Processing ${f}.tex"
    pandoc --filter pandoc-citeproc cmhlistings.tex ${f}.tex -o ${f}.rst --bibliography latex-indent.bib --bibliography contributors.bib
    perl -pi -e 's|:numref:``(.*?)``|:numref:`$1`|' ${f}.rst 
    perl -pi -e 's|\.\. \\\_|\.\. \_|' ${f}.rst 
done
exit
