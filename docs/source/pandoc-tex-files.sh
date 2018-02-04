#!/bin/bash

for f in sec-introduction sec-demonstration sec-how-to-use sec-indent-config-and-settings
do
    echo "Processing ${f}.tex"
    pandoc --filter pandoc-citeproc cmhlistings.tex ${f}.tex -o ${f}.rst --bibliography latex-indent.bib --bibliography contributors.bib
    perl -pi -e 's|:numref:``(.*?)``|:numref:`$1`|g' ${f}.rst 
    perl -pi -e 's|\.\. \\\_|\.\. \_|g' ${f}.rst 
    # some code blocks need special treatment
    perl -p0i -e 's/^::(?:\R|\h)*\{(.*?)\}\{((?:(?!(?:\{)).)*?)\}$/\.\. code-block:: latex\n   :caption: $1\n   :name: $2\n/msg' ${f}.rst
    # and this can lead to \\texttt still being present in .rst
    perl -p0i -e 's/\\texttt\{(.*?)\}/``$1``/sg' ${f}.rst
    # remove line breaks from :alt: text
    perl -p0i -e 's/(:alt:.*?)\R{2}(\h*)/\n\n$2/gs' ${f}.rst
done
exit
