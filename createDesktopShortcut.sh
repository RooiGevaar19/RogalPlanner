#!/bin/bash
echo Starting...

# ========= Edit arguments

ShortcutLabel="RogalPlanner"
ExecutablePath=rogal
Shortcut=RogalPlanner.desktop
Version=0.0
OpensInTerminal=true
Description="A planning application using RogalScript"
IconPath=rogal.ico

# ========= MAGIC HAPPENS BELOW

if ! command -v xdg-user-dir &> /dev/null then
then
    echo "Warning: xdg-user-dir not installed on this computer."
    echo "Using explicit ~/Desktop as the Desktop path. This path might not exist on non-English OSes."
    Path=~/Desktop
else
    Path=`xdg-user-dir DESKTOP`
fi

echo "#!/usr/bin/env xdg-open" > $Path/$Shortcut
echo "[Desktop Entry]" >> $Path/$Shortcut
echo "Version=$Version" >> $Path/$Shortcut
echo "Type=Application" >> $Path/$Shortcut
echo "Terminal=$OpensInTerminal" >> $Path/$Shortcut
echo "Exec=$(pwd)/$ExecutablePath" >> $Path/$Shortcut
echo "Name=$ShortcutLabel" >> $Path/$Shortcut
echo "Comment=$Description" >> $Path/$Shortcut
echo "Icon=$(pwd)/$IconPath" >> $Path/$Shortcut

if [ -f $Path/$Shortcut ] ; then
	chmod +x $Path/$Shortcut
	echo "The shortcut of $ShortcutLabel has been created at $Path."
else
    echo "Error: cannot create a shortcut at $Path."
fi
