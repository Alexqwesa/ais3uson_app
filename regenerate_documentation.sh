#!/bin/bash
projectDir=`dirname $0`
cd $projectDir

#dartdoc
for f in `find ./lib/ -name '*.png' -print` ; do
    dir=`dirname $f`
    dir=${dir#'./lib/'}
    dir=${dir//"/"/"_"}
    cp -r $f doc/api/${dir}_`basename $f .png`/`basename $f`
done

cp LICENSE doc/api/