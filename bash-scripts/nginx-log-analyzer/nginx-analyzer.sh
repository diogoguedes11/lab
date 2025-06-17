#!/bin/bash

FILENAME='./nginx-access.log.txt'


echo -e "Top 5 IP addresses with the most requests:"

awk '{print $1}' $FILENAME | sort | uniq -c  | sort -nr | head -n5 | awk '{printf " %s - %s requests\n",$2,$1}' 

echo # newline

echo -e "Top 5 most requested paths:"

awk '{print $7}' $FILENAME | sort | uniq -c | sort -nr | head -n5 | awk '{printf "%s - %s requests\n",$2,$1}' 

echo # newline

echo -e "Top 5 response status codes:"

awk '{print $9}' $FILENAME | sort | uniq -c | sort -nr | head -n5 | awk '{printf "%s - %s requests\n",$2,$1}'

