@ECHO OFF
REM I hate batch.
SET Error=0

IF "%1"=="clean" GOTO :CLEAN

:COMPILE
    SET FLAGS=-g -w
    SETLOCAL EnableDelayedExpansion
    SET FILES=src\main.d
    FOR %%A IN (src\*.d) DO IF "%%~nxA" NEQ "main.d" SET FILES=!FILES! %%A
    dmd %FLAGS% %FILES% -of=myby.exe
    SET Error=%ERRORLEVEL%
    GOTO :End

:CLEAN
    DEL *.pdb *.exe *.ilk *.obj
    GOTO :End

:End
REM Set errorlevel. Yes, this is the best way.
CMD /C "EXIT /B %Error%"
