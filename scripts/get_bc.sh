#! /bin/bash
# written by Martin Schilling
# this script cuts out the barcode from a file

while read line 
do 
	#bc=$(echo "$line" | cut -f6 -d,)   # if space-delimited: then -d$' '
	#key=$(echo "$line" | cut -f5 -d,)  # if tab-delimited, then -d$'\t'
	id=$(echo $line | cut -f3 -d,)
	#printf $key','$bc','$id'\n'
	echo $id
done < $1
