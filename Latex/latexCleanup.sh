#!/bin/sh
#find all .tex files in current dir
DIR=`pwd`
TEX_FILE=`ls "$DIR" | grep *.tex`
latexmk -c $TEX_FILE
SYNCTEX_ARCH=`echo $TEX_FILE | sed -e s/.tex//`
SYNCTEX_ARCH="$SYNCTEX_ARCH.synctex.gz"
rm $SYNCTEX_ARCH