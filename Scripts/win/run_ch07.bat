@echo off
set LOGDIR=@results
if not exist %LOGDIR%\nul mkdir %LOGDIR%
set CHDIR=..\..\Chapter07\x64\Release
set LOGFILE=%LOGDIR%\@run_ch07_win.txt

%CHDIR%\Ch07_01  >%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1
