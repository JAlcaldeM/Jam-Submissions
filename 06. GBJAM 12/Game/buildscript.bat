@echo off

rem Cambia el nombre de la carpeta de builds
set buildFolder=Builds

rem Solicita el nombre del build
echo Enter the name of this build:
set /p buildName=

rem Crea la carpeta de builds si no existe
if not exist %buildFolder% (
    echo Adding build folder %buildFolder%
    mkdir %buildFolder%
)

rem Elimina la carpeta del build si ya existe
if exist %buildFolder%\%buildName% (
    echo Old build folder already exists
    echo Removing old folder
    rmdir /s /q %buildFolder%\%buildName%
)
mkdir %buildFolder%\%buildName%

rem Empaqueta todos los archivos en un archivo zip
"C:\Program Files\7-Zip\7z.exe" a %buildFolder%/%buildName%/%buildName%.zip "fonts" "graphics" "lib" "sounds" "src" "main.lua"

rem Renombra el archivo zip a archivo .love
rename %buildFolder%\%buildName%\%buildName%.zip %buildName%.love

rem Define un tamaño de memoria para la compilación
set numBytes=300000000

rem Compila usando love.js
call npx love.js.cmd -c -m %numBytes% %buildFolder%/%buildName%/%buildName%.love %buildFolder%/%buildName%/%buildName%

rem Elimina el archivo .love después de la compilación
del /q %buildFolder%\%buildName%\%buildName%.love

rem Crea un archivo zip listo para subir a itch.io
cd %buildFolder%
cd %buildName%
"C:\Program Files\7-Zip\7z.exe" a %buildName%.zip "%buildName%\*"
cd ..
cd ..
