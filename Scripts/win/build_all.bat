@echo off

call build_ch 02 %1
if errorlevel 1 goto DONE
call build_ch 03 %1
if errorlevel 1 goto DONE
call build_ch 04 %1
if errorlevel 1 goto DONE
call build_ch 05 %1
if errorlevel 1 goto DONE

call build_ch 06 %1
if errorlevel 1 goto DONE
call build_ch 07 %1
if errorlevel 1 goto DONE
call build_ch 08 %1
if errorlevel 1 goto DONE
call build_ch 09 %1
if errorlevel 1 goto DONE

call build_ch 10 %1
if errorlevel 1 goto DONE
call build_ch 11 %1
if errorlevel 1 goto DONE
call build_ch 12 %1
if errorlevel 1 goto DONE
call build_ch 13 %1
if errorlevel 1 goto DONE

call build_ch 14 %1
if errorlevel 1 goto DONE
call build_ch 15 %1
if errorlevel 1 goto DONE
call build_ch 16 %1
if errorlevel 1 goto DONE
call build_ch 17 %1
if errorlevel 1 goto DONE

:DONE
echo build_all is complete.
