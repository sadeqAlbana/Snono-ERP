$VERSION = $args[0]

Copy-Item -Path ~/projects/pos/build-pos-fe-base-Desktop_Qt_6_5_0_GCC_64bit-MinSizeRel/app/appposfe.exe -Destination files/appposfe.exe -Force

if (Test-Path "update_$VERSION.rcc") {
    Remove-Item "update_$VERSION.rcc"
}

Set-Location files

if (Test-Path "sha256sums.txt") {
    Remove-Item "sha256sums.txt"
}

Get-ChildItem -File | ForEach-Object {
    Get-FileHash $_.FullName -Algorithm SHA256 | ForEach-Object {
        "{0}  {1}" -f $_.Hash, $_.Path
    }
} | Set-Content sha256sums.txt

Set-Location ../

& rcc -binary update.qrc -o "update_$VERSION.rcc"