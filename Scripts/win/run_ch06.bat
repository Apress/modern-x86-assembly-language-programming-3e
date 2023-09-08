@echo off
set LOGDIR=@results
if not exist %LOGDIR%\nul mkdir %LOGDIR%
set CHDIR=..\..\Chapter06\x64\Release
set LOGFILE=%LOGDIR%\@run_ch06_win.txt

%CHDIR%\Ch06_01  >%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch06_02 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch06_03 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch06_04 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1
