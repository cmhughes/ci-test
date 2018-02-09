#!/bin/sh

echo "PUSH!"
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"
git checkout master
cp testing.pl cmhtestfile.pl
git add cmhtestfile.pl
git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
git status
git remote add origin https://${GH_TOKEN}@github.com/MVSE-outreach/resources.git > /dev/null 2>&1
git remote -v
git push 

exit
