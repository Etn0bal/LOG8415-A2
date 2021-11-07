#!/bin/bash
for filename in ../../dataset/*.txt; do 
    touch $(basename $filename);
    { time spark-submit word_count.py $filename ./1/$(basename $filename .txt)/ ; } 2>> $(basename $filename)
    { time spark-submit word_count.py $filename ./2/$(basename $filename .txt)/ ; } 2>> $(basename $filename)
    { time spark-submit word_count.py $filename ./3/$(basename $filename .txt)/ ; } 2>> $(basename $filename)
done