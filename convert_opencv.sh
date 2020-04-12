#! /bin/bash

echo "called convert $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14}" >> /image_processing.log

convert $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} 

echo "run image processing on ${11} using opencv" >> /image_processing.log

/app/image_processing.py -i ${13}

cp ${13} /app/$(basename -- ${13})

echo "finish image processing on ${13} using opencv" >> /image_processing.log
