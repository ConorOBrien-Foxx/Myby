@ECHO OFF
REM I hate batch.
SET Error=0

IF "%1"=="clean" GOTO :CLEAN

:COMPILE
    SET FLAGS=-g -w
    SET FILES=src/main.d src/integer.d src/nibble.d src/literate.d src/interpreter.d
    SET FILES=%FILES% src/instructions.d src/string.d src/debugger.d src/prime.d
    SET FILES=%FILES% src/format.d src/speech.d src/manip.d src/memo.d
    dmd %FLAGS% %FILES% -of=myby.exe
    SET Error=%ERRORLEVEL%
    GOTO :End

:CLEAN
    DEL *.pdb *.exe *.ilk *.obj
    GOTO :End

:End
REM Set errorlevel. Yes, this is the best way.
CMD /C "EXIT /B %Error%"
