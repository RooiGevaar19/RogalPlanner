#!/bin/bash

echo "Starting..."

lazbuild rogal.lpi

if [ $? -eq 0 ] ; then
	echo
	echo
	echo "==================================================================="
	echo "Successfully compiled!"
	echo "==================================================================="
filazbuild rogal.lpi
