#!/bin/bash
VERSION=$1

cp ~/projects/pos/build-pos-fe-base-Desktop_Qt_6_5_3_GCC_64bit-MinSizeRel/app/appposfe files/appposfe
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
#
# scp -P 1982 update_$VERSION.rcc sadeq@ganjan.snono.systems:/tmp
cp update_$VERSION.rcc /home/sadeq/projects/pos/build-pos-be-base-Desktop_Qt_6_5_2_GCC_64bit-MinSizeRel/app/storage/updates/fe/linux-x86_64
