@echo off
set LOGDIR=@results
if not exist %LOGDIR%\nul mkdir %LOGDIR%
set CHDIR=..\..\Chapter15\x64\Release
set LOGFILE=%LOGDIR%\@run_ch15_win.txt

%CHDIR%\Ch15_01  >%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch15_02 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch15_03 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch15_04 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

move @Ch15* %LOGDIR%
