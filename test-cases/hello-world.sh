#!/bin/bash
echo "hello world"
echo "again again"
#perl myfile.pl
cp environments/environments-nested-fourth.tex ../
cd ../
perl testing.pl environments-nested-fourth
perl testing.pl environments-nested-fourth.tex
perl testing.pl -w environments-nested-fourth.tex
exit
