@ECHO off

IF NOT "x%1" == "x" GOTO :%1

:example
ECHO "Building agent"
IF NOT EXIST lit.exe CALL Make.bat lit
CALL lit.exe make
GOTO :end

:lit
ECHO "Building lit"
PowerShell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://github.com/luvit/lit/raw/2.1.8/get-lit.ps1'))"
GOTO :end

:clean
IF EXIST example.exe DEL /F /Q example.exe
IF EXIST lit.exe DEL /F /Q lit.exe
IF EXIST luvi.exe DEL /F /Q luvi.exe

:end
