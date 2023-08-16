@echo off
set VERSION=%1

copy C:\Users\<username>\projects\pos\build-pos-fe-base-Desktop_Qt_6_5_0_GCC_64bit-MinSizeRel\app\appposfe.exe files\appposfe.exe

if exist "update_%VERSION%.rcc" (
    del "update_%VERSION%.rcc"
)

cd files

if exist sha256sums.txt (
    del sha256sums.txt
)

for %%F in (*) do (
    certutil -hashfile "%%F" SHA256 | findstr /r "^[0-9a-fA-F]*" > sha256sums.txt
)

cd ..
rcc -binary update.qrc -o "update_%VERSION%.rcc"