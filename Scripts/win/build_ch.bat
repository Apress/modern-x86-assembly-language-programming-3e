@echo off
if "%1" == "" goto ERR1

set CHNUM=%1
set CHDIR=..\..\Chapter%CHNUM%
if "%2" == "" set BUILDCMD=build
if not "%2" == "" set BUILDCMD=%2

pushd %CHDIR%
if errorlevel 1 goto ERR2
msbuild Chapter%CHNUM%.sln /p:Configuration=Release /p:Platform=x64 /maxcpucount:4 /t:%BUILDCMD%
popd
goto DONE

:ERR1
echo missing chapter number: CHNUM = %CHNUM%
echo see readme.txt for usage information
goto DONE

:ERR2
echo invalid chapter directory: CHDIR = %CHDIR%
echo see readme.txt for usage information
goto DONE

:DONE
echo.
echo build_ch %CHDIR% is complete.
echo.
