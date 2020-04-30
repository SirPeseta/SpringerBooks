#!/bin/bash

file1='links.txt'
file2='booknames.txt'

i=1

touch $file2

echo "Getting booknames:"

N=$(wc -l links.txt | awk '{print $1}')

while read line; do
	echo -e "\tGetting bookname $i of $N"
	wget $line > prueba.txt 2>&1
	rm -f openurl*
	link_real=$(cat prueba.txt | grep -e "https://link.springer.com/book" -m1 | awk '{print $2}' | tr [=/=] "\n" | tail -n 1)
	echo "$link_real" >> $file2

	i=$((i+1))
done < $file1

echo "Booknames saved on $file2"

rm -f openurl* prueba.txt

i=1

mkdir books

echo -e "\nDownloading books and saving on books folder:"

while read line; do
	echo -e "\tDownloading book $i of $N"

	number=$(echo "$line")
	variable=$(echo "https://link.springer.com/content/pdf/$number.pdf")
	cd books/
	curl -O -J -s $variable
	cd ..
	

	i=$((i+1))
done < $file2