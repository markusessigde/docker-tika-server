#! /bin/bash


convert $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11}

echo "run image processing on ${11} using opencv"

/app/image_processing.py ${11}

echo "finish image processing on ${11} using opencv"