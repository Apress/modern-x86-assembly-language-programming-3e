@echo off
set LOGDIR=@results
if not exist %LOGDIR%\nul mkdir %LOGDIR%
set CHDIR=..\..\Chapter17\x64\Release
set LOGFILE=%LOGDIR%\@run_ch17_win.txt

%CHDIR%\Ch17_01  >%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1
