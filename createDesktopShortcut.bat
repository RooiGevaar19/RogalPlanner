@echo off
set /A directory=value
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%userprofile%\Desktop\RogalPlanner.lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%cd%\rogal.exe" >> CreateShortcut.vbs
echo oLink.WorkingDirectory = "%cd%" >> CreateShortcut.vbs
echo oLink.Description = "Run RogalPlanner Application" >> CreateShortcut.vbs
echo oLink.IconLocation = "%cd%\rogal.ico" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript CreateShortcut.vbs
del CreateShortcut.vbs
echo The shortcut of RogalPlanner has been created on Desktop.
pause
