@ECHO OFF
REM I hate batch.
SET Error=0

IF "%1"=="clean" GOTO :CLEAN

:COMPILE
    SET FLAGS=-g -w
    SET FILES=main.d integer.d nibble.d literate.d interpreter.d instructions.d string.d debugger.d
    dmd %FLAGS% %FILES% -of=myby.exe
    SET Error=%ERRORLEVEL%
    GOTO :End

:CLEAN
    DEL *.pdb *.exe *.ilk *.obj
    GOTO :End

:End
REM Set errorlevel. Yes, this is the best way.
CMD /C "EXIT /B %Error%"