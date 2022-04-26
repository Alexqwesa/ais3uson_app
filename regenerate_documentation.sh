#!/bin/bash
projectDir=`pwd`

if [ `basename $projectDir` !=  'ais3uson_app' ] ; then
  echo 'Current dir is not ais3uson_app'
  echo `basename $projectDir`
  exit 1
fi

# Clean old
rm -rf doc/api/

# Generate or exit
flutter pub global activate dartdoc # fix for https://githubhot.com/repo/dart-lang/dartdoc/issues/2934
flutter pub global run dartdoc . --use-categories || exit 1
#dartdoc || exit 1


## Add missed files
cp LICENSE doc/api/
mkdir doc/api/images/
cp images/_license.pdf doc/api/images/
mkdir doc/api/assets/
cp assets/ais-3uson-logo-128.png doc/api/assets/
cp qr_web3uson.png doc/api/
cp qrcode_ais3uson_app_on_google_play.png doc/api/

# gitHub wants docs dir - conform
rm -rf docs/*
cp -a doc/api/* docs/

# open generated docs in browser
if [ `echo $DISPLAY`  ==  '' ] ; then
  exit 1
fi
dhttpd --path doc/api &
xdg-open  http://localhost:8080 &