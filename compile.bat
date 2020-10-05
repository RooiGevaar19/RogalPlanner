@echo off
echo Starting...
"C:\lazarus\lazbuild.exe" rogal.lpi
if %ERRORLEVEL% == 0 goto :next
goto :end

:next
    echo.
    echo.
    echo ================================================================ 
    echo Successfully compiled!
    echo ================================================================

:end
    pause