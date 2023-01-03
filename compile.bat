@ECHO OFF
REM I hate batch.
SET Error=0

IF "%1"=="clean" GOTO :CLEAN

:COMPILE
    SET FLAGS=-g -w
    REM TODO: surely there's a way to emulate src/*.d
    REM SET FILES=src/main.d src/integer.d src/nibble.d src/literate.d src/interpreter.d
    REM SET FILES=%FILES% src/instructions.d src/string.d src/debugger.d src/prime.d
    REM SET FILES=%FILES% src/format.d src/speech.d src/manip.d src/memo.d src/condense.d
    REM SET FILES=%FILES% src/token.d src/json.d
    REM SET FILES=%FILES% src/verbs.d src/adjectives.d src/conjunctions.d
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
