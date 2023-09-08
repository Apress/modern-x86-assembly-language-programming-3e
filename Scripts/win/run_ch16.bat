@echo off
set LOGDIR=@results
if not exist %LOGDIR%\nul mkdir %LOGDIR%
set CHDIR=..\..\Chapter16\x64\Release
set LOGFILE=%LOGDIR%\@run_ch16_win.txt

%CHDIR%\Ch16_01  >%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch16_02 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch16_03 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch16_04 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

%CHDIR%\Ch16_05 >>%LOGFILE% 2>&1
type nl.txt     >>%LOGFILE% 2>&1

move @Ch16* %LOGDIR%
