#!/bin/bash
#
# DESCRIPTION:
# This script is intended to find all image files
# 
# USAGE: ./script <search path> 
# 
# AUTHOR:					
# 11/2019, Valentin Georgiev <dev@vgeorgiev.net> 
# ==============================================

if [ -z $1 ]; then
	echo ""
	echo "Please provide search path '/PATH' or '.' for current directory"
	echo "USAGE: $0 <search path>"
	echo ""	
	exit
fi  

find $1 -type f \( -iname '*.jpg'       -o \
		-iname '*.jpeg'         -o \
                -iname '*.png'          -o \
                -iname '*.exif'         -o \
                -iname '*.tiff'         -o \
                -iname '*.gif'          -o \
                -iname '*.bmp'	        -o \
                -iname '*.ppm'	        -o \
                -iname '*.bpg'          -o \
                -iname '*.svg'         	-o \
                -iname '*.cgm'     	 \) -exec ls -lh {} +
