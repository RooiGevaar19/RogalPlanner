#!/bin/bash

echo "Starting..."

lazbuild rogal.lpi

if [ $? -eq 0 ] ; then
	echo
	echo
	echo "=============================================================================="
	echo "Successfully compiled!"
	echo "Run createDesktopShortcut.sh\ to create a Desktop shortcut of the application."
	echo "=============================================================================="
fi
