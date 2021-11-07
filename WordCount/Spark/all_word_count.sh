#!/bin/bash
echo "Start" > time.txt
for filename in ../../dataset/*.txt; do 
    basename $filename .txt >> time.txt;
    { time spark-submit word_count.py $filename ./1/$(basename $filename .txt)/ ; } 2>> time.txt
    { time spark-submit word_count.py $filename ./2/$(basename $filename .txt)/ ; } 2>> time.txt
    { time spark-submit word_count.py $filename ./3/$(basename $filename .txt)/ ; } 2>> time.txt
done