#!/bin/bash
# Author : Dushan Wijesinghe | 2021
IFS='
'

x=($(cat $1 | awk '{print $1, "^"$2, "^"$3}'))
y=($(cat $1 | awk '{first = $1; $1 = ""; second = $2; $2 = "" ; third = $3; $3 = ""; print "^"$0 }'))
loop=${#x[*]}
for ((z=0; z<=$loop; z++))
do
  echo "${x[$z]}" "${y[$z]}" >> $1`date +%H%M`.s3
done
