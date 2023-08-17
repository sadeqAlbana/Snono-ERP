@echo off
setlocal

set "VERSION=%1"

copy "C:\Users\sadeq\projects\build-pos-fe-base-Desktop_Qt_6_5_2_MSVC2019_64bit-MinSizeRel\app\appposfe.exe" "files\appposfe.exe"

if exist "update_%VERSION%.rcc" (
    del "update_%VERSION%.rcc"
)

cd files

if exist sha256sums.txt (
    del sha256sums.txt
)

(for %%F in (*) do (
    for /f %%H in ('certutil -hashfile "%%F" SHA256 ^| find /v ":"') do (
        echo %%H  %%F
    )
)) > sha256sums.txt

cd ..
C:\Qt\6.5.2\msvc2019_64\bin\rcc.exe -binary update.qrc -o "update_%VERSION%.rcc"

endlocal