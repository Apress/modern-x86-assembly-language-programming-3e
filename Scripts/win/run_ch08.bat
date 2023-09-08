@echo off
set LOGDIR=@results
if not exist %LOGDIR%\nul mkdir %LOGDIR%
set CHDIR=..\..\Chapter08\x64\Release
set LOGFILE=%LOGDIR%\@run_ch08_win.txt

%CHDIR%\Ch08_01  >%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch08_02 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch08_03 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch08_04 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch08_05 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch08_06 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1
