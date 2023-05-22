#!/bin/bash
VERSION=$1

cp ~/projects/pos/build-pos-fe-base-Desktop_Qt_6_5_0_GCC_64bit-MinSizeRel/app/appposfe.exe files/appposfe.exe
if test -f "update_$VERSION.rcc"; then
    rm update_$VERSION.rcc
fi
cd files;
if test -f "sha256sums.txt"; then
    rm sha256sums.txt
fi
#sha256sum * > sha256sums.txt
find * -type f -exec sha256sum "{}" + > sha256sums.txt
cd ../;
rcc -binary update.qrc -o update_$VERSION.rcc

# scp -P 1982 update_$VERSION.rcc sadeq@ganjan.snono.systems:/tmp
