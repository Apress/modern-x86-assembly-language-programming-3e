@echo off
set LOGDIR=@results
if not exist %LOGDIR%\nul mkdir %LOGDIR%
set CHDIR=..\..\Chapter02\x64\Release
set LOGFILE=%LOGDIR%\@run_ch02_win.txt

%CHDIR%\Ch02_01  >%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch02_02 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch02_03 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch02_04 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch02_05 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1
