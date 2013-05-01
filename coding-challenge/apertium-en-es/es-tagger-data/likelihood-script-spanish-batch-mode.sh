#!/bin/sh

#Change to use the desired language model 
LMDATA=spanish.lm

apertium-trigrams-langmodel-perline -e -i $LMDATA  2>/dev/null
