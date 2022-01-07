#!/bin/bash
projectDir=`dirname $0`
cd $projectDir

# Generate
dartdoc

# Add missed files
for f in `find ./lib/ -name '*.png' -print` ; do
    dir=`dirname $f`
    dir=${dir#'./lib/'}
    dir=${dir//"/"/"_"}
    cp -r $f doc/api/${dir}_`basename $f .png`/`basename $f`
done

cp LICENSE doc/api/

dhttpd --path doc/api &

xdg-open  http://localhost:8080