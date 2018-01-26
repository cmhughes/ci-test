#!/bin/bash
echo "hello world"
echo "again again"
#perl myfile.pl
cp environments/environments-nested-fourth.tex ../
cp environments/env-all-on.yaml ../localSettings.yaml
cp environments/env-all-on.yaml ../env-all-on.yaml
cd ../
perl testing.pl environments-nested-fourth
perl testing.pl environments-nested-fourth.tex
perl testing.pl -w environments-nested-fourth.tex
perl testing.pl -l -m environments-nested-fourth
perl testing.pl -l=env-all-on -m environments-nested-fourth
cat environments-nested-fourth.tex|perl testing.pl
exit
