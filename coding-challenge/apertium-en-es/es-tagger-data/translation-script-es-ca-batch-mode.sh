#!/bin/sh

#Change to use the desired data and translation direction
DATA=$HOME/projects/apertium/coding-challenge/apertium-en-es
DIRECTION=es-en

FORMAT=txt
AUTOMORF=$DATA/$DIRECTION.automorf.bin
AUTOBIL=$DATA/$DIRECTION.autobil.bin
AUTOGEN=$DATA/$DIRECTION.autogen.bin
AUTOPGEN=$DATA/$DIRECTION.autopgen.bin

#gawk '{printf $0 "^.<sent>$[]" }' |\
apertium-pretransfer |\
apertium-transfer $DATA/trules-$DIRECTION.xml $DATA/trules-$DIRECTION.bin $AUTOBIL |\
lt-proc -d $AUTOGEN  |\
lt-proc -p $AUTOPGEN |\
apertium-re$FORMAT |\
sed -e "s/*\(\\w\+\)/\1/g" |\
sed -re "s/( )*[.]$//g" 
