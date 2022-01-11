#!/bin/bash
projectDir=`pwd`
#cd $projectDir

if [ `basename $projectDir`  !=  'ais3uson_app' ] ; then
  echo 'Current dir is not ais3uson_app'
  echo `basename $projectDir`
  exit 1
fi

# Clean old
rm -rf doc/api/

# Generate
dartdoc

# Add missed files
for f in $(find ./lib/ -name "*.png" -print) ; do
    dir=`dirname $f`
    dir=${dir#"./lib/"}
    dir=${dir//"/"/"_"}
    set -x
    cp -a "$f" "doc/api/${dir}_$(basename $f .png)/$(basename $f)"
    set +x
done

cp LICENSE doc/api/
mkdir doc/api/images/
cp images/license.pdf doc/api/images/
mkdir doc/api/assets/
cp assets/ais-3uson-logo-128.png doc/api/assets/
cp ./lib/source/journal/journal.png  doc/api/Journal/journal.png


dhttpd --path doc/api &

xdg-open  http://localhost:8080 &

rm -rf docs/*
cp -a doc/api/* docs/
