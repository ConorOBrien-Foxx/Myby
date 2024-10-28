@ECHO OFF
REM I hate batch.
SET Error=0

IF "%1"=="clean" GOTO :CLEAN
SET TEST=
IF "%1"=="test" SET TEST=test

:COMPILE
    SET FLAGS=-g -w
    IF "%TEST%" NEQ "" (
        ECHO Compiling for unit tests...
        SET FLAGS=%FLAGS% -unittest
    )
    SETLOCAL EnableDelayedExpansion
    SET FILES=src\main.d
    FOR %%A IN (src\*.d) DO IF "%%~nxA" NEQ "main.d" SET FILES=!FILES! %%A
    dmd %FLAGS% %FILES% -of=myby.exe
    SET Error=%ERRORLEVEL%
    IF "%TEST%" NEQ "" (
        ECHO Running compiled unit tests...
        myby.exe
        ECHO Recompiling without tests...
        %0
        ECHO Running external blackbox tests...
        ruby test\test.rb
    )
    GOTO :End

:CLEAN
    DEL *.pdb *.exe *.ilk *.obj
    GOTO :End

:End
REM Set errorlevel. Yes, this is the best way.
CMD /C "EXIT /B %Error%"
