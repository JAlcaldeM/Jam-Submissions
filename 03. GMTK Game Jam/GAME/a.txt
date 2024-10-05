@echo off
set buildFolder=Builds
echo Enter the name of this build :
set /p buildName=
echo %buildFolder%
echo %buildName%

if not exist %buildFolder% (
    echo adding build folder %buildFolder%
    mkdir %buildFolder%
)
if exist %buildFolder%\%buildName% (
    echo old build folder already exists
    echo removing old folder
    rmdir /s /q %buildFolder%\%buildName%
)
mkdir %buildFolder%\%buildName%

echo zipping up all files into %buildName%.zip
"C:\Program Files\7-Zip\7z.exe" a %buildFolder%/%buildName%/%buildName%.zip "fonts" "graphics" "lib" "sounds" "src" "main.lua"

echo renaming zip file to love file
rename %buildFolder%\%buildName%\%buildName%.zip %buildName%.love

@REM Compute the file size first
@REM For example, if the file size was 55426989 bytes, use something higher
set numBytes=150000000

echo building with love.js
call npx love.js.cmd -c -m %numBytes% %buildFolder%/%buildName%/%buildName%.love %buildFolder%/%buildName%/%buildName%

echo removing stale love file
del /q %buildFolder%\%buildName%\%buildName%.love

echo creating a zip file for itch.io right under the build folder
cd %buildFolder%
cd %buildName%
"C:\Program Files\7-Zip\7z.exe" a %buildName%.zip "%buildName%\*"
cd ..
cd ..

echo finished build
