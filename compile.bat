@echo off
echo Starting...
"C:\lazarus\lazbuild.exe" rogal.lpi
if %ERRORLEVEL% == 0 goto :next
goto :end

:next
    echo.
    echo.
    echo ================================================================================ 
    echo Successfully compiled!
    echo Run createDesktopShortcut.bat to to create a Desktop shortcut of the application
    echo ================================================================================

:end
    pause